defmodule KC.MO.Elements.RecorderEndpoint do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Core.UriEndpoint

  @kmsType "RecorderEndpoint"
  @mpst KC.MO.Elements.MediaProfileSpecType

  @moduledoc """
  Provides function to store contents in reliable
  mode (doesn't discard data). It contains
  :rom:cls:`MediaSink` pads for audio and video.

  """

  defstruct [
    id: "",
    mediaPipeline: "",
    uri: "",
    mediaProfile: "",
    stopOnEndOfStream: false
  ]

  def create(
      %KC.MO.Core.MediaPipeline{id: mpId},
      uri,
      mediaProfile \\ @mpst.webm,
      stopOnEndOfStream \\ false) do
    Enum.any?(@mpst.allowedMediaProfiles, fn x -> x === mediaProfile end) ||
      raise ArgumentError,
        "mediaProfile expected to be one of #{inspect @mpst.allowedMediaProfiles}"

    params = [
      mediaPipeline: mpId,
      uri: uri,
      mediaProfile: mediaProfile,
      stopOnEndOfStream: stopOnEndOfStream
    ]
    id = KC.Core.syncCreate(@kmsType, params)

    %__MODULE__{
      id: id,
      mediaPipeline: mpId,
      uri: uri,
      mediaProfile: mediaProfile,
      stopOnEndOfStream: stopOnEndOfStream
    }
  end

  def release(%__MODULE__{id: id}) do
    KC.Core.syncRelease(id)
  end

  @doc """
  Starts storing media received through the
  :rom:cls:`MediaSink` pad".
  """
  def record(%{id: id}) do
    {funcName, _} = __ENV__.function
    KC.Core.syncInvoke(id, funcName)
  end
end
