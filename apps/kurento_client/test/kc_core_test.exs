defmodule KCCoreTest do
  use ExUnit.Case

  test "ObjectStore" do
    oStore = KC.Core.getObjectStoreName()

    # single key
    key = "hogefugapiyo"
    assert oStore.put(oStore, key, foo: 12345) === {:ok, nil}
    assert oStore.has(oStore, key) === true
    assert oStore.get(oStore, key) === {:ok, [foo: 12345]}
    assert oStore.delete(oStore, key) === {:ok, nil}
    assert oStore.has(oStore, key) === false
    assert oStore.get(oStore, key) === {:ok, nil}

    # array key
    key = [:mo, "dummyMO"]
    assert oStore.put(oStore, key, foo: 12345) === {:ok, nil}
    assert oStore.has(oStore, key) === true
    assert oStore.get(oStore, key) === {:ok, [foo: 12345]}
    assert oStore.delete(oStore, key) === {:ok, nil}
    assert oStore.has(oStore, key) === false
    assert oStore.get(oStore, key) === {:ok, nil}

    # session
    key = "dummySessIdKey"
    assert oStore.putSession(oStore, key, "dummySessId") === {:ok, nil}
    assert oStore.hasSession(oStore, key) === true
    assert oStore.getSession(oStore, key) === {:ok, "dummySessId"}
    assert oStore.deleteSession(oStore, key) === {:ok, nil}
    assert oStore.hasSession(oStore, key) === false
    assert oStore.getSession(oStore, key) === {:ok, nil}

    # media object
    key = "dummyMOKey"
    assert oStore.putMediaObject(oStore, key, "dummyMOVal") === {:ok, nil}
    assert oStore.hasMediaObject(oStore, key) === true
    assert oStore.getMediaObject(oStore, key) === {:ok, "dummyMOVal"}
    assert oStore.deleteMediaObject(oStore, key) === {:ok, nil}
    assert oStore.hasMediaObject(oStore, key) === false
    assert oStore.getMediaObject(oStore, key) === {:ok, nil}

    # subscription
    key = "dummySubKey"
    assert oStore.putSubscription(oStore, key, "dummySubVal") === {:ok, nil}
    assert oStore.hasSubscription(oStore, key) === true
    assert oStore.getSubscription(oStore, key) === {:ok, "dummySubVal"}
    assert oStore.deleteSubscription(oStore, key) === {:ok, nil}
    assert oStore.hasSubscription(oStore, key) === false
    assert oStore.getSubscription(oStore, key) === {:ok, nil}
  end

  test "json serialize1" do
    dict1 =
      HashDict.new
      |> HashDict.put("a", 1)
      |> HashDict.put("b", :a)
      |> HashDict.put("c", "xyz")

    list1 = [1, :a, "xyz"]

    obj =
      HashDict.new()
      |> HashDict.put("simpleval", 1)
      |> HashDict.put(:dict, dict1)
      |> HashDict.put("list", list1)

    bin = KC.Core.JsonRpcUtil.serialize(obj)
    assert bin === "{" <>
      "\"jsonrpc\":\"2.0\"," <>
      "\"dict\":{\"a\":1,\"b\":\"a\",\"c\":\"xyz\"}," <>
      "\"simpleval\":1," <>
      "\"list\":[1,\"a\",\"xyz\"]" <>
    "}"
  end

  test "json serialize2" do
    obj =
      HashDict.new()
      |> HashDict.put("hoge", HashDict.new)
    bin = KC.Core.JsonRpcUtil.serialize(obj)
    assert bin === "{" <>
      "\"jsonrpc\":\"2.0\"," <>
      "\"hoge\":{}" <>
    "}"
  end
end
