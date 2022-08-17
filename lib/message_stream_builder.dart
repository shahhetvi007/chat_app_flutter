import 'package:chat_app/helper/auth_helper.dart';
import 'package:chat_app/helper/display_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;

class MessageStreamBuilder extends StatefulWidget {
  String convoId;
  MessageStreamBuilder(this.convoId);

  @override
  State<MessageStreamBuilder> createState() => _MessageStreamBuilderState();
}

class _MessageStreamBuilderState extends State<MessageStreamBuilder> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            _firestore.collection('messages').doc(widget.convoId).collection(widget.convoId).orderBy('timestamp').snapshots(),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final messages = snapshot.data!.docs.reversed;
          List<DisplayMessages> displayMessages = [];
          for (var msg in messages) {
            final messageText = msg.get('content');
            final messageSender = msg.get('idFrom');
            final currentUser = AuthHelper().user.uid;

            final displayMessage = DisplayMessages(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
            );
            displayMessages.add(displayMessage);
          }
          return Expanded(
              child: ListView(
            reverse: true,
            padding: const  EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: displayMessages,
          ));
        });
  }


}
