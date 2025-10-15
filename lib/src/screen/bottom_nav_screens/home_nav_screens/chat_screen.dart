import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/custom_back_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../models/message_model.dart';
import '../../../services/firebase_db_service/message_service.dart';

enum ChatMessageType { text, image, audio }

class ChatMessage {
  ChatMessage({
    required this.type,
    required this.text,
    required this.time,
    required this.isMe,
    this.imageAsset,
    this.senderName,
    this.avatarAsset,
    this.filePath,
  });
  final ChatMessageType type;
  final String text;
  final String time;
  final bool isMe;
  final String? imageAsset;
  final String? senderName;
  final String? avatarAsset;
  final String? filePath;
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

 /* void _sendText() {
    final text = inputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      messages.add(
        ChatMessage(
          type: ChatMessageType.text,
          text: text,
          time: 'now',
          isMe: true,
          senderName: 'Me',
          avatarAsset: AppImages.user1,
        ),
      );
    });
    inputController.clear();
    Future.delayed(const Duration(milliseconds: 50), () {
      if (listController.hasClients) {
        listController.animateTo(
          listController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }*/

  void _sendText() async {
    final text = inputController.text.trim();
    if (text.isEmpty) return;

    // Send message via your ChatService
    await _chatService.sendTextMessage(otherUserId, text);

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
                      /*Expanded(
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
                      ),*/
                     /* StreamBuilder<List<MessageModel>>(
                        stream: messageStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final messages = snapshot.data!;

                          // Agar messages empty hain, toh welcome message show karo
                          if (messages.isEmpty) {
                            return Center(
                              child: Text(
                                "Welcome! Start chatting now.",
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            );
                          }

                          // Agar messages hain, toh normal list dikhayein
                          return ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final msg = messages[index];
                              return _MessageBubble(message: msg);
                            },
                          );
                        },
                      ),*/

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
                                return GestureDetector(
                                  onTapDown: _storePosition,
                                  onLongPress: _showMessageMenu,
                                  child: _MessageBubble(
                                    message: ChatMessage(
                                      type: ChatMessageType.text,
                                      text: msg.text,
                                      time: _formatTimestamp(msg.timestamp),
                                      isMe: msg.isMe,
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
/*class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final bubbleColor = message.isMe ? AppColors.lightGreen : Colors.white;
    final alignment =
        message.isMe ? Alignment.centerRight : Alignment.centerLeft;

    Widget content;
    switch (message.type) {
      case ChatMessageType.text:
        content = BlackText(
          text: message.text,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          textColor: Colors.black,
        );
        break;
      case ChatMessageType.image:
        content = ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child:
              message.filePath != null
                  ? Image.file(
                    File(message.filePath!),
                    width: screenWidth * .6,
                    fit: BoxFit.cover,
                  )
                  : Image.asset(
                    AppImages.user1,
                    width: screenWidth * .6,
                    fit: BoxFit.cover,
                  ),
        );
        break;
      case ChatMessageType.audio:
        content = Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * .03,
            vertical: screenWidth * .02,
          ),
          decoration: BoxDecoration(
            color: AppColors.greenColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: screenWidth * .06,
              ),
              SizedBox(width: screenWidth * .02),
              Container(
                width: screenWidth * .35,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: screenWidth * .02),
              BlackText(
                text: message.text,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                textColor: Colors.white,
              ),
            ],
          ),
        );
        break;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * .03),
      child: Align(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: screenWidth * .78),
              padding:
                  message.type == ChatMessageType.image
                      ? EdgeInsets.zero
                      : EdgeInsets.all(screenWidth * .035),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isMe ? 16 : 6),
                  bottomRight: Radius.circular(message.isMe ? 6 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: content,
            ),
            SizedBox(height: screenWidth * .01),
            BlackText(
              text: message.time,
              fontSize: 10,
              fontWeight: FontWeight.w400,
              textColor: AppColors.greyColor,
            ),
          ],
        ),
      ),
    );
  }
}*/

class _MessageBubbleState extends State<_MessageBubble> {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final alignment =
    widget.message.isMe ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor =
    widget.message.isMe ? AppColors.lightGreen : Colors.white;

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
              padding: EdgeInsets.all(screenWidth * .035),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
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
              child: Text(
                widget.message.text,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
            SizedBox(height: screenWidth * .01),
            /*Text(
              _formatTime(widget.message.time),
              style: TextStyle(
                fontSize: 10,
                color: AppColors.greyColor,
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
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
