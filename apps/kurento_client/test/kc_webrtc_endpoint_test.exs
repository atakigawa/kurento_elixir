defmodule KCWebRTcEndpointTest do
  use ExUnit.Case

  setup_all do
    mp = KC.MediaPipeline.create()

    on_exit fn ->
      KC.MediaPipeline.release(mp)
    end

    {:ok, mp: mp}
  end

  test "webrtcendpoint", ctx do
    mp = ctx[:mp]
    oStore = KC.Core.getObjectStoreName()

    ep = KC.WebRtcEndpoint.create(mp)
    assert %KC.WebRtcEndpoint{id: epId} = ep
    assert {:ok, true} === oStore.has(oStore, epId)

    KC.WebRtcEndpoint.release(ep)
    assert {:ok, false} === oStore.has(oStore, epId)
  end

end
