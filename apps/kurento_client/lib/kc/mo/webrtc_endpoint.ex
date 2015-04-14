defmodule KC.MO.WebRtcEndpoint do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.BaseRtpEndpoint

  @kmsType "WebRtcEndpoint"

  defstruct id: "",  mediaPipeline: ""

  def create(%KC.MO.MediaPipeline{id: mpId}) do
    params = Enum.into([
      mediaPipeline: mpId,
    ], HashDict.new)
    id = KC.Core.syncCreate(@kmsType, params)

    %KC.MO.WebRtcEndpoint{id: id, mediaPipeline: mpId}
  end

  def release(%KC.MO.WebRtcEndpoint{id: id}) do
    KC.Core.syncRelease(id)
  end
end
