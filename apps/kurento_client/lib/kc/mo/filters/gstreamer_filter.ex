defmodule KC.MO.Filters.GStreamerFilter do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Core.Filter

  @kmsType "GStreamerFilter"
  @ft KC.MO.Core.FilterType

  @moduledoc """
  This is a generic filter interface, that creates
  GStreamer filters in the media server.

  """

  defstruct id: "",  mediaPipeline: "", command: "", filterType: ""

  def create(
      %KC.MO.Core.MediaPipeline{id: mpId},
      command,
      filterType \\ @ft.autoDetect) do
    Enum.any?(@ft.allowedFilterTypes, fn x -> x === filterType end) ||
      raise ArgumentError,
        "filterType expected to be one of #{inspect @ft.allowedFilterTypes}"

    params = [
      mediaPipeline: mpId,
      command: command,
      filterType: filterType
    ]
    id = KC.Core.syncCreate(@kmsType, params)

    %__MODULE__{
      id: id,
      mediaPipeline: mpId,
      command: command,
      filterType: filterType
    }
  end

  def release(%__MODULE__{id: id}) do
    KC.Core.syncRelease(id)
  end
end
