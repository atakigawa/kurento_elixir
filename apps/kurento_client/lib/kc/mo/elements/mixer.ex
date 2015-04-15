defmodule KC.MO.Elements.Mixer do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Core.Hub

  @kmsType "Mixer"
  @hubPort KC.MO.Core.HubPort

  @moduledoc """
  A :rom:cls:`Hub` that allows routing of video
  between arbitrary port pairs and mixing of
  audio among several ports.

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
      mediaType,
      %@hubPort{id: sourceId},
      %@hubPort{id: sinkId}) do
    {funcName, _} = __ENV__.function
    params = [media: mediaType, source: sourceId, sink: sinkId]
    KC.Core.syncInvoke(id, funcName, params)
  end

  @doc """
  Disconnects each corresponding :rom:enum:`MediaType`
  of the given source port from the sink port.
  """
  def disconnect(
      %__MODULE__{id: id},
      mediaType,
      %@hubPort{id: sourceId},
      %@hubPort{id: sinkId}) do
    {funcName, _} = __ENV__.function
    params = [media: mediaType, source: sourceId, sink: sinkId]
    KC.Core.syncInvoke(id, funcName, params)
  end

end
