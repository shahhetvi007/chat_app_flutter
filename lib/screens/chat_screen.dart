import 'package:chat_app/helper/auth_helper.dart';
import 'package:chat_app/helper/call_utilities.dart';
import 'package:chat_app/helper/permission.dart';
import 'package:chat_app/model/message.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/widgets/message_stream_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  String uid, contactId, convoId;

  ChatScreen(
      {required this.uid, required this.contactId, required this.convoId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;

  String username = '';
  User contactUser = User(id: '', email: '', username: '');
  User authUser = User(id: '', email: '', username: '');

  @override
  void initState() {
    super.initState();
    getUser(widget.uid);
    getUser(widget.contactId);
  }

  @override
  Widget build(BuildContext context) {
    String messageText = '';
    TextEditingController messageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        actions: [
          IconButton(
              onPressed: () async {
                await Permissions.cameraAndMicrophonePermissionsGranted()
                    ? CallUtils.dial(
                        from: authUser, to: contactUser, context: context)
                    : {};
              },
              icon: Icon(Icons.videocam)),
        ],
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
                        final timestamp =
                            Timestamp.now().millisecondsSinceEpoch.toString();
                        final message = Message(
                            idFrom: widget.uid,
                            idTo: widget.contactId,
                            content: messageText,
                            timestamp: timestamp);
                        _firestore
                            .collection('messages')
                            .doc(widget.convoId)
                            .collection(widget.convoId)
                            .doc(timestamp)
                            .set(message.toJson());
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

  void getUser(String id) async {
    print(id);
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(id).get();
    Map map = snapshot.data() as Map;
    User user =
        User(id: map['id'], email: map['email'], username: map['username']);
    setState(() {
      username = snapshot.get('username');
      if (AuthHelper().user.uid == id) {
        authUser = user;
      } else {
        contactUser = user;
      }
    });
    print(contactUser.username);
    print(username);
  }
}
