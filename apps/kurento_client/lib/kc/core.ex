defmodule KC.Core do
  require Logger

  @objectStore KC.Core.ObjectStore
  @kmsClient KC.Core.WSClient
  @eventHandler KC.Core.EventHandler

  @responseTimeout 5_000 #millisec

  def getObjectStoreName, do: @objectStore
  def getKmsClientName, do: @kmsClient
  def getEventHandlerName, do: @eventHandler

  def syncCreate(objectType, constructorParams \\ HashDict.new) do
    params = Enum.into([
      type: objectType,
      constructorParams: constructorParams,
    ], HashDict.new)

    %{"value" => objectId} = syncCallInner("create", params)

    #save info to ObjectStore
    @objectStore.putMediaObject(@objectStore, objectId, params)

    objectId
  end

  def syncInvoke(objectId, operation, operationParams \\ HashDict.new) do
    params = Enum.into([
      object: objectId,
      operation: operation,
      operationParams: operationParams,
    ], HashDict.new)

    case syncCallInner("invoke", params) do
      %{"value" => :null} -> nil
      %{"value" => ret} -> ret
      _ -> nil
    end
  end

  def syncRelease(objectId) do
    params = Enum.into([
      object: objectId,
    ], HashDict.new)

    syncCallInner("release", params)

    #remove info from ObjectStore
    @objectStore.deleteMediaObject(@objectStore, objectId)

    nil
  end

  def syncSubscribe(objectId, eventType) do
    params = Enum.into([
      object: objectId,
      type: eventType,
    ], HashDict.new)

    %{"value" => subscriptionId} = syncCallInner("subscribe", params)

    #save info to ObjectStore
    @objectStore.putSubscription(@objectStore, subscriptionId, params)

    subscriptionId
  end

  def syncUnsubscribe(objectId, subscriptionId) do
    params = Enum.into([
      object: objectId,
      subscription: subscriptionId,
    ], HashDict.new)

    syncCallInner("unsubscribe", params)

    #remove info from ObjectStore
    @objectStore.deleteSubscription(@objectStore, subscriptionId)

    nil
  end

  defp syncCallInner(method, params) do
    :ok = @kmsClient.sendReq(@kmsClient, method, params)

    # wait for response.
    receive do
      {:response, response} -> response
    after
      @responseTimeout ->
        raise RuntimeError,
          message: "No response after #{@responseTimeout} millisecs."
    end
  end
end
