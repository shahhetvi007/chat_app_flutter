import 'dart:math';

import 'package:chat_app/helper/call_methods.dart';
import 'package:chat_app/model/call.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/call/call_screen.dart';
import 'package:flutter/material.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({required User from, required User to, context}) async {
    Call call = Call(
      callerId: from.id,
      callerName: from.username,
      callerPic: '',
      receiverId: to.id,
      receiverName: to.username,
      receiverPic: '',
      channelId: Random().nextInt(1000).toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      print('channelId ${call.channelId}');
      print('callerId ${call.callerId}');
      print('receiverId ${call.receiverId}');
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CallScreen(call: call)));
    }
  }
}
