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
import 'package:record/record.dart';


import '../../../models/message_model.dart';
import '../../../services/firebase_db_service/message_service.dart';

enum ChatMessageType { text, image, audio }

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

/*class _ChatScreenState extends State<ChatScreen> {
  late final String otherUserId;
  Stream<List<MessageModel>>? messageStream;
  final ChatService _chatService = ChatService();


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





  final List<ChatMessage> messages = [];

  final TextEditingController inputController = TextEditingController();
  final ScrollController listController = ScrollController();
  Offset? _tapPosition;
  final ImagePicker _picker = ImagePicker();
  bool _isRecording = false;

  void _storePosition(TapDownDetails d) {
    _tapPosition = d.globalPosition;
  }

  Future<void> _showMessageMenu() async {
    final Offset pos = _tapPosition ?? const Offset(100, 100);
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(pos.dx, pos.dy, pos.dx + 1, pos.dy + 1),
      items: const [
        PopupMenuItem(
          value: 'reply',
          child: _MenuRow(icon: Icons.reply, label: 'Reply'),
        ),
        PopupMenuItem(
          value: 'delete',
          child: _MenuRow(icon: Icons.delete_outline, label: 'Delete for you'),
        ),
        PopupMenuItem(
          value: 'share',
          child: _MenuRow(icon: Icons.share_outlined, label: 'Share'),
        ),
        PopupMenuItem(
          value: 'download',
          child: _MenuRow(icon: Icons.download_outlined, label: 'Download'),
        ),
      ],
    );
  }
  void _sendText() async {
    final text = inputController.text.trim();
    if (text.isEmpty) return;

    // For text
    await _chatService.sendMessage(
      receiverId: otherUserId,
      text: inputController.text.trim(),
    );

// For image
    await _chatService.sendMediaMessage(
      receiverId: otherUserId,
      file: pickedImageFile,
      mediaType: 'image',
    );

// For audio
    await _chatService.sendMediaMessage(
      receiverId: otherUserId,
      file: recordedAudioFile,
      mediaType: 'audio',
    );


    inputController.clear();

    // Optionally, scroll to bottom after a short delay
    Future.delayed(const Duration(milliseconds: 50), () {
      if (listController.hasClients) {
        listController.animateTo(
          listController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }


  Future<void> _pickImage() async {
    final status = await Permission.photos.request();
    if (!status.isGranted && !(await Permission.storage.request()).isGranted)
      return;
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() {
      messages.add(
        ChatMessage(
          type: ChatMessageType.image,
          text: '',
          time: 'now',
          isMe: true,
          filePath: file.path,
          senderName: 'Me',
          avatarAsset: AppImages.user1,
        ),
      );
    });
    _autoReply();
  }

  Future<void> _toggleRecord() async {
    final mic = await Permission.microphone.request();
    if (!mic.isGranted) return;
    setState(() => _isRecording = !_isRecording);
    if (!_isRecording) {
      // Simulate a short audio clip once recording stops
      setState(() {
        messages.add(
          ChatMessage(
            type: ChatMessageType.audio,
            text: '0:13',
            time: 'now',
            isMe: true,
            senderName: 'Me',
            avatarAsset: AppImages.user1,
          ),
        );
      });
      _autoReply();
    }
  }

  void _autoReply() {
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        messages.add(
          ChatMessage(
            type: ChatMessageType.text,
            text: 'Auto reply: Got your message!',
            time: 'now',
            isMe: false,
            senderName: 'Angie Brekke',
            avatarAsset: AppImages.user1,
          ),
        );
      });
      if (listController.hasClients) {
        listController.animateTo(
          listController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final args = Get.arguments;
    final String userName = (args != null && args is Map && args["name"] != null) ? args["name"] : 'User';
    String _formatTimestamp(DateTime timestamp) {
      final hours = timestamp.hour.toString().padLeft(2, '0');
      final minutes = timestamp.minute.toString().padLeft(2, '0');
      return "$hours:$minutes";
    }

    return Scaffold(
      backgroundColor: AppColors.greenColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * .06),
              child: Row(
                children: [
                  CustomBackButton(
                    color: AppColors.whiteColor,
                    borderColor: AppColors.transparentColor,
                  ),
                  SizedBox(width: screenWidth * .05),
                  Row(
                    children: [
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
                ],
              ),
            ),
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
                      *//*Expanded(
                        child: ListView.builder(
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
                            return GestureDetector(
                              onTapDown: _storePosition,
                              onLongPress: _showMessageMenu,
                              child: _MessageBubble(message: msg),
                            );
                          },
                        ),
                      ),*//*
                      Expanded(
                        child: messageStream == null
                            ? Center(child: CircularProgressIndicator())
                            : StreamBuilder<List<MessageModel>>(
                          stream: messageStream!,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Center(child: Text("Something went wrong!"));
                            }

                            final messages = snapshot.data ?? [];

                            if (messages.isEmpty) {
                              return Center(
                                child: Text(
                                  "Welcome! Start chatting now.",
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                              );
                            }

                            return *//*ListView.builder(
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
                                return GestureDetector(
                                  onTapDown: _storePosition,
                                  onLongPress: _showMessageMenu,
                                  child: _MessageBubble(
                                    message: ChatMessage(
                                      type: ChatMessageType.text,
                                      text: msg.text,
                                      time: _formatTimestamp(msg.timestamp),
                                      isMe: msg.isMe,
                                      timestamp: Timestamp.fromDate(msg.timestamp),
                                    ),
                                  ),

                                );
                              },
                            );*//* // In the ListView.builder inside StreamBuilder:
                            ListView.builder(
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

                                // Determine message type from your MessageModel fields.
                                ChatMessageType type = ChatMessageType.text; // Default

                                if (msg.mediaUrl != null && msg.mediaUrl!.isNotEmpty) {
                                  // Simple example: check file extension or type if you store it
                                  if (msg.mediaUrl!.endsWith('.jpg') ||
                                      msg.mediaUrl!.endsWith('.png') ||
                                      msg.mediaUrl!.endsWith('.jpeg') ||
                                      msg.mediaUrl!.contains('image')) {
                                    type = ChatMessageType.image;
                                  } else if (msg.mediaUrl!.endsWith('.mp3') ||
                                      msg.mediaUrl!.endsWith('.m4a') ||
                                      msg.mediaUrl!.contains('audio')) {
                                    type = ChatMessageType.audio;
                                  }
                                }

                                return GestureDetector(
                                  onTapDown: _storePosition,
                                  onLongPress: _showMessageMenu,
                                  child: _MessageBubble(
                                    message: ChatMessage(
                                      type: type,
                                      text: msg.text ?? '',   // fallback to empty if null
                                      time: _formatTimestamp(msg.timestamp),
                                      isMe: msg.isMe,
                                      timestamp: Timestamp.fromDate(msg.timestamp),
                                      mediaUrl: msg.mediaUrl,
                                     // avatarAsset: msg.avatarAsset,
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
}*/

