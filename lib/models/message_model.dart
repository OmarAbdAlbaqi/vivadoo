import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String chatId;
  final bool isResponse;
  final bool isRead;
  final bool isPushed;
  final bool isFile;
  final String message;
  final DateTime? readAt;
  final DateTime sentAt;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.isResponse,
    required this.isRead,
    required this.isPushed,
    required this.isFile,
    required this.message,
    required this.readAt,
    required this.sentAt,
  });

  /// Factory for normal JSON (e.g. from API)
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'].toString(),
      chatId: json['chatId'],
      isResponse: json['isResponse'],
      isRead: json['isRead'],
      isPushed: json['isPushed'],
      isFile: json['isFile'],
      message: json['message'],
      readAt: json['readAt'] != null ? DateTime.tryParse(json['readAt']) : null,
      sentAt: DateTime.parse(json['sentAt']['date']),
    );
  }

  /// Factory for Firestore
  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;


    return MessageModel(
      id: doc.id.toString(), // Use Firestore's document ID
      chatId: data['chatId'].toString() ?? "",
      isResponse: data['isResponse'] ?? false,
      isRead: data['isRead'] ?? false,
      isPushed: data['isPushed'] ?? false,
      isFile: data['isFile'] ?? false,
      message: data['message'],
      sentAt: _parseTimestamp(data['sentAt']),
      readAt: data['readAt'] != null ? (data['readAt'] as Timestamp).toDate() : null,
    );
  }

  // Utility method to handle Timestamp conversion
  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      return DateTime.parse(timestamp); // If it's a string, we parse it
    } else {
      throw const FormatException("Invalid timestamp format");
    }
  }

  /// Convert model back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'isResponse': isResponse,
      'isRead': isRead,
      'isPushed': isPushed,
      'isFile': isFile,
      'message': message,
      'readAt': readAt?.toIso8601String(),
      'sentAt': sentAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'MessageModel{id: $id, chatId: $chatId, isResponse: $isResponse, isRead: $isRead, isPushed: $isPushed, isFile: $isFile, message: $message, readAt: $readAt, sentAt: $sentAt}';
  }
}
