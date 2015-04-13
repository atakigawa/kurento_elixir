defmodule KC.SessionEndpoint do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.Endpoint

  @moduledoc """
  Session based endpoint. A session is considered to be
  started when the media exchange starts. On the other hand,
  sessions terminate when a timeout, defined by the developer,
  takes place after the connection is lost.

  """

  def evtMediaSessionStarted do
    "MediaSessionStarted"
  end

  def evtMediaSessionTerminated do
    "MediaSessionTerminated"
  end

end
