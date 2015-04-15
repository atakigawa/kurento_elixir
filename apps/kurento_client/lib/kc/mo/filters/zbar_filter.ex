defmodule KC.MO.Filters.ZBarFilter do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Core.Filter

  @kmsType "ZBarFilter"

  @moduledoc """
  This filter detects :term:`QR` codes in a video feed.
  When a code is found, the filter raises a
  :rom:evnt:`CodeFound` event.

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

  def subscribeCodeFound(%{id: id}) do
    evtType = "CodeFound"
    KC.Core.syncSubscribe(id, evtType)
  end
end
