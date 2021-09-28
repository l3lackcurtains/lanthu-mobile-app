import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'pages/home_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

AndroidNotificationChannel? channel;

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lanthu Bot',
      theme: ThemeData(
        primaryColor: Colors.black,
        brightness: Brightness.dark,
        primaryColorLight: Colors.white,
        primaryColorDark: Colors.black,
        canvasColor: const Color(0xFF353b48),
        backgroundColor: Colors.black,
        scaffoldBackgroundColor: const Color(0xFF333333),
      ),
      home: const HomePage(),
    );
  }
}
