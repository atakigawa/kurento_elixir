defmodule KC.Core.EventHandler do
  require Logger
  use GenServer

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def notifyEvent(eh, params) do
    GenServer.call(eh, {:event_notify, params})
  end

  ## Server callbacks

  def init(:ok) do
    {:ok, HashDict.new}
  end

  def handle_call({:event_notify, params}, _from, dict0)
      when not is_nil(params) do

    #TODO implement
    IO.puts("#{__MODULE__} event_notified")
    IO.inspect(params)

    dict = dict0
    {:reply, :ok, dict}
  end

end
