defmodule KC.MO.UriEndpoint do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Endpoint

  @moduledoc """
  Interface for endpoints that require a URI to work.
  An example of this, would be a :rom:cls:`PlayerEndpoint`
  whose URI property could be used to locate a file to stream.

  """

  @doc """
  Pauses the feed.
  """
  def pause(%{id: id}) do
    {funcName, _} = __ENV__.function
    KC.Core.syncInvoke(id, funcName)
  end

  @doc """
  Stops the feed.
  """
  def stop(%{id: id}) do
    {funcName, _} = __ENV__.function
    KC.Core.syncInvoke(id, funcName)
  end

end
