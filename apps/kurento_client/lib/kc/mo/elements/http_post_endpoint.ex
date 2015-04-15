defmodule KC.MO.Elements.HttpPostEndpoint do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Elements.HttpEndpoint

  @kmsType "HttpPostEndpoint"

  @moduledoc """
  An :rom:cls:`HttpPostEndpoint` contains SINK pads for AUDIO and VIDEO,
  which provide access to an HTTP file upload function

  This type of endpoint provide unidirectional communications.
  Its :rom:cls:`MediaSources <MediaSource>` are accessed through the
  :term:`HTTP` POST method.

  """

  defstruct [
    id: "",
    mediaPipeline: "",
    disconnectionTimeout: 0,
    useEncodedMedia: false
  ]

  def create(
      %KC.MO.Core.MediaPipeline{id: mpId},
      disconnectionTimeout \\ 2,
      useEncodedMedia \\ false) do

    params = [
      mediaPipeline: mpId,
      disconnectionTimeout: disconnectionTimeout,
      useEncodedMedia: useEncodedMedia
    ]
    id = KC.Core.syncCreate(@kmsType, params)

    %__MODULE__{
      id: id,
      mediaPipeline: mpId,
      disconnectionTimeout: disconnectionTimeout,
      useEncodedMedia: useEncodedMedia
    }
  end

  def release(%__MODULE__{id: id}) do
    KC.Core.syncRelease(id)
  end

  def subscribeEndOfStream(%{id: id}) do
    evtType = "EndOfStream"
    KC.Core.syncSubscribe(id, evtType)
  end
end
