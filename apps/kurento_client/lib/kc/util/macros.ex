defmodule KC.Util.MacrosError do
  defexception message: "error."
end

defmodule KC.Util.Macros do
  @dummyArgs [
    :a1, :b1, :c1, :d1, :e1, :f1, :g1, :h1, :i1, :j1, :k1,
    :l1, :m1, :n1, :o1, :p1, :q1, :r1, :s1, :t1, :u1, :v1,
    :w1, :x1, :y1, :z1,
    :a2, :b2, :c2, :d2, :e2, :f2, :g2, :h2, :i2, :j2, :k2,
    :l2, :m2, :n2, :o2, :p2, :q2, :r2, :s2, :t2, :u2, :v2,
    :w2, :x2, :y2, :z2
  ]

  defmacro chainRoot(env) do
    quote do
      def kcGetAllChainedDefs do
        unquote(getDefList(env.module))
      end
    end
  end

  defmacro chainInject(env) do
    parent = Module.get_attribute(env.module, :chainParent) ||
      raise KC.Util.MacrosError,
        message: "Attribute @chainParent not defined in #{env.module}."

    quote do
      require unquote(parent)

      # all funcs defined in parent chain.
      @kcGetParentDefList unquote(parent).kcGetAllChainedDefs

      # get all funcs defined in parent chain and this module.
      def kcGetAllChainedDefs do
        Enum.concat(@kcGetParentDefList, unquote(getDefList(env.module)))
      end

      unquote (
        # need to escape "unquote" here, so unquote once
        # and quote again with "unquote: false" option.
        quote unquote: false do
          # define all funcs in parent chain list.
          KC.Util.Macros.delegate unquote(@kcGetParentDefList()), to: @chainParent
        end
      )
    end
  end

  defmacro delegate(funcList, opts) do
    funcList = Macro.escape(funcList, unquote: true)

    quote bind_quoted: [
      funcList: funcList,
      opts: opts,
      dummyArgs: @dummyArgs
    ] do
      delagatee = Keyword.get(opts, :to) ||
        raise ArgumentError, "Expected to: to be given as argument"

      for {name, arity} <- List.wrap(funcList) do
        args =
          dummyArgs
          |> Enum.take(arity)
          |> Enum.map(fn x -> {x, [], nil} end)

        def unquote(name)(unquote_splicing(args)) do
          unquote(delagatee).unquote(name)(unquote_splicing(args))
        end
      end
    end
  end

  defp getDefList(module) do
    Module.definitions_in(module, :def)
    |> Enum.filter(fn {funcName, _} ->
         # exclude "__struct__" and those kinds of funcs
         not String.starts_with?(to_string(funcName), "__")
       end)
  end
end
