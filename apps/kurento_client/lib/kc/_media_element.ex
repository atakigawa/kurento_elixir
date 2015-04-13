defmodule KC.MediaElement do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MediaObject

  @moduledoc """
  Basic building blocks of the media server, that can be
  interconnected through the API. A :rom:cls:`MediaElement`
  is a module that encapsulates a specific media capability.
  They can be connected to create media pipelines where those
  capabilities are applied, in sequence, to the stream going
  through the pipeline.

  :rom:cls:`MediaElement` objects are classified by its
  supported media type (audio, video, etc.)

  """

  @doc """
  Get the connections information of the elements that are
  sending media to this element :rom:cls:`MediaElement`.
  """
  def getSourceConnections() do
    getSourceConnections(nil, nil)
  end
  def getSourceConnections(mediaType) do
    getSourceConnections(mediaType, nil)
  end
  def getSourceConnections(mediaType, description) do
  end

  @doc """
  Returns a list of the connections information of the
  elements that ere receiving media from this element.
  """
  def getSinkConnections() do
    getSinkConnections(nil, nil)
  end
  def getSinkConnections(mediaType) do
    getSinkConnections(mediaType, nil)
  end
  def getSinkConnections(mediaType, description) do
  end

  @doc """
  Connects two elements, with the given restrictions,
  current :rom:cls:`MediaElement` will start emitting media
  to the sink element. Connection could take place in the future,
  when both media element show capabilities for connecting
  with the given restrictions.
  """
  def connect(sink) do
    connect(sink, nil, nil, nil)
  end
  def connect(sink, mediaType) do
    connect(sink, mediaType, nil, nil)
  end
  def connect(
      sink,
      mediaType,
      sourceMediaDescription,
      sinkMediaDescription) do
  end

  @doc """
  Disconnects two elements, with the given restrictions,
  current :rom:cls:`MediaElement` stops sending media to
  sink element. If the previously requested connection didn't
  take place it is also removed.
  """
  def disconnect(sink) do
    disconnect(sink, nil, nil, nil)
  end
  def disconnect(sink, mediaType) do
    disconnect(sink, mediaType, nil, nil)
  end
  def disconnect(
      sink,
      mediaType,
      sourceMediaDescription,
      sinkMediaDescription) do
  end

  @doc """
  Sets the type of data for the audio stream.
  MediaElements that do not support configuration of
  audio capabilities will raise an exception.
  """
  def setAudioFormat(audioCaps) do
  end

  @doc """
  Sets the type of data for the video stream.
  MediaElements that do not support configuration of
  video capabilities will raise an exception.
  """
  def setVideoFormat(videoCaps) do
  end

end
