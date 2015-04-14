defmodule KC.MO.BaseRtpEndpoint do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.SdpEndpoint

  @moduledoc """
  Base class to manage common RTP features.

  """

  @doc """
  Minimum video bandwidth for sending.
  Unit: kbps(kilobits per second).
  0: unlimited.
  Default value: 100
  """
  def getMinVideoSendBandwidth do
  end

  def setMinVideoSendBandwidth do
  end

  @doc """
  Maximum video bandwidth for sending.
  Unit: kbps(kilobits per second).
  0: unlimited.
  Default value: 500
  """
  def getMaxVideoSendBandwidth do
  end

  def setMaxVideoSendBandwidth do
  end
end
