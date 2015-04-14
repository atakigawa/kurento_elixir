defmodule KC.MO.Core.HubPort do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Core.MediaElement

  @kmsType "HubPort"

  defstruct id: "", hub: ""

  def create(%{id: hubId}) do
    params = [hub: hubId]
    id = KC.Core.syncCreate(@kmsType, params)

    %__MODULE__{id: id, hub: hubId}
  end

  def release(%__MODULE__{id: id}) do
    KC.Core.syncRelease(id)
  end
end
