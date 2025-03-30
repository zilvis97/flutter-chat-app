import 'package:course_project/model/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
    this.message, {
    super.key,
    this.isMe = true,
    required this.sameAuthorMessage,
  });

  final Message message;

  final bool isMe;

  final bool sameAuthorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final messageRow = [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            message.message,
            style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.primary, fontSize: 18),
          ),
        ),
      ),
      const SizedBox(width: 4),
      Text(
        DateFormat('hh:mm').format(message.createdAt.toDate()).toString(),
        style: TextStyle(color: theme.colorScheme.primary),
      ),
    ];

    return Padding(
      padding: EdgeInsets.only(left: 4, right: 4, top: sameAuthorMessage ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!sameAuthorMessage)
            Row(
              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(message.userImageUrl),
                  backgroundColor: theme.colorScheme.primary.withAlpha(100),
                ),
                const SizedBox(width: 8),
                Text(message.username, style: theme.textTheme.headlineSmall),
              ],
            ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: isMe ? messageRow.reversed.toList() : messageRow,
          ),
        ],
      ),
    );
  }
}
