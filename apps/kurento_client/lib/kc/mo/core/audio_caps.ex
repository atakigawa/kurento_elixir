defmodule KC.MO.Core.AudioCaps do
  defstruct codec: "", bitrate: 0

  @opusCodec "OPUS"
  @pcmuCodec "PCMU"
  @rawCodec "RAW"
  @allowedCodecs [@opusCodec, @pcmuCodec, @rawCodec]

  def create(codec, bitrate) when is_integer(bitrate) do
    Enum.any?(@allowedCodecs, fn x -> x === codec end) ||
      raise ArgumentError,
        "codec expected to be one of #{inspect @allowedCodecs}"

    %__MODULE__{codec: codec, bitrate: bitrate}
  end

  def opusCodec, do: @opusCodec
  def pcmuCodec, do: @pcmuCodec
  def rawCodec, do: @rawCodec

end
