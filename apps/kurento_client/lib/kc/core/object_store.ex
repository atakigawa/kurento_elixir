defmodule KC.Core.ObjectStore do
  require Logger
  use GenServer

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def getAll(oStore) do
    GenServer.call(oStore, {:get_all})
  end

  def has(oStore, id) do
    GenServer.call(oStore, {:has, id})
  end

  def get(oStore, id) do
    GenServer.call(oStore, {:get, id})
  end

  def delete(oStore, id) do
    GenServer.call(oStore, {:delete, id})
  end

  def put(oStore, id, obj) do
    GenServer.call(oStore, {:put, id, obj})
  end

  ## Server callbacks

  def init(:ok) do
    {:ok, HashDict.new}
  end

  def handle_call({:get_all}, _from, dict0) do
    {:reply, {:ok, dict0}, dict0}
  end

  def handle_call({:has, id}, _from, dict0) do
    flag = HashDict.has_key?(dict0, id)
    {:reply, {:ok, flag}, dict0}
  end

  def handle_call({:get, id}, _from, dict0) do
    obj = HashDict.get(dict0, id)
    {:reply, {:ok, obj}, dict0}
  end

  def handle_call({:delete, id}, _from, dict0) do
    dict = HashDict.delete(dict0, id)
    {:reply, {:ok, id}, dict}
  end

  def handle_call({:put, id, obj}, _from, dict0) do
    dict = HashDict.put(dict0, id, obj)
    {:reply, {:ok, id}, dict}
  end
end
