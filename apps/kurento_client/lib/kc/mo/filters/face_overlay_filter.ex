defmodule KC.MO.Filters.FaceOverlayFilter do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Core.Filter

  @kmsType "FaceOverlayFilter"

  @moduledoc """
  FaceOverlayFilter interface. This type of :rom:cls:`Filter`
  detects faces in a video feed. The face is then overlaid
  with an image.

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
  Clear the image to be shown over each detected face.
  Stops overlaying the faces.
  """
  def unsetOverlayedImage(%__MODULE__{id: id}) do
    {funcName, _} = __ENV__.function
    KC.Core.syncInvoke(id, funcName)
  end


  @doc """
  Sets the image to use as overlay on the detected faces.
  """
  def setOverlayedImage(
      %__MODULE__{id: id},
      uri,
      offsetXPercent,
      offsetYPercent,
      widthPercent,
      heightPercent) when
        is_float(offsetXPercent) and
        is_float(offsetYPercent) and
        is_float(widthPercent) and
        is_float(heightPercent) do
    {funcName, _} = __ENV__.function
    params = [
      uri: uri,
      offsetXPercent: offsetXPercent,
      offsetYPercent: offsetYPercent,
      widthPercent: widthPercent,
      heightPercent: heightPercent
    ]
    KC.Core.syncInvoke(id, funcName, params)
  end
end
