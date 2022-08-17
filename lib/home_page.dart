import 'package:chat_app/chat_screen.dart';
import 'package:chat_app/helper/auth_helper.dart';
import 'package:chat_app/helper/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> snapshots;

  @override
  void initState() {
    super.initState();
    snapshots = _firestore.collection('users').snapshots();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: StreamBuilder(
          stream: _firestore.collection('users').snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            return ListView.builder(
                itemCount: (streamSnapshot.data != null) ? streamSnapshot.data?.docs.length : 0,
                itemBuilder: (ctx, index) {
                  if (streamSnapshot.data?.docs[index]['id'] !=
                      AuthHelper().user.uid) {
                    return ListTile(
                      title: Text(streamSnapshot.data?.docs[index]['username'] as String),
                      onTap: () {
                        createConversation(context, streamSnapshot.data?.docs[index]['id']);
                      },
                    );
                  } else {
                    return Container();
                  }
                });
          }),
    );
  }

  void createConversation(BuildContext context, String contactId){
    String uid = AuthHelper().user.uid;
    String convoId = HelperFunctions.getConvoId(uid, contactId);
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ChatScreen(uid: uid, contactId: contactId, convoId: convoId)));
  }
}
