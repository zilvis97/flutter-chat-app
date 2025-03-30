import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_project/model/message.dart';
import 'package:course_project/widgets/chat_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No Messages found'));
        }
        if (snapshot.hasError) return const Center(child: Text('something went wrong'));

        final messages = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 16, right: 16),
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (ctx, idx) {
            final currentUserID = FirebaseAuth.instance.currentUser!.uid;
            final currentItem = messages[idx].data();
            final message = Message(
              message: currentItem['text'],
              userID: currentItem['userID'],
              username: currentItem['username'],
              userImageUrl: currentItem['userImage'],
              createdAt: currentItem['createdAt'],
            );
            final isMe = currentUserID == message.userID;

            var sameAuthorMessage = false;
            if (idx < messages.length - 1) {
              final prevMsgAuthor = messages[idx + 1].data()['userID'];
              sameAuthorMessage = message.userID == prevMsgAuthor;
            }

            return ChatMessage(
              message,
              isMe: isMe,
              sameAuthorMessage: sameAuthorMessage,
              key: ValueKey(message.userID),
            );
          },
        );
      },
    );
  }
}
