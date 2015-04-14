defmodule KC.MO.Elements.WebRtcEndpoint do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Core.BaseRtpEndpoint

  @kmsType "WebRtcEndpoint"

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
