import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

const String appId = "affdee50372a4d33b22c815c4a9f27b3";
const String channelName = "PritiPatel";
const String tempToken = "007eJxTYPhd5zWV65vTyd88LFPSnzxovFVV6ZBX+FXhT7z5mSe8y94qMCSmpaWkppoaGJsbJZqkGBsnGRklWxiaJpskWqYZmScZv/S8ldEQyMiQoPKUmZEBAkF8LoaAosySzIDEktQcBgYA5qUkeQ=="; // For dev only, not production

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _sharingScreen = false;
  bool _muted = false;
  bool _videoOff = false;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // Request permissions
    await [Permission.microphone, Permission.camera].request();

    // Create RTC engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(appId: appId));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.joinChannel(
      token: tempToken,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  Widget _renderLocalPreview() {
    if (_localUserJoined) {
      return Stack(
        children:[ AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: _engine,
            canvas: const VideoCanvas(uid: 0),
          ),
        ), Align(
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(_muted ? Icons.mic_off : Icons.mic),
                onPressed: () => setState(() => _muted = !_muted),
              ),
              IconButton(
                icon: Icon(_videoOff ? Icons.videocam_off : Icons.videocam),
                onPressed: () => setState(() => _videoOff = !_videoOff),
              ),
            ],
          ),
        )],
      );
    } else {
      return const Center(child: Text("Joining channel..."));
    }
  }

  Widget _renderRemoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channelName),
        ),
      );
    } else {
      return const Center(child: Text("Waiting for a remote user..."));
    }
  }
  Future<void> _toggleScreenShare() async {
    if (_sharingScreen) {
      // Stop screen sharing
      await _engine.stopScreenCapture();
      setState(() => _sharingScreen = false);
    } else {
      // Start screen sharing
      await _engine.startScreenCapture(
        const ScreenCaptureParameters(
          windowFocus: true,
          dimensions: VideoDimensions(width: 1280, height: 720),
        ) as ScreenCaptureParameters2,
      );
      setState(() => _sharingScreen = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agora Video Call')),
      body: Column(
        children: [
          Expanded(child: _renderLocalPreview()),
          Expanded(child: _renderRemoteVideo()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(_sharingScreen ? Icons.stop_screen_share : Icons.screen_share),
                onPressed: _toggleScreenShare,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
//###############################################################
/*
import 'package:flutter/material.dart';

// Placeholder video screen. Integrate your chosen SDK here.

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  bool _muted = false;
  bool _videoOff = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Call')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Video/RTC placeholder — integrate Amazon Chime / Agora here'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(_muted ? Icons.mic_off : Icons.mic),
                  onPressed: () => setState(() => _muted = !_muted),
                ),
                IconButton(
                  icon: Icon(_videoOff ? Icons.videocam_off : Icons.videocam),
                  onPressed: () => setState(() => _videoOff = !_videoOff),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}*/
