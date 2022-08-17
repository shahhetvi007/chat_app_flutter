import 'package:chat_app/helper/message.dart';
import 'package:chat_app/message_stream_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  String uid, contactId, convoId;

  ChatScreen({required this.uid, required this.contactId, required this.convoId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;

  String username = '';

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    String messageText = '';
    TextEditingController messageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      body: SafeArea(
        child: Column(
          children: [
            MessageStreamBuilder(widget.convoId),
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
                        final timestamp = Timestamp.now().millisecondsSinceEpoch.toString();
                        final message = Message(idFrom: widget.uid, idTo: widget.contactId, content: messageText, timestamp: timestamp);
                        _firestore.collection('messages').doc(widget.convoId).collection(widget.convoId).doc(timestamp).set(message.toJson());
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

  void getUserName() async{
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(widget.contactId).get();
    setState((){
      username = snapshot.get('username');
    });
    print(username);
  }

}
