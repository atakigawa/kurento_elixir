defmodule KC.MO.Elements.MediaProfileSpecType do

  @webm "WEBM"
  @mp4 "MP4"
  @webmVideoOnly "WEBM_VIDEO_ONLY"
  @webmAudioOnly "WEBM_AUDIO_ONLY"
  @mp4VideoOnly "MP4_VIDEO_ONLY"
  @mp4AudioOnly "MP4_AUDIO_ONLY"

  @allowedMediaProfiles [
    @webm,
    @mp4,
    @webmVideoOnly,
    @webmAudioOnly,
    @mp4VideoOnly,
    @mp4AudioOnly
  ]

  def webm, do: @webm
  def mp4, do: @mp4
  def webmVideoOnly, do: @webmVideoOnly
  def webmAudioOnly, do: @webmAudioOnly
  def mp4VideoOnly, do: @mp4VideoOnly
  def mp4AudioOnly, do: @mp4AudioOnly
  def allowedMediaProfiles, do: @allowedMediaProfiles

end
