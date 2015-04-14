defmodule KC.MO.MediaPipeline do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.MediaObject

  @kmsType "MediaPipeline"

  defstruct id: ""

  def create do
    id = KC.Core.syncCreate(@kmsType)
    %KC.MO.MediaPipeline{id: id}
  end

  def release(%KC.MO.MediaPipeline{id: id}) do
    KC.Core.syncRelease(id)
  end
end
