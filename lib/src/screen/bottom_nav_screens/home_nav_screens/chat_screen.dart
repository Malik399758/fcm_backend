import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/custom_back_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:record/record.dart';
import 'package:video_player/video_player.dart';


import '../../../models/message_model.dart';
import '../../../services/firebase_db_service/message_service.dart';

enum ChatMessageType { text, image, audio,video}

class ChatMessage {
  ChatMessage({
    required this.type,
    required this.text,
    required this.time,
    required this.isMe,
    this.timestamp,
    this.imageAsset,
    this.mediaUrl,
    this.senderName,
    this.avatarAsset,
    this.filePath,
  });
  final ChatMessageType type;
  final String text;
  final String time;
  final bool isMe;
  final String? mediaUrl;
  final String? imageAsset;
  final String? senderName;
  final String? avatarAsset;
  final String? filePath;
  final Timestamp? timestamp;
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final String otherUserId;
  Stream<List<MessageModel>>? messageStream;
  final ChatService _chatService = ChatService();

  final TextEditingController inputController = TextEditingController();
  final ScrollController listController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  final Record _audioRecorder = Record();

  bool _isRecording = false;
  File? _pickedImageFile;
  File? _recordedAudioFile;

  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final args = Get.arguments;
      if (args != null && args is Map && args["uid"] != null) {
        otherUserId = args["uid"];
        if (otherUserId.isNotEmpty) {
          await _chatService.ensureChatExists(otherUserId);
          setState(() {
            messageStream = _chatService.getMessages(otherUserId);
          });
          debugPrint("✅ Chat initialized with: $otherUserId");
        }
      }
    });
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  Future<void> _showMessageMenu() async {
    final Offset pos = _tapPosition ?? const Offset(100, 100);
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(pos.dx, pos.dy, pos.dx + 1, pos.dy + 1),
      items: const [
        PopupMenuItem(value: 'reply', child: _MenuRow(icon: Icons.reply, label: 'Reply')),
        PopupMenuItem(value: 'delete', child: _MenuRow(icon: Icons.delete_outline, label: 'Delete for you')),
        PopupMenuItem(value: 'share', child: _MenuRow(icon: Icons.share_outlined, label: 'Share')),
        PopupMenuItem(value: 'download', child: _MenuRow(icon: Icons.download_outlined, label: 'Download')),
      ],
    );
  }

  Future<void> _sendText() async {
    final text = inputController.text.trim();
    if (text.isEmpty) return;

    await _chatService.sendTextMessage(otherUserId, text);
    inputController.clear();
    _scrollToBottom();
  }

  Future<void> _sendImage() async {
    if (_pickedImageFile == null) return;
    await _chatService.sendMediaMessage(
      receiverId: otherUserId,
      file: _pickedImageFile!,
      mediaType: 'image',
    );
    _pickedImageFile = null;
    _scrollToBottom();
  }

  Future<void> _sendAudio() async {
    if (_recordedAudioFile == null) return;
    await _chatService.sendMediaMessage(
      receiverId: otherUserId,
      file: _recordedAudioFile!,
      mediaType: 'audio',
    );
    _recordedAudioFile = null;
    _scrollToBottom();
  }

  Future<void> _pickImage() async {
    final status = await Permission.photos.request();
    if (!status.isGranted && !(await Permission.storage.request()).isGranted) return;

    final XFile? xfile = await _picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;

    setState(() {
      _pickedImageFile = File(xfile.path);
    });

    await _sendImage();
  }

  Future<void> _toggleRecord() async {
    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) return;

    if (_isRecording) {
      // Stop recording
      final path = await _audioRecorder.stop();
      if (path != null && path.isNotEmpty) {
        setState(() {
          _recordedAudioFile = File(path);
        });
        await _sendAudio();
      }
    } else {
      // Start recording
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(
        path: filePath,
        encoder: AudioEncoder.aacLc,  // Adjust enum if needed, e.g., AudioEncoder.aac
      );
    }

    setState(() {
      _isRecording = !_isRecording;
    });
  }


  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (listController.hasClients) {
        listController.animateTo(
          listController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    final hours = timestamp.hour.toString().padLeft(2, '0');
    final minutes = timestamp.minute.toString().padLeft(2, '0');
    return "$hours:$minutes";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final args = Get.arguments;
    final String userName = (args != null && args is Map && args["name"] != null) ? args["name"] : 'User';

    return Scaffold(
      backgroundColor: AppColors.greenColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(screenWidth * .06),
              child: Row(
                children: [
                  CustomBackButton(
                    color: AppColors.whiteColor,
                    borderColor: AppColors.transparentColor,
                  ),
                  SizedBox(width: screenWidth * .05),
                  CircleAvatar(
                    radius: screenWidth * .07,
                    backgroundImage: AssetImage(AppImages.user1),
                  ),
                  SizedBox(width: screenWidth * .03),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlackText(
                        text: userName,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        textColor: AppColors.whiteColor,
                      ),
                      BlackText(
                        text: "Online",
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        textColor: AppColors.whiteColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Messages + Input
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  width: screenWidth,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        child: messageStream == null
                            ? const Center(child: CircularProgressIndicator())
                            : StreamBuilder<List<MessageModel>>(
                          stream: messageStream!,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return const Center(child: Text("Something went wrong!"));
                            }
                            final messages = snapshot.data ?? [];
                            if (messages.isEmpty) {
                              return const Center(
                                child: Text(
                                  "Welcome! Start chatting now.",
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                              );
                            }

                            return ListView.builder(
                              controller: listController,
                              padding: EdgeInsets.fromLTRB(
                                screenWidth * .05,
                                screenWidth * .05,
                                screenWidth * .05,
                                screenWidth * .03,
                              ),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final msg = messages[index];

                                ChatMessageType type = ChatMessageType.text;
                                if (msg.mediaUrl != null && msg.mediaUrl!.isNotEmpty) {
                                  if (msg.type == 'image') {
                                    type = ChatMessageType.image;
                                  } else if (msg.type == 'audio') {
                                    type = ChatMessageType.audio;
                                  } else if (msg.type == 'video') {
                                    type = ChatMessageType.video;
                                  }
                                }


                                return GestureDetector(
                                  onTapDown: _storePosition,
                                  onLongPress: _showMessageMenu,
                                  child: _MessageBubble(
                                    message: ChatMessage(
                                      type: type,
                                      text: msg.text ?? '',
                                      time: _formatTimestamp(msg.timestamp),
                                      isMe: msg.isMe,
                                      timestamp: Timestamp.fromDate(msg.timestamp),
                                      mediaUrl: msg.mediaUrl,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      _InputBar(
                        controller: inputController,
                        onSend: _sendText,
                        onPickImage: _pickImage,
                        onRecord: _toggleRecord,
                        isRecording: _isRecording,
                      ),
                    ],
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

class _MessageBubble extends StatefulWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  State<_MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<_MessageBubble> {
  late final AudioPlayer _audioPlayer;
  VideoPlayerController? _videoController;
  Future<void>? _videoInitFuture;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Audio setup
    _audioPlayer = AudioPlayer();
    _audioPlayer.onDurationChanged.listen((d) {
      setState(() => _duration = d);
    });
    _audioPlayer.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _position = Duration.zero;
        _isPlaying = false;
      });
    });

    // Media setup
    final url = widget.message.mediaUrl?.trim();
    if (url != null && url.isNotEmpty) {
      final lowerUrl = url.split('?').first.toLowerCase();

      // Detect and initialize video
      if (lowerUrl.endsWith('.mp4') || lowerUrl.endsWith('.mov') || lowerUrl.endsWith('.webm')) {
        _videoController = VideoPlayerController.network(url);
        _videoInitFuture = _videoController!.initialize().then((_) {
          setState(() {}); // Force re-render after video is ready
        });
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  String _formatTimeFromTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    DateTime dt = timestamp.toDate();
    return DateFormat.jm().format(dt);
  }

  Widget _buildAudioPlayer(double maxWidth) {
    final progressPercent = (_duration.inMilliseconds == 0)
        ? 0.0
        : _position.inMilliseconds / _duration.inMilliseconds;

    return Container(
      width: maxWidth,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: widget.message.isMe ? Colors.green[300] : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            iconSize: 28,
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              color: Colors.black87,
            ),
            onPressed: () async {
              if (_isPlaying) {
                await _audioPlayer.pause();
              } else {
                await _audioPlayer.play(UrlSource(widget.message.mediaUrl!));
              }
              setState(() => _isPlaying = !_isPlaying);
            },
          ),
          Expanded(
            child: Container(
              height: 5,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: progressPercent.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            _formatDuration(_duration - _position),
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(double maxWidth) {
    return _videoController != null
        ? FutureBuilder(
      future: _videoInitFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () {
              if (_videoController!.value.isPlaying) {
                _videoController!.pause();
              } else {
                _videoController!.play();
              }
              setState(() {});
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                ),
                if (!_videoController!.value.isPlaying)
                  const Icon(
                    Icons.play_circle_fill,
                    size: 60,
                    color: Colors.white70,
                  ),
              ],
            ),
          );
        } else {
          return Container(
            width: maxWidth,
            height: maxWidth * (9 / 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
      },
    )
        : const Text('Video not available');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final alignment =
    widget.message.isMe ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor =
    widget.message.isMe ? AppColors.lightGreen : Colors.white;

    Widget messageContent() {
      switch (widget.message.type) {
        case ChatMessageType.text:
          return Text(
            widget.message.text,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          );
        case ChatMessageType.image:
          return widget.message.mediaUrl != null
              ? GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullscreenImagePage(imageUrl: widget.message.mediaUrl!),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.message.mediaUrl!,
                width: screenWidth * 0.6,
                height: screenWidth * 0.6,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    width: screenWidth * 0.6,
                    height: screenWidth * 0.6,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: screenWidth * 0.6,
                    height: screenWidth * 0.6,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  );
                },
              ),
            ),
          )
              : const Text('Image not available');

        case ChatMessageType.audio:
          return widget.message.mediaUrl != null
              ? _buildAudioPlayer(screenWidth * 0.5)
              : const Text('Audio not available');
        case ChatMessageType.video:
          return widget.message.mediaUrl != null
              ? _buildVideoPlayer(screenWidth * 0.6)
              : const Text('Video not available');
        default:
          return Text(
            widget.message.text,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          );
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * .03),
      child: Align(
        alignment: alignment,
        child: Column(
          crossAxisAlignment: widget.message.isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: screenWidth * .78),
              padding: widget.message.type == ChatMessageType.text
                  ? EdgeInsets.all(screenWidth * .035)
                  : EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(widget.message.isMe ? 16 : 6),
                  bottomRight: Radius.circular(widget.message.isMe ? 6 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: messageContent(),
            ),
            SizedBox(height: screenWidth * .01),
            Text(
              _formatTimeFromTimestamp(widget.message.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.onPickImage,
    required this.onRecord,
    required this.isRecording,
  });
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onPickImage;
  final VoidCallback onRecord;
  final bool isRecording;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        screenWidth * .04,
        8,
        screenWidth * .04,
        screenHeight * .012,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * .035),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Type a message here...',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: onPickImage,
                    icon: SvgPicture.asset(
                      AppImages.camera,
                      width: screenWidth * .06,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: screenWidth * .02),
          GestureDetector(onTap: onSend, child: _IconSquare(icon: Icons.send)),
          SizedBox(width: screenWidth * .02),
          GestureDetector(
            onTap: onRecord,
            child: _IconSquare(icon: isRecording ? Icons.stop : Icons.mic_none),
          ),
        ],
      ),
    );
  }
}

class _IconSquare extends StatelessWidget {
  const _IconSquare({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      height: screenWidth * .12,
      width: screenWidth * .12,
      decoration: BoxDecoration(
        color: AppColors.greenColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Icon(icon, size: 18), const SizedBox(width: 10), Text(label)],
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