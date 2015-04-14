defmodule KC.Core.WSClient do
  require Logger
  use GenServer

  @sessionIdKeySuffix "kms_sessid"

  ## Client API

  def start_link(connInfo, opts \\ []) do
    GenServer.start_link(__MODULE__, connInfo, opts)
  end

  def sendReq(wsc, method, params) do
    GenServer.call(wsc, {:send_req, method, params})
  end

  ## Server callbacks

  def init({addr, port, path}) do
    conn = socketCreate(addr, port, path)
    myPrefix = KC.Util.SecureRandom.hex(8) <> "-"
    seq0 = 1
    tag = myPrefix <> to_string(seq0)

    # connect to KMS
    bin =
      createReqObj(tag, "connect", nil)
      |> KC.Core.JsonRpcUtil.serialize()

    socketSend(conn, bin)
    res = socketRecv(conn)

    case parseResponse(res) do
      {:ok, %{"result" => result}} ->
        # save sessionId.
        sessionId = result["sessionId"]
        putSessionId(myPrefix, sessionId)

      {:error, %{"error" => errInfo}} ->
        errCode = errInfo["code"]
        errMsg = errInfo["message"]
        msg = "received error from KMS. code: #{errCode}. msg: #{errMsg}."
        raise RuntimeError, message: msg
    end

    seq = seq0 + 1
    dict = Enum.into([conn: conn, myPrefix: myPrefix, seq: seq], HashDict.new)
    {:ok, dict}
  end

  def handle_call({:send_req, method, params}, from, dict0) when not is_nil(params) do
    conn = HashDict.get(dict0, :conn)
    myPrefix = HashDict.get(dict0, :myPrefix)
    seq0 = HashDict.get(dict0, :seq)
    tag = myPrefix <> to_string(seq0)

    params = HashDict.put(params, :sessionId, getSessionId(myPrefix))
    bin =
      createReqObj(tag, method, params)
      |> KC.Core.JsonRpcUtil.serialize()

    socketSend(conn, bin)
    res = socketRecv(conn)

    ret = case parseResponse(res) do
      # ok response from KMS. follows the KMS protocol spec.
      {:ok, %{"result" => result}} -> {:ok, result}

      # error response from KMS. follows the KMS protocol spec.
      {:error, %{"error" => errInfo}} ->
        errCode = errInfo["code"]
        errMsg = errInfo["message"]
        #TODO if code === 40007, try reconnect
        msg = "Received error from KMS. code: #{errCode}. msg: #{errMsg}."
        raise RuntimeError, message: msg
    end

    seq = seq0 + 1
    dict = HashDict.put(dict0, :seq, seq)
    {:reply, ret, dict}
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

  defp parseResponse(resBin) do
    case KC.Core.JsonRpcUtil.deserialize(resBin) do
      # error response from KMS. follows the KMS protocol spec.
      %{"jsonrpc" => "2.0", "id" => _, "error" => %{} } = resObj ->
        {:error, resObj}

      # ok response from KMS. follows the KMS protocol spec.
      %{"jsonrpc" => "2.0", "id" => _, "result" => %{} } = resObj ->
        {:ok, resObj}

      # json parse failure.
      %{"error" => %{"code" => errCode, "message" => errMsg}} ->
        msg = "json parse failed. code: #{errCode}. msg: #{errMsg}."
        raise RuntimeError, message: msg

    end
  end

  defp putSessionId(myPrefix, sessionId) do
    key = String.to_atom(myPrefix <> @sessionIdKeySuffix)
    {:ok, _} = KC.Core.ObjectStore.putSession(
      KC.Core.ObjectStore, key, sessionId)
    nil
  end

  defp getSessionId(myPrefix) do
    key = String.to_atom(myPrefix <> @sessionIdKeySuffix)
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
      ret = HashDict.put(ret, :params, params)
    end

    ret
  end
end
