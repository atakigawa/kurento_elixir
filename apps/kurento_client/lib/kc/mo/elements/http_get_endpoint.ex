defmodule KC.MO.Elements.HttpGetEndpoint do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Elements.HttpEndpoint

  @kmsType "HttpGetEndpoint"
  @mpst KC.MO.Elements.MediaProfileSpecType

  @moduledoc """
  An ``HttpGetEndpoint`` contains SOURCE pads for AUDIO and VIDEO,
  delivering media using HTML5 pseudo-streaming mechanism.

  This type of endpoint provide unidirectional communications.
  Its :rom:cls:`MediaSink` is associated with the HTTP GET method.

  """

  defstruct [
    id: "",
    mediaPipeline: "",
    terminateOnEOS: false,
    mediaProfile: "",
    disconnectionTimeout: 0
  ]

  def create(
      %KC.MO.Core.MediaPipeline{id: mpId},
      terminateOnEOS \\ false,
      mediaProfile \\ @mpst.webm,
      disconnectionTimeout \\ 2) do
    Enum.any?(@mpst.allowedMediaProfiles, fn x -> x === mediaProfile end) ||
      raise ArgumentError,
        "mediaProfile expected to be one of #{inspect @mpst.allowedMediaProfiles}"

    params = [
      mediaPipeline: mpId,
      terminateOnEOS: terminateOnEOS,
      mediaProfile: mediaProfile,
      disconnectionTimeout: disconnectionTimeout
    ]
    id = KC.Core.syncCreate(@kmsType, params)

    %__MODULE__{
      id: id,
      mediaPipeline: mpId,
      terminateOnEOS: terminateOnEOS,
      mediaProfile: mediaProfile,
      disconnectionTimeout: disconnectionTimeout
    }
  end

  def release(%__MODULE__{id: id}) do
    KC.Core.syncRelease(id)
  end

end
