defmodule KC.MO.Core.MediaObject do
  require KC.Util.Macros
  @before_compile {KC.Util.Macros, :chainRoot}

  @moduledoc """
  Base for all objects that can be created in the media server.

  """

  @doc """
  :rom:cls:`MediaPipeline` to which this MediaObject belong,
  or the pipeline itself if invoked over a :rom:cls:`MediaPipeline`.
  """
  def getMediaPipeline(%{id: id}) do
    {funcName, _} = __ENV__.function
    KC.Core.syncInvoke(id, funcName)
  end


  @doc """
  Parent of this media object. The type of the parent depends on
  the type of the element.
  The parent of a :rom:cls:`MediaPad` is its :rom:cls:`MediaElement`;
  the parent of a :rom:cls:`Hub` or a :rom:cls:`MediaElement`
  is its :rom:cls:`MediaPipeline`.
  A :rom:cls:`MediaPipeline` has no parent, i.e. the property is null.
  """
  def getParent(%{id: id}) do
    {funcName, _} = __ENV__.function
    KC.Core.syncInvoke(id, funcName)
  end

  @doc """
  Object name. This is just a comodity to simplify developers'
  life debugging, it is not used internally for indexing nor
  idenfiying the objects. By default is the object type followed
  by the object id.
  """
  def getName(%{id: id}) do
    {funcName, _} = __ENV__.function
    KC.Core.syncInvoke(id, funcName)
  end

  def subscribeEvtError(%{id: id}) do
    evtType = "Error"
    KC.Core.syncSubscribe(id, evtType)
  end

  # function to use for all unsubscribes
  def unsubscribe(%{id: id}, subscriptionId) do
    KC.Core.syncUnsubscribe(id, subscriptionId)
  end

end
