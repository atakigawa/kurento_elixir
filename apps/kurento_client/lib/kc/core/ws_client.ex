defmodule KC.Core.WSClient do
  require Logger
  use GenServer

  @sessionIdKeySuffix "kms_sessid"

  ## Client API

  def start_link(initInfo, opts \\ []) do
    GenServer.start_link(__MODULE__, initInfo, opts)
  end

  def sendReq(wsc, method, params) do
    GenServer.call(wsc, {:send_req, method, params})
  end

  ## Server callbacks

  def init({{addr, port, path}, eventHandler}) do
    conn = socketCreate(addr, port, path)
    pfx = KC.Util.SecureRandom.hex(8) <> "-"
    seq0 = 1
    tag = pfx <> to_string(seq0)

    # connect to KMS
    # TODO try to get sessionId from ObjectStore. there already might be one.
    bin =
      createReqObj(tag, "connect", nil)
      |> KC.Core.JsonRpcUtil.serialize()

    socketSend(conn, bin)
    res = socketRecv(conn)

    case parseResponse(res) do
      {:response, %{"result" => result}} ->
        # save sessionId.
        sessionId = result["sessionId"]
        putSessionId(pfx, sessionId)

      {:error, %{"error" => errInfo}} ->
        errCode = errInfo["code"]
        errMsg = errInfo["message"]
        msg = "received error from KMS. code: #{errCode}. msg: #{errMsg}."
        Logger.error(msg)
        raise RuntimeError, message: msg
    end

    # start recv loop in another process.
    pid = self()
    spawn_link(fn -> socketRecvLoop(conn, pid) end)

    seq = seq0 + 1
    dict = Enum.into([
      conn: conn,
      pfx: pfx,
      seq: seq,
      pidMap: HashDict.new,
      eventHandler: eventHandler
    ], HashDict.new)

    {:ok, dict}
  end

  def handle_call({:send_req, method, params}, {fromPid, _}, dict0)
      when not is_nil(params) do
    conn = dict0[:conn]
    pfx = dict0[:pfx]
    seq0 = dict0[:seq]
    tag = pfx <> to_string(seq0)

    params = Dict.put(params, :sessionId, getSessionId(pfx))
    bin =
      createReqObj(tag, method, params)
      |> KC.Core.JsonRpcUtil.serialize()

    socketSend(conn, bin)

    seq = seq0 + 1
    dict =
      dict0
      |> Dict.put(:seq, seq)
      |> put_in([:pidMap, tag], fromPid) # save {tag -> pid} relation.

    {:reply, :ok, dict}
  end

  def handle_call({:process_response, bin}, _from, dict0) do
    dict = case parseResponse(bin) do
      # ok response from KMS.
      {:response, %{"id" => tag, "result" => result}} ->
        processResponse(tag, result, dict0)

      # onEvent notification from KMS.
      {:onEvent, %{"params" => params}} ->
        eventHandler = dict0[:eventHandler]
        eventHandler.notifyEvent(eventHandler, params)
        dict0

      # error response from KMS.
      {:error, %{"error" => errInfo}} ->
        errCode = errInfo["code"]
        #TODO if code === 40007, try reconnect
        msg = "Received error from KMS. " <>
          "code: #{errCode}. msg: #{errInfo["message"]}."
        Logger.error(msg)
        raise RuntimeError, message: msg
    end

    {:reply, :ok, dict}
  end

  defp socketCreate(addr, port, path) do
    Socket.Web.connect!(addr, port, path: path)
  end

  defp socketSend(conn, payload) do
    Socket.Web.send!(conn, {:text, payload})
  end

  defp socketRecv(conn) do
    {:text, bin} = Socket.Web.recv!(conn)
    bin
  end

  defp socketRecvLoop(conn, parent) do
    {:text, bin} = Socket.Web.recv!(conn)
    :ok = GenServer.call(parent, {:process_response, bin})
    socketRecvLoop(conn, parent)
  end

  defp parseResponse(resBin) do
    case KC.Core.JsonRpcUtil.deserialize(resBin) do
      # error response from KMS.
      %{"jsonrpc" => "2.0", "id" => _, "error" => %{} } = resObj ->
        {:error, resObj}

      # onEvent notificaiton from KMS.
      %{"jsonrpc" => "2.0", "id" => _, "method" => "onEvent",
          "params" => %{} } = resObj ->
        {:onEvent, resObj}

      # ok response from KMS.
      %{"jsonrpc" => "2.0", "id" => _, "result" => %{} } = resObj ->
        {:response, resObj}

      # json parse failure.
      %{"error" => %{"code" => errCode, "message" => errMsg}} ->
        msg = "json parse failed. code: #{errCode}. msg: #{errMsg}."
        Logger.error(msg)
        raise RuntimeError, message: msg

    end
  end

  defp processResponse(tag, result, dict0) do
    # Find pid to send result to.
    pid = get_in(dict0, [:pidMap, tag])
    if is_nil(pid) do
      msg = "Pid for tag:#{tag} not found."
      Logger.error(msg)
      raise RuntimeError, message: msg
    end

    send(pid, {:response, result})

    # return the new dict.
    pidMap =
      dict0[:pidMap]
      |> Dict.delete(tag)

    Dict.put(dict0, :pidMap, pidMap)
  end

  defp putSessionId(pfx, sessionId) do
    key = String.to_atom(pfx <> @sessionIdKeySuffix)
    {:ok, _} = KC.Core.ObjectStore.putSession(
      KC.Core.ObjectStore, key, sessionId)
    nil
  end

  defp getSessionId(pfx) do
    key = String.to_atom(pfx <> @sessionIdKeySuffix)
    {:ok, sessionId} = KC.Core.ObjectStore.getSession(
      KC.Core.ObjectStore, key)
    sessionId
  end

  defp createReqObj(tag, method, params) do
    ret = Enum.into([
      id: tag,
      method: method
    ], HashDict.new)

    if is_map(params) do
      ret = Dict.put(ret, :params, params)
    end

    ret
  end
end
