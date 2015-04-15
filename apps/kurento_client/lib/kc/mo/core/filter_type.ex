defmodule KC.MO.Core.FilterType do

  @audio "AUDIO"
  @video "VIDEO"
  @autoDetect "AUTODETECT"

  @allowedFilterTypes [
    @audio, @video, @autoDetect
  ]

  def audio, do: @audio
  def video, do: @video
  def autoDetect, do: @autoDetect
  def allowedFilterTypes, do: @allowedFilterTypes

end
