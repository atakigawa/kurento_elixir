defmodule KC.MO.Core.MediaElement do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainInject}
  @chainParent KC.MO.Core.MediaObject

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
  def getSourceConnections(%{id: _} = obj) do
    getSourceConnections(obj, nil, nil)
  end
  def getSourceConnections(%{id: _} = obj, mediaType) do
    getSourceConnections(obj, mediaType, nil)
  end
  def getSourceConnections(%{id: id}, mediaType, description) do
    {funcName, _} = __ENV__.function
    params = HashDict.new
    if not is_nil(mediaType) do
      params = HashDict.put(params, "mediaType", mediaType)
    end
    if not is_nil(description) do
      params = HashDict.put(params, "description", description)
    end
    KC.Core.syncInvoke(id, funcName, params)
  end

  @doc """
  Returns a list of the connections information of the
  elements that ere receiving media from this element.
  """
  def getSinkConnections(%{id: _} = obj) do
    getSinkConnections(obj, nil, nil)
  end
  def getSinkConnections(%{id: _} = obj, mediaType) do
    getSinkConnections(obj, mediaType, nil)
  end
  def getSinkConnections(%{id: id}, mediaType, description) do
    {funcName, _} = __ENV__.function
    params = HashDict.new
    if not is_nil(mediaType) do
      params = HashDict.put(params, "mediaType", mediaType)
    end
    if not is_nil(description) do
      params = HashDict.put(params, "description", description)
    end
    KC.Core.syncInvoke(id, funcName, params)
  end

  @doc """
  Connects two elements, with the given restrictions,
  current :rom:cls:`MediaElement` will start emitting media
  to the sink element. Connection could take place in the future,
  when both media element show capabilities for connecting
  with the given restrictions.
  """
  def connect(%{id: _} = source, %{id: _} = sink) do
    connect(source, sink, nil, nil, nil)
  end
  def connect(%{id: _} = source, %{id: _} = sink, mediaType) do
    connect(source, sink, mediaType, nil, nil)
  end
  def connect(
      %{id: sourceId},
      %{id: sinkId},
      mediaType,
      sourceMediaDescription,
      sinkMediaDescription) do
    {funcName, _} = __ENV__.function
    params = HashDict.new
    params = HashDict.put(params, "sink", sinkId)
    if not is_nil(mediaType) do
      params = HashDict.put(params, "mediaType", mediaType)
    end
    if not is_nil(sourceMediaDescription) do
      params = HashDict.put(params,
        "sourceMediaDescription", sourceMediaDescription)
    end
    if not is_nil(sinkMediaDescription) do
      params = HashDict.put(params,
        "sinkMediaDescription", sinkMediaDescription)
    end
    KC.Core.syncInvoke(sourceId, funcName, params)
  end

  @doc """
  Disconnects two elements, with the given restrictions,
  current :rom:cls:`MediaElement` stops sending media to
  sink element. If the previously requested connection didn't
  take place it is also removed.
  """
  def disconnect(%{id: _} = source, %{id: _} = sink) do
    disconnect(source, sink, nil, nil, nil)
  end
  def disconnect(%{id: _} = source, %{id: _} = sink, mediaType) do
    disconnect(source, sink, mediaType, nil, nil)
  end
  def disconnect(
      %{id: sourceId},
      %{id: sinkId},
      mediaType,
      sourceMediaDescription,
      sinkMediaDescription) do
    {funcName, _} = __ENV__.function
    params = HashDict.new
    params = HashDict.put(params, "sink", sinkId)
    if not is_nil(mediaType) do
      params = HashDict.put(params, "mediaType", mediaType)
    end
    if not is_nil(sourceMediaDescription) do
      params = HashDict.put(params,
        "sourceMediaDescription", sourceMediaDescription)
    end
    if not is_nil(sinkMediaDescription) do
      params = HashDict.put(params,
        "sinkMediaDescription", sinkMediaDescription)
    end
    KC.Core.syncInvoke(sourceId, funcName, params)
  end

  @doc """
  Sets the type of data for the audio stream.
  MediaElements that do not support configuration of
  audio capabilities will raise an exception.
  """
  def setAudioFormat(%{id: id}, %KC.MO.Core.AudioCaps{} = audioCaps) do
    {funcName, _} = __ENV__.function
    params = [caps: Map.from_struct(audioCaps)]
    KC.Core.syncInvoke(id, funcName, params)
  end

  @doc """
  Sets the type of data for the video stream.
  MediaElements that do not support configuration of
  video capabilities will raise an exception.
  """
  def setVideoFormat(%{id: id}, %KC.MO.Core.VideoCaps{} = videoCaps) do
    {funcName, _} = __ENV__.function
    params = [caps: Map.from_struct(videoCaps)]
    KC.Core.syncInvoke(id, funcName, params)
  end

end
