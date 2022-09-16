import 'package:chat_app/helper/call_methods.dart';
import 'package:chat_app/helper/permission.dart';
import 'package:chat_app/model/call.dart';
import 'package:chat_app/screens/call/call_screen.dart';
import 'package:flutter/material.dart';

class PickUpScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();

  PickUpScreen({required this.call});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Incoming',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 50),
            Text(
              call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      await callMethods.endCall(call: call);
                    },
                    icon: Icon(
                      Icons.call_end,
                      color: Colors.redAccent,
                    )),
                SizedBox(width: 25),
                IconButton(
                  onPressed: () async {
                    await Permissions.cameraAndMicrophonePermissionsGranted()
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => CallScreen(call: call)))
                        : {};
                  },
                  icon: Icon(Icons.call),
                  color: Colors.green,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
