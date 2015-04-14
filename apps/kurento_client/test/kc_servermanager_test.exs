defmodule KCServerManagerTest do
  use ExUnit.Case

  @mediaPipeline KC.MO.Core.MediaPipeline
  @serverManager KC.MO.Core.ServerManager

  setup_all do
    mp = @mediaPipeline.create()

    on_exit fn ->
      @mediaPipeline.release(mp)
    end

    {:ok, mp: mp}
  end

  test "servermanager", ctx do
    mp = ctx[:mp]

    manager = @serverManager.get()

    serverInfo = @serverManager.getInfo(manager)
    assert is_list(serverInfo["modules"])
    assert is_list(serverInfo["capabilities"])
    assert is_binary(serverInfo["version"]) # something like "5.1.0"
    assert serverInfo["type"] === "KMS"

    pipelines = @serverManager.getPipelines(manager)
    assert Enum.any?(pipelines, fn x -> x === mp.id end)

    sessions = @serverManager.getSessions(manager)
    assert is_list(sessions) === true
    assert length(sessions) > 0
  end
end
