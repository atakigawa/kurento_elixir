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
    mp = ctx[:mp]
    ep1 = @webrtcEndpoint.create(mp)
    ep2 = @webrtcEndpoint.create(mp)

    # media stream will be, nothing -> ep1 -> ep2 -> nothing
    @webrtcEndpoint.connect(ep1, ep2)

    assert @webrtcEndpoint.getSourceConnections(ep1) === nil
    assert @webrtcEndpoint.getSinkConnections(ep2) === nil
    # webrtcEndpoint.connect will create 2 connections. Audio and Video.
    ep1sinks = @webrtcEndpoint.getSinkConnections(ep1)
    ep2sources = @webrtcEndpoint.getSourceConnections(ep2)
    assert length(ep1sinks) === 2
    assert length(ep2sources) === 2

    ep1sink = List.first(ep1sinks)
    ep2source = List.first(ep2sources)
    # source and sink for the same connection should be the same.
    assert ep1sink["source"] === ep2source["source"]
    assert ep1sink["sink"] === ep2source["sink"]

    audioCaps = KC.MO.AudioCaps.create(
      KC.MO.AudioCaps.opusCodec, 48000)
    @webrtcEndpoint.setAudioFormat(ep1, audioCaps)
    videoCaps = KC.MO.VideoCaps.create(
      KC.MO.VideoCaps.vp8Codec, 1, 30)
    @webrtcEndpoint.setVideoFormat(ep1, videoCaps)

    @webrtcEndpoint.disconnect(ep1, ep2)
    assert @webrtcEndpoint.getSinkConnections(ep1) === nil
    assert @webrtcEndpoint.getSourceConnections(ep2) === nil

    @webrtcEndpoint.release(ep1)
    @webrtcEndpoint.release(ep2)
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
