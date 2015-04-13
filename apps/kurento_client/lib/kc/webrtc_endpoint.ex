defmodule KC.WebRtcEndpoint do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.BaseRtpEndpoint

  @kmsType "WebRtcEndpoint"


  defstruct id: "",  mediaPipeline: ""

  def create(%KC.MediaPipeline{id: mpId}) do
    params = Enum.into([
      mediaPipeline: mpId,
    ], HashDict.new)
    id = KC.Core.syncCreate(@kmsType, params)

    %KC.WebRtcEndpoint{id: id, mediaPipeline: mpId}
  end

  def release(%KC.WebRtcEndpoint{id: id}) do
    KC.Core.syncRelease(id)
  end
end
