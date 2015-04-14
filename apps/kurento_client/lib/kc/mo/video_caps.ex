defmodule KC.MO.VideoCaps do
  defstruct codec: "", framerate: %{}

  @vp8Codec "VP8"
  @h264Codec "H264"
  @rawCodec "RAW"
  @allowedCodecs [@vp8Codec, @h264Codec, @rawCodec]

  def create(codec, frNumerator, frDenominator)
      when is_integer(frNumerator) and is_integer(frDenominator) do
    Enum.any?(@allowedCodecs, fn x -> x === codec end) ||
      raise ArgumentError,
        "codec expected to be one of #{inspect @allowedCodecs}"

    fr = %{
      numerator: frNumerator,
      denominator: frDenominator
    }
    %__MODULE__{codec: codec, framerate: fr}
  end

  def vp8Codec, do: @vp8Codec
  def h264Codec, do: @h264Codec
  def rawCodec, do: @rawCodec

end
