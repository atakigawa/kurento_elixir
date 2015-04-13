defmodule KCCoreTest do
  use ExUnit.Case

  test "ObjectStore" do
    oStore = KC.Core.getObjectStoreName()
    {:ok, id} = oStore.put(oStore, "hogefugapiyo", somekey: 12345)
    assert id === "hogefugapiyo"

    {:ok, flag} = oStore.has(oStore, id)
    assert flag === true

    {:ok, obj} = oStore.get(oStore, id)
    assert obj === [somekey: 12345]
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
