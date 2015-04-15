defmodule KC.MO.Elements.Composite do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Core.Hub

  @kmsType "Composite"

  @moduledoc """
  A :rom:cls:`Hub` that mixes the :rom:attr:`MediaType.AUDIO`
  stream of its connected sources and constructs a grid with
  the :rom:attr:`MediaType.VIDEO` streams of its connected
  sources into its sink.

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
