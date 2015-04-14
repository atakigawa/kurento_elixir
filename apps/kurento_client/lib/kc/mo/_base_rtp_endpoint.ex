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
  def getMinVideoSendBandwidth(%{id: id}) do
    {funcName, _} = __ENV__.function
    KC.Core.syncInvoke(id, funcName)
  end

  def setMinVideoSendBandwidth(%{id: id}, bw) do
    {funcName, _} = __ENV__.function
    params = [minVideoSendBandwidth: bw]
    KC.Core.syncInvoke(id, funcName, params)
  end

  @doc """
  Maximum video bandwidth for sending.
  Unit: kbps(kilobits per second).
  0: unlimited.
  Default value: 500
  """
  def getMaxVideoSendBandwidth(%{id: id}) do
    {funcName, _} = __ENV__.function
    KC.Core.syncInvoke(id, funcName)
  end

  def setMaxVideoSendBandwidth(%{id: id}, bw) do
    {funcName, _} = __ENV__.function
    params = [maxVideoSendBandwidth: bw]
    KC.Core.syncInvoke(id, funcName, params)
  end
end
