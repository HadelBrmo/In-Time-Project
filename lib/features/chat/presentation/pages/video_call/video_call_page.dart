import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../injection_container.dart';
import 'signaling_service.dart';

class VideoCallPage extends StatefulWidget {
  final int chatId;
  final String chatTitle;
  final bool isIncomingCall;
  final String? existingRoomId;

  const VideoCallPage({
    super.key,
    required this.chatId,
    required this.chatTitle,
    this.isIncomingCall = false,
    this.existingRoomId,
  });

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final SignalingService _signaling = SignalingService();
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  String? _roomId;
  bool _isMicOn = true;
  bool _isCameraOn = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _signaling.hangUp(_localRenderer);
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    _signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      if (mounted) setState(() {});
    });

    await _signaling.openUserMedia(_localRenderer);

    if (widget.isIncomingCall && widget.existingRoomId != null) {
      _roomId = widget.existingRoomId;
      await _signaling.joinRoom(_roomId!);
    } else {
      final prefs = sl<SharedPreferences>();
      final currentUserId = prefs.getInt("user_id") ?? 0;
      final currentUserName = prefs.getString("full_name") ?? "User";
      
      _roomId = await _signaling.createRoom(
        _remoteRenderer, 
        widget.chatId, 
        currentUserName, 
        currentUserId
      );
    }

    if (mounted) setState(() {});
  }

  void _toggleMic() {
    setState(() {
      _isMicOn = !_isMicOn;
      _localRenderer.srcObject?.getAudioTracks().forEach((track) {
        track.enabled = _isMicOn;
      });
    });
  }

  void _toggleCamera() {
    setState(() {
      _isCameraOn = !_isCameraOn;
      _localRenderer.srcObject?.getVideoTracks().forEach((track) {
        track.enabled = _isCameraOn;
      });
    });
  }

  void _endCall() {
    _signaling.hangUp(_localRenderer);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Remote Video (Full Screen)
          RTCVideoView(
            _remoteRenderer,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            placeholderBuilder: (context) => Container(
              color: Colors.grey[900],
              child: const Center(
                child: Text('Waiting for connection...', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),

          // Local Video (Small Overlay)
          Positioned(
            top: 50,
            right: 20,
            child: Container(
              width: 120,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: RTCVideoView(
                  _localRenderer,
                  mirror: true,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
            ),
          ),

          // Top Info
          Positioned(
            top: 50,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatTitle,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(widget.isIncomingCall ? 'Connected' : 'Calling...', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  onPressed: _toggleMic,
                  icon: _isMicOn ? Icons.mic : Icons.mic_off,
                  color: _isMicOn ? Colors.white24 : Colors.red,
                ),
                _buildControlButton(
                  onPressed: _endCall,
                  icon: Icons.call_end,
                  color: Colors.red,
                  size: 35,
                ),
                _buildControlButton(
                  onPressed: _toggleCamera,
                  icon: _isCameraOn ? Icons.videocam : Icons.videocam_off,
                  color: _isCameraOn ? Colors.white24 : Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
    double size = 28,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }
}
