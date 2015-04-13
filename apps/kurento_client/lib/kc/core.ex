defmodule KC.Core do
  require Logger

  @objectStore KC.Core.ObjectStore
  @kmsClient KC.Core.WSClient

  def getObjectStoreName, do: @objectStore
  def getKmsClientName, do: @kmsClient

  def syncCreate(objectType, constructorParams \\ HashDict.new) do
    params = Enum.into([
      type: objectType,
      constructorParams: constructorParams,
    ], HashDict.new)

    %{"value" => objectId} = syncCallInner("create", params)

    #save info to ObjectStore
    @objectStore.put(@objectStore, objectId, params)

    objectId
  end

  def syncInvoke(objectId, operation, operationParams) do
    params = Enum.into([
      object: objectId,
      operation: operation,
      operationParams: operationParams,
    ], HashDict.new)

    syncCallInner("invoke", params)
  end

  def syncRelease(objectId) do
    params = Enum.into([
      object: objectId,
    ], HashDict.new)

    syncCallInner("release", params)

    #remove info from ObjectStore
    @objectStore.delete(@objectStore, objectId)

    nil
  end

  def syncSubscribe(objectId, eventType) do
    params = Enum.into([
      object: objectId,
      type: eventType,
    ], HashDict.new)

    %{"value" => subscriptionId} = syncCallInner("subscribe", params)

    #save info to ObjectStore
    @objectStore.put(@objectStore, subscriptionId, params)

    subscriptionId
  end

  def syncUnsubscribe(subscriptionId) do
    params = Enum.into([
      subscription: subscriptionId,
    ], HashDict.new)

    syncCallInner("unsubscribe", params)

    #remove info from ObjectStore
    @objectStore.delete(@objectStore, subscriptionId)

    nil
  end

  def syncCallInner(method, params) do
    {:ok, result} = @kmsClient.sendReq(@kmsClient, method, params)
    result
  end
end
