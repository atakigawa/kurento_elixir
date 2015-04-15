defmodule KC.MO.Elements.AlphaBlending do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Core.Hub

  @kmsType "AlphaBlending"
  @hubPort KC.MO.Core.HubPort

  @moduledoc """
  A :rom:cls:`Hub` that mixes the :rom:attr:`MediaType.AUDIO`
  stream of its connected sources and constructs one output
  with :rom:attr:`MediaType.VIDEO` streams of its connected
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

  @doc """
  Sets the source port that will be the master entry to the mixer.
  """
  def setMaster(
      %__MODULE__{id: id},
      %@hubPort{id: sourceId},
      zOrder) when is_integer(zOrder) do
    {funcName, _} = __ENV__.function
    params = [source: sourceId, zOrder: zOrder]
    KC.Core.syncInvoke(id, funcName, params)
  end

  @doc """
  Configure the blending mode of one port.
  """
  def setPortProperties(
      %__MODULE__{id: id},
      relativeX,
      relativeY,
      zOrder,
      relativeWidth,
      relativeHeight,
      %@hubPort{id: hubPortId}) when
        is_float(relativeX) and
        is_float(relativeY) and
        is_integer(zOrder) and
        is_float(relativeWidth) and
        is_float(relativeHeight) do
    {funcName, _} = __ENV__.function
    params = [
      relativeX: relativeX,
      relativeY: relativeY,
      zOrder: zOrder,
      relativeWidth: relativeWidth,
      relativeHeight: relativeHeight,
      port: hubPortId
    ]
    KC.Core.syncInvoke(id, funcName, params)
  end
end
