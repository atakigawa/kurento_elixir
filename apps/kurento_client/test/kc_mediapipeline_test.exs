defmodule KCMediaPipelineTest do
  use ExUnit.Case

  @mediaPipeline KC.MO.MediaPipeline

  test "mediapipeline" do
    oStore = KC.Core.getObjectStoreName()

    mp = @mediaPipeline.create()
    assert %@mediaPipeline{id: mpId} = mp
    assert true === oStore.hasMediaObject(oStore, mpId)

    assert @mediaPipeline.getMediaPipeline(mp) === mp.id
    assert @mediaPipeline.getParent(mp) === nil
    assert @mediaPipeline.getName(mp) === mp.id

    @mediaPipeline.release(mp)
    assert false === oStore.hasMediaObject(oStore, mpId)
  end

end
