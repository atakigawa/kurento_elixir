defmodule KC.MO.Core.Filter do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Core.MediaElement

  @moduledoc """
  Base interface for all filters. This is a certain type of
  :rom:cls:`MediaElement`, that processes media injected
  through its sinks, and delivers the outcome through its sources.

  """

end
