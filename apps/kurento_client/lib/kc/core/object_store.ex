defmodule KC.Core.ObjectStore do
  require Logger
  use GenServer

  @sessKey :sess
  @moKey :mo
  @subKey :sub

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def getAll(oStore) do
    GenServer.call(oStore, {:get_all})
  end

  ## has funcs
  def hasSession(oStore, id) do
    has(oStore, [@sessKey, id])
  end

  def hasMediaObject(oStore, id) do
    has(oStore, [@moKey, id])
  end

  def hasSubscription(oStore, id) do
    has(oStore, [@subKey, id])
  end

  def has(oStore, keys) do
    GenServer.call(oStore, {:has, List.wrap(keys)})
  end

  ## get funcs
  def getSession(oStore, id) do
    get(oStore, [@sessKey, id])
  end

  def getMediaObject(oStore, id) do
    get(oStore, [@moKey, id])
  end

  def getSubscription(oStore, id) do
    get(oStore, [@subKey, id])
  end

  def get(oStore, keys) do
    GenServer.call(oStore, {:get, List.wrap(keys)})
  end

  ## delete funcs
  def deleteSession(oStore, id) do
    delete(oStore, [@sessKey, id])
  end

  def deleteMediaObject(oStore, id) do
    delete(oStore, [@moKey, id])
  end

  def deleteSubscription(oStore, id) do
    delete(oStore, [@subKey, id])
  end

  def delete(oStore, keys) do
    GenServer.call(oStore, {:delete, List.wrap(keys)})
  end

  ## put funcs
  def putSession(oStore, id, obj) do
    put(oStore, [@sessKey, id], obj)
  end

  def putMediaObject(oStore, id, obj) do
    put(oStore, [@moKey, id], obj)
  end

  def putSubscription(oStore, id, obj) do
    put(oStore, [@subKey, id], obj)
  end

  def put(oStore, keys, obj) do
    GenServer.call(oStore, {:put, List.wrap(keys), obj})
  end

  ## Server callbacks

  def init(:ok) do
    dict = Enum.into([
      {@sessKey, HashDict.new},
      {@moKey, HashDict.new},
      {@subKey, HashDict.new},
    ], HashDict.new)
    {:ok, dict}
  end

  def handle_call({:get_all}, _from, dict0) do
    {:reply, {:ok, dict0}, dict0}
  end

  def handle_call({:has, keys}, _from, dict0) do
    flag = get_in(dict0, keys) !== nil
    {:reply, flag, dict0}
  end

  def handle_call({:get, keys}, _from, dict0) do
    obj = get_in(dict0, keys)
    {:reply, {:ok, obj}, dict0}
  end

  def handle_call({:delete, keys}, _from, dict0) do
    lastKey = List.last(keys)
    firstKeys = List.delete_at(keys, -1)

    case length(firstKeys) do
      0 ->
        dict = HashDict.delete(dict0, lastKey)
      _ ->
        innerDict = get_in(dict0, firstKeys)
        innerDict = HashDict.delete(innerDict, lastKey)
        dict = put_in(dict0, firstKeys, innerDict)
    end
    {:reply, {:ok, nil}, dict}
  end

  def handle_call({:put, keys, obj}, _from, dict0) do
    dict = put_in(dict0, keys, obj)
    {:reply, {:ok, nil}, dict}
  end
end
