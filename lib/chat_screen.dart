import 'package:chat_app/helper/auth_helper.dart';
import 'package:chat_app/message_stream_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    String messageText = '';
    TextEditingController messageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            MessageStreamBuilder(),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (val) {
                        messageText = val;
                      },
                      decoration:
                          InputDecoration(hintText: 'Write your message'),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        messageController.clear();
                        _firestore.collection('messages').doc().set({
                          'text': messageText,
                          'sender': AuthHelper().user.email,
                          'createdAt': Timestamp.now(),
                        });
                      },
                      icon: Icon(Icons.send))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
