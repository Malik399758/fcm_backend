
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:record/record.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

// Assuming these are correctly defined in your project
import '../../../models/group_message.dart';
import '../../../services/firebase_db_service/group_service.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  // Optional: Add a group image URL here if available in your Group model
  final String? groupImageUrl;

  const GroupChatScreen({
    Key? key,
    required this.groupId,
    required this.groupName,
    this.groupImageUrl, // Added for professional UI
  }) : super(key: key);

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GroupService _groupService = GroupService();
  final ImagePicker _picker = ImagePicker();
  final Record _audioRecorder = Record();

  final String myUid = FirebaseAuth.instance.currentUser!.uid;
  String myName = 'You';      // default
  bool _isNameLoading = true;

  bool _isRecording = false;
  File? _pickedImageFile;
  File? _pickedVideoFile;
  File? _recordedAudioFile;

  // New state for recording time display
  Duration _recordDuration = Duration.zero;
  Stopwatch? _recordStopwatch;
  Ticker? _ticker;

  @override
  void initState() {
    super.initState();
    _fetchMyName();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _ticker?.dispose();
    super.dispose();
  }

  // Helper to update recording duration
  void _updateRecordingDuration() {
    if (_recordStopwatch != null && _recordStopwatch!.isRunning) {
      if (mounted) {
        setState(() {
          _recordDuration = _recordStopwatch!.elapsed;
        });
      }
    }
  }

  Future<void> _fetchMyName() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('profile')
          .doc(myUid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data.containsKey('name')) {
          setState(() {
            myName = data['name'];
            _isNameLoading = false;
          });
          return;
        }
      }
      setState(() {
        _isNameLoading = false;
      });
    } catch (e) {
      print('Error fetching name: $e');
      setState(() {
        _isNameLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    // Professional format: HH:MM AM/PM
    final time = TimeOfDay.fromDateTime(timestamp);
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> _sendTextMessage() async {
    if (_isNameLoading) return;

    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final message = GroupMessage(
      senderId: myUid,
      senderName: myName,
      message: text,
      timestamp: DateTime.now(),
      messageType: 'text',
    );

    await _groupService.sendGroupMessage(widget.groupId, message);
    _messageController.clear();
  }

  Future<void> _pickImage() async {
    final status = await Permission.mediaLibrary.request();
    if (!status.isGranted) return;

    final XFile? xfile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (xfile == null) return;

    setState(() {
      _pickedImageFile = File(xfile.path);
    });

    await _sendImage();
  }

  Future<void> _sendImage() async {
    if (_pickedImageFile == null) return;

    await _groupService.sendMediaMessage(
      groupId: widget.groupId,
      senderId: myUid,
      senderName: myName,
      file: _pickedImageFile!,
      mediaType: 'image',
    );

    setState(() {
      _pickedImageFile = null;
    });
  }

  Future<void> _pickVideo() async {
    final status = await Permission.mediaLibrary.request();
    if (!status.isGranted) return;

    final XFile? xfile = await _picker.pickVideo(source: ImageSource.gallery);
    if (xfile == null) return;

    setState(() {
      _pickedVideoFile = File(xfile.path);
    });

    await _sendVideo();
  }

  Future<void> _sendVideo() async {
    if (_pickedVideoFile == null) return;

    await _groupService.sendMediaMessage(
      groupId: widget.groupId,
      senderId: myUid,
      senderName: myName,
      file: _pickedVideoFile!,
      mediaType: 'video',
    );

    setState(() {
      _pickedVideoFile = null;
    });
  }

  Future<void> _toggleRecording() async {
    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) return;

    if (_isRecording) {
      // STOP Recording
      _recordStopwatch?.stop();
      _ticker?.dispose();
      final path = await _audioRecorder.stop();

      if (path != null && path.isNotEmpty) {
        _recordedAudioFile = File(path);
        await _sendAudio();
      }

      setState(() {
        _isRecording = false;
        _recordDuration = Duration.zero;
      });
    } else {
      // START Recording
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(
        path: filePath,
        encoder: AudioEncoder.aacLc,
      );

      _recordStopwatch = Stopwatch()..start();
      _ticker = Ticker((elapsed) => _updateRecordingDuration())..start();

      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _sendAudio() async {
    if (_recordedAudioFile == null) return;

    await _groupService.sendMediaMessage(
      groupId: widget.groupId,
      senderId: myUid,
      senderName: myName,
      file: _recordedAudioFile!,
      mediaType: 'audio',
    );

    setState(() {
      _recordedAudioFile = null;
    });
  }

  // Refined message bubble widget
  Widget _buildMessageBubble(GroupMessage msg) {
    final isMe = msg.senderId == myUid;
    final primaryColor = isMe ? const Color(0xFFDCF8C6) : Colors.white;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: Radius.circular(isMe ? 12 : 4),
      bottomRight: Radius.circular(isMe ? 4 : 12),
    );

    // Dynamic text/icon color for better contrast on bubble
    final contentColor = isMe ? Colors.black87 : Colors.black87;
    final timeColor = isMe ? Colors.black54.withOpacity(0.7) : Colors.black54.withOpacity(0.7);


    Widget content;
    switch (msg.messageType) {
      case 'image':
        content = msg.mediaUrl != null
            ? GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullscreenImagePage(imageUrl: msg.mediaUrl!),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 300,
              height: 200,
              child: Image.network(
                msg.mediaUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stack) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
        )
            : Text('Image not available', style: TextStyle(color: contentColor));
        break;


      case 'video':
        content = msg.mediaUrl != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 300,
            height: 200,
            child: _VideoPlayerWidget(videoUrl: msg.mediaUrl!),
          ),
        )
            : Text('Video not available', style: TextStyle(color: contentColor));
        break;


      case 'audio':
        content = msg.mediaUrl != null
            ? _AudioPlayerWidget(audioUrl: msg.mediaUrl!, isMe: isMe)
            : Text('Audio not available', style: TextStyle(color: contentColor));
        break;

      case 'text':
      default:
        content = Text(
          msg.message,
          style: TextStyle(fontSize: 16, color: contentColor),
        );
    }

    // Standard bubble padding for text and media
    final bubblePadding = msg.messageType == 'text'
        ? const EdgeInsets.symmetric(vertical: 8, horizontal: 12)
        : const EdgeInsets.all(4); // Less padding for media

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: bubblePadding,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sender name (Only for others, not 'Me')
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  msg.senderName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.indigo,
                  ),
                ),
              ),

            // Message Content
            content,

            // Time stamp
            Padding(
              padding: EdgeInsets.only(top: msg.messageType == 'text' ? 4 : 0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTimestamp(msg.timestamp),
                      style: TextStyle(fontSize: 10, color: timeColor),
                    ),
                    const SizedBox(width: 4),
                    // Optional: Add a 'read' status checkmark here if you implement it
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.greenColor, // WhatsApp green
      foregroundColor: Colors.white,
      title: Row(
        children: [
          // Group image placeholder
          CircleAvatar(
            backgroundColor: Colors.green[300],
            // Use Image.network(widget.groupImageUrl!) if you pass it
            child: const Icon(Icons.group, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.groupName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  'Tap for group info',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
      ],
    );
  }

  // Refined Input Field
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Media Buttons (Image, Video) - combined into a single floating action button style
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green[700],
            ),
            margin: const EdgeInsets.only(right: 8.0),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'image') {
                  _pickImage();
                } else if (value == 'video') {
                  _pickVideo();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'image',
                  child: ListTile(
                    leading: Icon(Icons.image, color: Colors.green),
                    title: Text('Photo'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'video',
                  child: ListTile(
                    leading: Icon(Icons.videocam, color: Colors.green),
                    title: Text('Video'),
                  ),
                ),
              ],
              icon: const Icon(Icons.attach_file, color: Colors.white),
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),

          // Message Input Field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    if (_isRecording)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            const Icon(Icons.mic, color: Colors.red, size: 20),
                            const SizedBox(width: 5),
                            Text(
                              'REC: ${_formatDuration(_recordDuration)}',
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    else
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          minLines: 1,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: _isNameLoading ? 'Loading...' : 'Message...',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onSubmitted: (_) => _sendTextMessage(),
                          enabled: !_isNameLoading,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send/Record Button
          GestureDetector(
            onLongPressStart: (_) {
              if (!_isRecording) {
                _toggleRecording(); // Start recording on long press
              }
            },
            onLongPressEnd: (_) {
              if (_isRecording) {
                _toggleRecording(); // Stop recording on end long press
              }
            },
            onTap: _isRecording ? null : _sendTextMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[700],
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isRecording || _messageController.text.trim().isNotEmpty
                    ? Icons.send
                    : Icons.mic,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for chat
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<GroupMessage>>(
              stream: _groupService.getGroupMessages(widget.groupId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final messages = snapshot.data ?? [];
                if (messages.isEmpty) {
                  return const Center(child: Text('Say "Hi" to start the chat! 👋'));
                }

                // Scroll to bottom after frame is built
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(messages[index]);
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
          // Padding for keyboard if needed
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 8 : 0),
        ],
      ),
    );
  }
}


