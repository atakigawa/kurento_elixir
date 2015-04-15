defmodule KC.MO.Elements.Dispatcher do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Core.Hub

  @kmsType "Dispatcher"
  @hubPort KC.MO.Core.HubPort

  @moduledoc """
  A :rom:cls:`Hub` that allows routing between arbitrary port pairs.

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
  Connects each corresponding :rom:enum:`MediaType` of
  the given source port with the sink port.
  """
  def connect(
      %__MODULE__{id: id},
      %@hubPort{id: sourceId},
      %@hubPort{id: sinkId}) do
    {funcName, _} = __ENV__.function
    params = [source: sourceId, sink: sinkId]
    KC.Core.syncInvoke(id, funcName, params)
  end

end
