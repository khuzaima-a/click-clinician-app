import 'dart:async';
import 'package:clickclinician/data/shared_preferences.dart';
import 'package:clickclinician/models/chatroom.dart';
import 'package:clickclinician/screens/chat_screen.dart';
import 'package:clickclinician/shared/api_calls.dart';
import 'package:clickclinician/utility/widget_file.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<StatefulWidget> createState() => ChatListScreenState();
}

class ChatListScreenState extends State<ChatListScreen> {
  List<ChatRoom> chatRooms = [];
  bool isLoading = true;
  static final SPSettings _settings = SPSettings();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadChatRooms();
    _timer = Timer.periodic(
        const Duration(seconds: 10), (timer) => _loadChatRooms());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadChatRooms() async {
    try {
      final rooms = await ApiCalls.getChatList(context);
      setState(() {
        chatRooms = rooms;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  void updateChatRooms(roomId, lastMessage) {
    int index = chatRooms.indexWhere((room) => room.id == roomId);
    if (index != -1) {
      setState(() {
        chatRooms[index] = ChatRoom(
          id: chatRooms[index].id,
          name: chatRooms[index].name,
          agencyId: chatRooms[index].agencyId,
          participantIds: chatRooms[index].participantIds,
          participantNames: chatRooms[index].participantNames,
          isGroupChat: chatRooms[index].isGroupChat,
          lastMessageTimestamp: DateTime.now(),
          lastMessage: lastMessage,
        );

        if (index != 0) {
          var updatedRoom = chatRooms.removeAt(index);
          chatRooms.insert(0, updatedRoom);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            DesignWidgets.getAppBar(context, "Chats"),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : chatRooms.isEmpty
                      ? Center(child: Text("No chats available"))
                      : Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: ListView.separated(
                            itemCount: chatRooms.length,
                            separatorBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: DesignWidgets.divider(),
                            ),
                            itemBuilder: (context, index) {
                              String lastMessage = "";
                              int unreadCount = 0;
                              String bubbleName;
                        
                              final room = chatRooms[index];
                        
                              if (room.lastMessage != null) {
                                lastMessage = room.lastMessage.toString();
                              }
                        
                              if (room.participantNames.length > 2) {
                                bubbleName = "Group Chat";
                                lastMessage = getShortParticipantList(
                                    room.participantNames);
                              } else if (room.participantNames.length == 2) {
                                final currentUserId =
                                    _settings.getUserId().toString();
                                final otherParticipantName = room
                                    .participantNames.entries
                                    .firstWhere(
                                        (entry) => entry.key != currentUserId,
                                        orElse: () => MapEntry(
                                            currentUserId, 'Unknown User'))
                                    .value;
                                bubbleName = otherParticipantName;
                              } else {
                                if (room.participantIds.length > 2) {
                                  bubbleName = "Group Chat";
                                } else {
                                  bubbleName = "Unknown User";
                                }
                              }
                        
                              return GestureDetector(
                                  onTap: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ChatScreen(
                                                    roomId: room.id,
                                                    name: bubbleName,
                                                    updateChatRooms:
                                                        updateChatRooms)))
                                      },
                                  child: DesignWidgets.getChatBubble(
                                    bubbleName,
                                    lastMessage,
                                    _formatTimestamp(room.lastMessageTimestamp),
                                    unreadCount,
                                  ));
                            },
                          ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  String getShortParticipantList(Map<String, String> participantNames) {
    List<String> shortNames = participantNames.values.map((name) {
      return name.split(' ')[0];
    }).toList();

    if (shortNames.length <= 4) {
      return shortNames.join(', ');
    } else {
      return "${shortNames.take(4).join(', ')}...";
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return DateFormat('h:mm a').format(timestamp);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(timestamp);
    } else {
      return DateFormat('MM/dd/yyyy').format(timestamp);
    }
  }
}
