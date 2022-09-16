import 'package:chat_app/helper/auth_helper.dart';
import 'package:chat_app/helper/call_methods.dart';
import 'package:chat_app/model/call.dart';
import 'package:chat_app/screens/call/pickup/pickup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PickUpLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickUpLayout({required this.scaffold});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: callMethods.callStream(uid: AuthHelper().user.uid),
        builder: (ctx, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data.data() != null) {
            Call call = Call.fromJson(snapshot.data.data());
            if (!call.hasDialled!) {
              return PickUpScreen(call: call);
            }
            return scaffold;
          }
          return scaffold;
        });
  }
}
