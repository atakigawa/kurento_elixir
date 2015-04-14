defmodule KCMediaPipelineTest do
  use ExUnit.Case

  test "mediapipeline" do
    oStore = KC.Core.getObjectStoreName()

    mp = KC.MO.MediaPipeline.create()
    assert %KC.MO.MediaPipeline{id: mpId} = mp
    assert {:ok, true} === oStore.has(oStore, mpId)

    KC.MO.MediaPipeline.release(mp)
    assert {:ok, false} === oStore.has(oStore, mpId)
  end

end
