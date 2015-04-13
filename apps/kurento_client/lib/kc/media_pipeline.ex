defmodule KC.MediaPipeline do
  @kmsType "MediaPipeline"

  defstruct id: ""

  def create do
    id = KC.Core.syncCreate(@kmsType)
    %KC.MediaPipeline{id: id}
  end

  def release(%KC.MediaPipeline{id: id}) do
    KC.Core.syncRelease(id)
  end
end
