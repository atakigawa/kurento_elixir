defmodule KC.MO.Filters.OpenCVFilter do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Core.Filter

  @moduledoc """
  Generic OpenCV Filter.

  """

end
