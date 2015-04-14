defmodule KC.Core.JsonRpcUtil do
  require Logger

  def serialize(dict) do
    Dict.put(dict, "jsonrpc", "2.0")
    |> reformat()
    |> :jiffy.encode()

    #:jiffy.encode({[
    #  {"jsonrpc", "2.0"}
    #]})
  end

  def deserialize(bin) do
    :jiffy.decode(bin, [:return_maps])
  end

  defp reformat_inner(v) do
    cond do
      is_atom(v) ->
        to_string(v)
      Keyword.keyword?(v) || is_map(v) ->
        v = Enum.map(v, fn {k1, v1} ->
          reformat_inner(k1, v1)
        end)
        {v}
      is_list(v) ->
        v = Enum.map(v, fn v1 ->
          reformat_inner(v1)
        end)
        v
      true ->
        v
    end
  end
  defp reformat_inner(k, v) do
    if is_atom(k) do
      k = to_string(k)
    end

    v = reformat_inner(v)

    {k, v}
  end

  defp reformat(dict) do
    lst = Enum.map(dict, fn {k, v} ->
      reformat_inner(k, v)
    end)

    {lst}
  end
end
