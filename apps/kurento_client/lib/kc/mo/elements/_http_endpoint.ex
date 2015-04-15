defmodule KC.MO.Elements.HttpEndpoint do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Core.SessionEndpoint

  @moduledoc """
  Endpoint that enables Kurento to work as an HTTP server,
  allowing peer HTTP clients to access media.

  """

  @doc """
  Obtains the URL associated to this endpoint.
  """
  def getUrl(%{id: id}) do
    {funcName, _} = __ENV__.function
    KC.Core.syncInvoke(id, funcName)
  end
end
