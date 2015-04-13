defmodule KCMediaPipelineTest do
  use ExUnit.Case

  test "mediapipeline" do
    oStore = KC.Core.getObjectStoreName()

    mp = KC.MediaPipeline.create()
    assert %KC.MediaPipeline{id: mpId} = mp
    assert {:ok, true} === oStore.has(oStore, mpId)

    KC.MediaPipeline.release(mp)
    assert {:ok, false} === oStore.has(oStore, mpId)
  end

end
