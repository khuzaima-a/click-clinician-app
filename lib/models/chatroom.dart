import 'dart:convert';

class ChatRoom {
  final String id;
  final String? name;
  final String? agencyId;
  final List<String> participantIds;
  final Map<String, String> participantNames;
  final bool isGroupChat;
  final DateTime lastMessageTimestamp;
  final String? lastMessage;

  ChatRoom({
    required this.id,
    this.name,
    this.agencyId,
    required this.participantIds,
    required this.participantNames,
    required this.isGroupChat,
    required this.lastMessageTimestamp,
    required this.lastMessage
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['Id'],
      name: json['Name'],
      agencyId: json['AgencyId'],
      participantIds: List<String>.from(json['ParticipantIds']),
      participantNames: Map<String, String>.from(json['ParticipantNames']),
      isGroupChat: json['IsGroupChat'],
      lastMessageTimestamp: DateTime.parse(json['LastMessageTimestamp']),
      lastMessage: json['LastMessage']
    );
  }

  static List<ChatRoom> listFromJson(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<ChatRoom>((json) => ChatRoom.fromJson(json)).toList();
  }
}