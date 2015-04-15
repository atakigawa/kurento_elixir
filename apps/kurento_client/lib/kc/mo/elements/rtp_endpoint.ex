defmodule KC.MO.Elements.RtpEndpoint do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Core.SdpEndpoint

  @kmsType "RtpEndpoint"

  @moduledoc """
  Endpoint that provides bidirectional content delivery
  capabilities with remote networked peers through RTP protocol.
  An :rom:cls:`RtpEndpoint` contains paired sink and source
  :rom:cls:`MediaPad` for audio and video.

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
end