/*class _ChatScreenState extends State<ChatScreen> {
  late final String otherUserId;
  Stream<List<MessageModel>>? messageStream;
  final ChatService _chatService = ChatService();

  final TextEditingController inputController = TextEditingController();
  final ScrollController listController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  // final Record _audioRecorder = Record();


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

    // Send text message
    await _chatService.sendTextMessage(otherUserId, inputController.text);

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

    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    setState(() {
      _pickedImageFile = File(file.path);
    });

    await _sendImage();
  }

  Future<void> _toggleRecord() async {
    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) return;

    setState(() {
      _isRecording = !_isRecording;
    });

    if (!_isRecording) {
      // Assume you have recorded audio saved to _recordedAudioFile
      // You need to implement audio recording and saving logic yourself
      if (_recordedAudioFile != null) {
        await _sendAudio();
      }
    }
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
            // Header with back button and user info
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
            // Messages and input
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
                              return Center(child: Text("Something went wrong!"));
                            }
                            final messages = snapshot.data ?? [];
                            if (messages.isEmpty) {
                              return Center(
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
                                  if (msg.mediaUrl!.contains('.jpg') ||
                                      msg.mediaUrl!.contains('.png') ||
                                      msg.mediaUrl!.contains('.jpeg') ||
                                      msg.type == 'image') {
                                    type = ChatMessageType.image;
                                  } else if (msg.mediaUrl!.contains('.mp3') ||
                                      msg.mediaUrl!.contains('.m4a') ||
                                      msg.type == 'audio') {
                                    type = ChatMessageType.audio;
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
                      // Input bar
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
}*/


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
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  @override
  @override
  void initState() {
    super.initState();

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
  }


  @override
  void dispose() {
    _audioPlayer.dispose();
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
    return DateFormat.jm().format(dt); // e.g., 2:00 PM
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
          // Play/Pause button
          IconButton(
            iconSize: 28,
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              color: Colors.black87,
            ),
            onPressed: () async {
              if (_isPlaying) {
                await _audioPlayer.pause();
                setState(() => _isPlaying = false);
              } else {
                await _audioPlayer.play(UrlSource(widget.message.mediaUrl!));
                setState(() => _isPlaying = true);
              }
            },
          ),


          // Progress bar
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

          // Duration left
          Text(
            _formatDuration(_duration - _position),
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final alignment = widget.message.isMe ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = widget.message.isMe ? AppColors.lightGreen : Colors.white;

    Widget messageContent() {
      switch (widget.message.type) {
        case ChatMessageType.text:
          return Text(
            widget.message.text,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          );
        case ChatMessageType.image:
          if (widget.message.mediaUrl != null) {
            return ClipRRect(
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
            );
          } else {
            return const Text('Image not available');
          }
        case ChatMessageType.audio:
          if (widget.message.mediaUrl != null) {
            return _buildAudioPlayer(screenWidth * 0.5);
          } else {
            return const Text('Audio not available');
          }
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
          crossAxisAlignment:
          widget.message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: screenWidth * .78),
              padding: widget.message.type == ChatMessageType.text
                  ? EdgeInsets.all(screenWidth * .035)
                  : EdgeInsets.all(0), // No padding for image/audio
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
