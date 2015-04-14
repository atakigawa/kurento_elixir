defmodule KC.MO.ServerManager do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.MediaObject

  @moduledoc """
  This is a standalone object for managing the MediaServer.

  """

  defstruct id: ""

  def get do
    # ServerManager is a pre-defined object in KMS.
    id = "manager_ServerManager"
    %__MODULE__{id: id}
  end

  @doc """
  Server information, version, modules, factories, etc.
  """
  def getInfo(%{id: id}) do
    {funcName, _} = __ENV__.function
    KC.Core.syncInvoke(id, funcName)
  end

  @doc """
  All the pipelines available in the server.
  """
  def getPipelines(%{id: id}) do
    {funcName, _} = __ENV__.function
    KC.Core.syncInvoke(id, funcName)
  end

  @doc """
  All active sessions in the server.
  """
  def getSessions(%{id: id}) do
    {funcName, _} = __ENV__.function
    KC.Core.syncInvoke(id, funcName)
  end


  # does not seem to exist in v5.1.1

  #def subscribeObjectCreated(%{id: id}) do
  #  evtType = "objectCreated"
  #  KC.Core.syncSubscribe(id, evtType)
  #end

  #def subscribeObjectDestroyed(%{id: id}) do
  #  evtType = "ObjectDestroyed"
  #  KC.Core.syncSubscribe(id, evtType)
  #end
end
