import 'dart:async';
import 'package:clickclinician/data/shared_preferences.dart';
import 'package:clickclinician/models/chatmessage.dart';
import 'package:clickclinician/utility/color_file.dart';
import 'package:clickclinician/utility/style_file.dart';
import 'package:clickclinician/utility/widget_file.dart';
import 'package:flutter/material.dart';

import '../shared/api_calls.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String name;
  final void Function(dynamic, dynamic) updateChatRooms;
  const ChatScreen(
      {super.key,
      required this.roomId,
      required this.name,
      required this.updateChatRooms});

  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  final ScrollController _scrollController = ScrollController();
  final _settings = SPSettings();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadMessages();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isSending) {
        _loadMessages();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    try {
      final messages = await ApiCalls.getChatMessages(
        chatRoomId: widget.roomId,
        skip: 0,
        take: 50,
        context: context,
      );

      setState(() {
        if (messages.length > _messages.length) {
          _messages = messages;
        }
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading messages: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final senderId = _settings.getUserId();
    if (senderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Unable to send message. User ID not found.')),
      );
      return;
    }

    setState(() {
      _isSending = true;
      _messages.insert(
          _messages.length,
          ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            chatRoomId: widget.roomId,
            senderId: senderId,
            senderName: _settings.getUserName() ?? 'Me',
            receiverId: '',
            message: message,
            timestamp: DateTime.now(),
            isRead: false,
          ));
      _messageController.clear();
    });

    widget.updateChatRooms(widget.roomId, message);

    try {
      await ApiCalls.sendMessage(
        chatRoomId: widget.roomId,
        senderId: senderId,
        receiverId: '',
        message: message,
        context: context,
      );
      _isSending = false;
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to send message. Please try again.')),
      );

      setState(() {
        _isSending = false;
        _messages.removeAt(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DesignWidgets.getChatScreenAppBar(context, widget.name),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[_messages.length - index - 1];
                        return ChatMessageWidget(message: message);
                      },
                    ),
            ),
            _buildTextComposer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _messageController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Enter your message here",
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: CustomStyles.paragraphSubText,
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          DesignWidgets.addHorizontalSpace(8.0),
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final _settings = SPSettings();

  ChatMessageWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? id = _settings.getUserId();
    final bool isMe = message.senderId == id;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                message.senderName,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: isMe
                      ? const Color.fromARGB(255, 220, 220, 220)
                      : ColorsUI.primaryColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  message.message,
                  style: TextStyle(
                    color: isMe ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
