defmodule KC.MO.HubPort do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.MediaElement

  @kmsType "HubPort"

  defstruct id: "", hub: ""

  def create(%KC.MO.Hub{id: hubId}) do
    params = [hub: hubId]
    id = KC.Core.syncCreate(@kmsType, params)

    %__MODULE__{id: id, hub: hubId}
  end

  def release(%__MODULE__{id: id}) do
    KC.Core.syncRelease(id)
  end
end
