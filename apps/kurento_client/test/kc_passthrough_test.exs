defmodule KCPassThroughTest do
  use ExUnit.Case

  @mediaPipeline KC.MO.Core.MediaPipeline
  @passThrough KC.MO.Core.PassThrough

  setup_all do
    mp = @mediaPipeline.create()

    on_exit fn ->
      @mediaPipeline.release(mp)
    end

    {:ok, mp: mp}
  end

  test "PassThrough", ctx do
    mp = ctx[:mp]

    pt = @passThrough.create(mp)

    # connect to itself
    @passThrough.connect(pt, pt)
    ptSinks = @passThrough.getSinkConnections(pt)
    ptSources = @passThrough.getSourceConnections(pt)
    assert length(ptSinks) === 2
    assert length(ptSources) === 2

    ptSink = List.first(ptSinks)
    ptSource = List.first(ptSources)
    # source and sink should be the same
    assert ptSink["source"] === ptSink["sink"]
    assert ptSink["sink"] === ptSource["sink"]

    @passThrough.release(pt)
  end
end
