defmodule KC.MediaObject do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainRoot}

  @moduledoc """
  Base for all objects that can be created in the media server.

  """

  @doc """
  :rom:cls:`MediaPipeline` to which this MediaObject belong,
  or the pipeline itself if invoked over a :rom:cls:`MediaPipeline`.
  """
  def getMediaPipeline do
  end


  @doc """
  Parent of this media object. The type of the parent depends on
  the type of the element.
  The parent of a :rom:cls:`MediaPad` is its :rom:cls:`MediaElement`;
  the parent of a :rom:cls:`Hub` or a :rom:cls:`MediaElement`
  is its :rom:cls:`MediaPipeline`.
  A :rom:cls:`MediaPipeline` has no parent, i.e. the property is null.
  """
  def getParent do
  end

  @doc """
  Object name. This is just a comodity to simplify developers'
  life debugging, it is not used internally for indexing nor
  idenfiying the objects. By default is the object type followed
  by the object id.
  """
  def getName do
  end


  def evtError do
    "Error"
  end

end
