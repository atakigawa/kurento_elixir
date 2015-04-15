defmodule KC.MO.Elements.DispatcherOneToMany do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Core.Hub

  @kmsType "DispatcherOneToMany"
  @hubPort KC.MO.Core.HubPort

  @moduledoc """
  A :rom:cls:`Hub` that sends a given source to all the
  connected sinks.

  """

  defstruct id: "",  mediaPipeline: ""

  def create(%KC.MO.Core.MediaPipeline{id: mpId}) do
    params = [mediaPipeline: mpId]
    id = KC.Core.syncCreate(@kmsType, params)

    %__MODULE__{id: id, mediaPipeline: mpId}
  end

  def release(%__MODULE__{id: id}) do
    KC.Core.syncRelease(id)
  end

  @doc """
  Sets the source port that will be connected to the sinks of
  every :rom:cls:`HubPort` of the dispatcher
  """
  def setSource(%__MODULE__{id: id}, %@hubPort{id: sourceId}) do
    {funcName, _} = __ENV__.function
    params = [source: sourceId]
    KC.Core.syncInvoke(id, funcName, params)
  end

  @doc """
  Remove the source port and stop the media pipeline.
  """
  def removeSource(%__MODULE__{id: id}) do
    {funcName, _} = __ENV__.function
    KC.Core.syncInvoke(id, funcName)
  end
end
