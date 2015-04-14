defmodule KC.MO.Core.Endpoint do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Core.MediaElement

  @moduledoc """
  Base interface for all end points.
  An Endpoint is a :rom:cls:`MediaElement` that allow
  :term:`KMS` to interchange media contents with external systems,
  supporting different transport protocols and mechanisms, such as
  :term:`RTP`, :term:`WebRTC`, :term:`HTTP`, ``file:/`` URLs...

  An ``Endpoint`` may contain both sources and sinks for different
  media types, to provide bidirectional communication.

  """

end
