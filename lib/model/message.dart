import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  const Message({
    required this.message,
    required this.userID,
    required this.username,
    required this.userImageUrl,
    required this.createdAt,
  });

  final String message;

  final String username;

  final String userID;

  final Timestamp createdAt;

  final String userImageUrl;
}
