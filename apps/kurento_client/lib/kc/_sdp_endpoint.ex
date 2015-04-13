defmodule KC.SdpEndpoint do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.SessionEndpoint

  @moduledoc """
  Implements an SDP negotiation endpoint able to
  generate and process offers/responses and that configures
  resources according to negotiated Session Description.

  """

  @doc """
  Maximum video bandwidth for receiving.
  Unit: kbps(kilobits per second).
  0: unlimited.
  Default value: 500
  """
  def getMaxVideoRecvBandwidth do
  end

  def setMaxVideoRecvBandwidth do
  end

  @doc """
  Request a SessionSpec offer.
  This can be used to initiate a connection.
  """
  def generateOffer do
  end

  @doc """
  Request the NetworkConnection to process the
  given SessionSpec offer (from the remote User Agent).
  """
  def processOffer(offer) do
  end

  @doc """
  Request the NetworkConnection to process the
  given SessionSpec answer (from the remote User Agent).
  """
  def processAnswer(answer) do
  end

  @doc """
  This method gives access to the SessionSpec offered by
  this NetworkConnection.

  This method returns the local MediaSpec, negotiated or not.
  If no offer has been generated yet, it returns null.
  If an offer has been generated it returns the offer.
  If an answer has been processed it returns the negotiated
  local SessionSpec.
  """
  def getLocalSessionDescriptor do
  end

  @doc """
  This method gives access to the remote session description.

  This method returns the media previously agreed after a
  complete offer-answer exchange. If no media has been
  agreed yet, it returns null.
  """
  def getRemoteSessionDescriptor do
  end
end
