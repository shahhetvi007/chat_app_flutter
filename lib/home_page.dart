import 'package:chat_app/chat_screen.dart';
import 'package:chat_app/helper/auth_helper.dart';
import 'package:chat_app/helper/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> snapshots;

  late AndroidNotificationChannel channel;
  bool isFlutterLocalNotificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    snapshots = _firestore.collection('users').snapshots();
    FirebaseMessaging.instance.getToken().then((value) {
      print('token');
      print(value);
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessgaingBackgroundHandler);
  }

  Future<void> _firebaseMessgaingBackgroundHandler(RemoteMessage message) async{
    await Firebase.initializeApp();
    await setUpFlutterNotifications();
    showFlutterNotification(message);
  }

  Future<void> setUpFlutterNotifications() async{
    if(isFlutterLocalNotificationsEnabled){
      return;
    }
    FirebaseMessaging.onMessage.listen((event) {
      print(event.notification?.title);
    });
    channel = const AndroidNotificationChannel('high importance channel', 'High Important Notifications',
      description: 'This channel is used for high important notification',
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation
    <AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true
    );
    isFlutterLocalNotificationsEnabled = true;
  }

  void showFlutterNotification(RemoteMessage message){
    RemoteNotification? notification = message.notification;
    AndroidNotification? androidNotification = message.notification?.android;
    if(notification != null && androidNotification != null && !kIsWeb){
      flutterLocalNotificationsPlugin.show(notification.hashCode, notification.title, notification.body,
          NotificationDetails(android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
          ))
      );
    }
  }

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


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
