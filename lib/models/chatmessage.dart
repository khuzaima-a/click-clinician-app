class ChatMessage {
  final String? id;
  final String senderId;
  final String? receiverId;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String chatRoomId;
  final String senderName;

  ChatMessage({
    this.id,
    required this.senderId,
    this.receiverId,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.chatRoomId,
    required this.senderName,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['Id'],
      senderId: json['SenderId'],
      receiverId: json['ReceiverId'],
      message: json['Message'],
      timestamp: DateTime.parse(json['Timestamp']),
      isRead: json['IsRead'],
      chatRoomId: json['ChatRoomId'],
      senderName: json['SenderName'],
    );
  }

  static List<ChatMessage> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => ChatMessage.fromJson(json)).toList();
  }
}