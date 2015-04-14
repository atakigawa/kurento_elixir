defmodule KCWebRTcEndpointTest do
  use ExUnit.Case

  @mediaPipeline KC.MO.MediaPipeline
  @webrtcEndpoint KC.MO.WebRtcEndpoint

  setup_all do
    mp = @mediaPipeline.create()

    on_exit fn ->
      @mediaPipeline.release(mp)
    end

    {:ok, mp: mp}
  end

  test "WebRTCEndpoint", ctx do
    mp = ctx[:mp]
    oStore = KC.Core.getObjectStoreName()

    ep = @webrtcEndpoint.create(mp)
    assert %@webrtcEndpoint{id: epId} = ep
    assert true === oStore.hasMediaObject(oStore, epId)

    @webrtcEndpoint.release(ep)
    assert false === oStore.hasMediaObject(oStore, epId)
  end

  test "BaseRtpEndpoint", ctx do
    mp = ctx[:mp]

    ep = @webrtcEndpoint.create(mp)

    assert @webrtcEndpoint.getMinVideoSendBandwidth(ep) === 100
    @webrtcEndpoint.setMinVideoSendBandwidth(ep, 123)
    assert @webrtcEndpoint.getMinVideoSendBandwidth(ep) === 123

    assert @webrtcEndpoint.getMaxVideoSendBandwidth(ep) === 500
    @webrtcEndpoint.setMaxVideoSendBandwidth(ep, 1024)
    assert @webrtcEndpoint.getMaxVideoSendBandwidth(ep) === 1024

    @webrtcEndpoint.release(ep)
  end

  test "SdpEndpoint", ctx do
    mp = ctx[:mp]

    ep = @webrtcEndpoint.create(mp)

    assert @webrtcEndpoint.getMaxVideoRecvBandwidth(ep) === 500
    @webrtcEndpoint.setMaxVideoRecvBandwidth(ep, 412)
    assert @webrtcEndpoint.getMaxVideoRecvBandwidth(ep) === 412

    offer = @webrtcEndpoint.generateOffer(ep)

    localSd = @webrtcEndpoint.getLocalSessionDescriptor(ep)
    assert String.starts_with?(localSd,
      "v=0\r\no=- 0 0 IN IP4 0.0.0.0\r\ns=Kurento Media Server")

    #TODO test these stuff
    #@webrtcEndpoint.processOffer(ep, offer)
    #@webrtcEndpoint.getRemoteSessionDescriptor(ep)
    #@webrtcEndpoint.processAnswer(ep, answer)

    @webrtcEndpoint.release(ep)
  end

  test "SessionEndpoint", ctx do
    mp = ctx[:mp]

    oStore = KC.Core.getObjectStoreName()
    ep = @webrtcEndpoint.create(mp)

    subscriptionId =  @webrtcEndpoint.subscribeMediaSessionStarted(ep)
    assert oStore.hasSubscription(oStore, subscriptionId) === true
    @webrtcEndpoint.unsubscribe(ep, subscriptionId)
    assert oStore.hasSubscription(oStore, subscriptionId) === false

    subscriptionId =  @webrtcEndpoint.subscribeMediaSessionTerminated(ep)
    assert oStore.hasSubscription(oStore, subscriptionId) === true
    @webrtcEndpoint.unsubscribe(ep, subscriptionId)
    assert oStore.hasSubscription(oStore, subscriptionId) === false

    @webrtcEndpoint.release(ep)
  end

  test "Endpoint" do
    #nothing to test
  end

  test "MediaElement", ctx do
    #TODO
  end

  test "MediaObject", ctx do
    mp = ctx[:mp]

    oStore = KC.Core.getObjectStoreName()
    ep = @webrtcEndpoint.create(mp)

    assert @webrtcEndpoint.getMediaPipeline(ep) === mp.id
    assert @webrtcEndpoint.getParent(ep) === mp.id
    assert @webrtcEndpoint.getName(ep) === ep.id

    subscriptionId =  @webrtcEndpoint.subscribeEvtError(ep)
    assert oStore.hasSubscription(oStore, subscriptionId) === true
    @webrtcEndpoint.unsubscribe(ep, subscriptionId)
    assert oStore.hasSubscription(oStore, subscriptionId) === false

    @webrtcEndpoint.release(ep)
  end
end
