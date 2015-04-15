defmodule KC.MO.Elements.PlayerEndpoint do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Core.UriEndpoint

  @kmsType "PlayerEndpoint"

  @moduledoc """
  Retrieves content from seekable sources in reliable
  mode (does not discard media information) and inject
  them into :term:`KMS`. It contains one :rom:cls:`MediaSource`
  for each media type detected.

  """

  defstruct [
    id: "",
    mediaPipeline: "",
    uri: "",
    useEncodedMedia: false
  ]

  def create(
      %KC.MO.Core.MediaPipeline{id: mpId},
      uri,
      useEncodedMedia \\ false) do
    params = [
      mediaPipeline: mpId,
      uri: uri,
      useEncodedMedia: useEncodedMedia
    ]
    id = KC.Core.syncCreate(@kmsType, params)

    %__MODULE__{
      id: id,
      mediaPipeline: mpId,
      uri: uri,
      useEncodedMedia: useEncodedMedia
    }
  end

  def release(%__MODULE__{id: id}) do
    KC.Core.syncRelease(id)
  end

  @doc """
  Starts to send data to the endpoint :rom:cls:`MediaSource`.
  """
  def play(%{id: id}) do
    {funcName, _} = __ENV__.function
    KC.Core.syncInvoke(id, funcName)
  end

  def subscribeEndOfStream(%{id: id}) do
    evtType = "EndOfStream"
    KC.Core.syncSubscribe(id, evtType)
  end
end