// Video widget
class _VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const _VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<_VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  static const double _mediaSize = 200; // Consistent size for media

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the aspect ratio is controlled
        setState(() {
          _initialized = true;
          // Loop the video (optional)
          _controller.setLooping(true);
        });
      }).catchError((e) {
        if (mounted) {
          setState(() {
            _initialized = false; // Error loading
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Container(
        width: _mediaSize,
        height: _mediaSize,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.green))),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: _mediaSize,
        height: _mediaSize,
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            // Play/Pause button overlay
            AnimatedOpacity(
              opacity: _controller.value.isPlaying ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      _controller.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                      size: 60,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Audio widget (WhatsApp style)
class _AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final bool isMe;

  const _AudioPlayerWidget({
    Key? key,
    required this.audioUrl,
    required this.isMe,
  }) : super(key: key);

  @override
  State<_AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<_AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    // Set up listeners
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _playerState = state;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    // Get the duration initially
    _audioPlayer.setSourceUrl(widget.audioUrl).then((_) {
      _audioPlayer.getDuration().then((d) {
        if (d != null && mounted) {
          setState(() => _duration = d);
        }
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_playerState == PlayerState.playing) {
      await _audioPlayer.pause();
    } else if (_playerState == PlayerState.paused || _playerState == PlayerState.stopped) {
      if (_position >= _duration) {
        // Restart if finished
        await _audioPlayer.seek(Duration.zero);
      }
      await _audioPlayer.play(UrlSource(widget.audioUrl));
    }
  }

  String _formatAudioDuration(Duration d) {
    if (d.inMilliseconds <= 0) return '0:00';
    String minute = d.inMinutes.toString();
    String second = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minute:$second';
  }

  @override
  Widget build(BuildContext context) {
    final bool isPlaying = _playerState == PlayerState.playing;
    final Color iconColor = widget.isMe ? Colors.black : Colors.green[700]!;
    final Color activeColor = widget.isMe ? Colors.green.shade700 : Colors.green[300]!;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 180, maxWidth: 250),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause Button
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 20, color: iconColor),
              onPressed: _togglePlay,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          const SizedBox(width: 8),

          // Progress Bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2.0,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 10.0),
                    ),
                    child: Slider(
                      min: 0.0,
                      max: _duration.inMilliseconds.toDouble(),
                      value: _position.inMilliseconds.toDouble().clamp(0.0, _duration.inMilliseconds.toDouble()),
                      activeColor: activeColor,
                      inactiveColor: iconColor.withOpacity(0.2),
                      onChanged: (double value) {
                        _audioPlayer.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                  ),
                ),
                // Duration Text
                Text(
                  _formatAudioDuration(_duration - _position),
                  style: TextStyle(fontSize: 12, color: iconColor.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// image view


class FullscreenImagePage extends StatelessWidget {
  final String imageUrl;
  const FullscreenImagePage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          loadingBuilder: (context, event) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Icon(Icons.broken_image, size: 50, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
