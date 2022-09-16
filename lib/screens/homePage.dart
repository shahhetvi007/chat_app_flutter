import 'dart:io';

import 'package:chat_app/helper/auth_helper.dart';
import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'call/pickup/pickup_layout.dart';

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
    if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
    super.initState();
    checkForInitialMessage();
    snapshots = _firestore.collection('users').snapshots();
    FirebaseMessaging.instance.getToken().then((value) {
      print('token');
      print(value);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessgaingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setUpFlutterNotifications();
      print(message.notification?.title);
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text((message.notification?.title)!),
              content: Text((message.notification?.body)!),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text('OK')),
              ],
            );
          });
      showFlutterNotification(message);
    });
    // FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //   showFlutterNotification(event);
    // });
  }

  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      showFlutterNotification(initialMessage);
    }
  }

  Future<void> _firebaseMessgaingBackgroundHandler(
      RemoteMessage message) async {
    // await Firebase.initializeApp();
    await setUpFlutterNotifications();
    showFlutterNotification(message);
  }

  Future<void> setUpFlutterNotifications() async {
    if (isFlutterLocalNotificationsEnabled) {
      return;
    }

    channel = const AndroidNotificationChannel(
      'high importance channel',
      'High Important Notifications',
      sound: RawResourceAndroidNotificationSound('notification_sound'),
      description: 'This channel is used for high important notification',
      importance: Importance.high,
    );
    var initializeSettingsAndroid =
        const AndroidInitializationSettings('ic_notificationn');
    var initializeSettingsiOS = const IOSInitializationSettings();
    var initializeSettings = InitializationSettings(
        android: initializeSettingsAndroid, iOS: initializeSettingsiOS);
    flutterLocalNotificationsPlugin.initialize(initializeSettings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    isFlutterLocalNotificationsEnabled = true;
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? androidNotification = message.notification?.android;
    if (notification != null && androidNotification != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                icon: "@drawable/ic_notificationn",
                color: const Color(0xffffa07a),
                sound: const RawResourceAndroidNotificationSound(
                    'notification_sound')),
            iOS: const IOSNotificationDetails(
              presentBadge: true,
              presentAlert: true,
              presentSound: true,
            )),
      );
    }
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: StreamBuilder(
            stream: _firestore.collection('users').snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              return ListView.builder(
                  itemCount: (streamSnapshot.data != null)
                      ? streamSnapshot.data?.docs.length
                      : 0,
                  itemBuilder: (ctx, index) {
                    if (streamSnapshot.data?.docs[index]['id'] !=
                        AuthHelper().user.uid) {
                      return ListTile(
                        title: Text(streamSnapshot.data?.docs[index]['username']
                            as String),
                        onTap: () {
                          createConversation(
                              context, streamSnapshot.data?.docs[index]['id']);
                        },
                      );
                    } else {
                      return Container();
                    }
                  });
            }),
      ),
    );
  }

  void createConversation(BuildContext context, String contactId) {
    String uid = AuthHelper().user.uid;
    String convoId = HelperFunctions.getConvoId(uid, contactId);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) =>
            ChatScreen(uid: uid, contactId: contactId, convoId: convoId)));
  }
}
