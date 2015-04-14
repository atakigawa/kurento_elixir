defmodule KCWebRTcEndpointTest do
  use ExUnit.Case

  setup_all do
    mp = KC.MO.MediaPipeline.create()

    on_exit fn ->
      KC.MO.MediaPipeline.release(mp)
    end

    {:ok, mp: mp}
  end

  test "webrtcendpoint", ctx do
    mp = ctx[:mp]
    oStore = KC.Core.getObjectStoreName()

    ep = KC.MO.WebRtcEndpoint.create(mp)
    assert %KC.MO.WebRtcEndpoint{id: epId} = ep
    assert {:ok, true} === oStore.has(oStore, epId)

    KC.MO.WebRtcEndpoint.release(ep)
    assert {:ok, false} === oStore.has(oStore, epId)
  end

end
