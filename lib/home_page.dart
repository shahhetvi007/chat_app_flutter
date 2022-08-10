import 'package:chat_app/helper/auth_helper.dart';
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
        title: Text('Home'),
      ),
      body: StreamBuilder(
          stream: _firestore.collection('users').snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (ctx, index) {
                  if (streamSnapshot.data!.docs[index]['id'] !=
                      AuthHelper().user.uid) {
                    return ListTile(
                      title: Text(streamSnapshot.data!.docs[index]['username']),
                      onTap: () {
                        Navigator.of(context).pushNamed('chat_screen');
                      },
                    );
                  } else {
                    return Container();
                  }
                });
          }),
      // Center(
      //   child: TextButton(
      //     onPressed: () {
      //       Navigator.of(context)
      //           .push(MaterialPageRoute(builder: (ctx) => ChatScreen()));
      //     },
      //     child: Text('Chat Screen'),
      //   ),
      // ),
    );
  }
}
