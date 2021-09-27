import 'package:flutter/material.dart';
import 'package:lanthu_bot/database/database.dart';

import 'pages/home_page.dart';

void main() async {
  await MongoDatabase.connect();
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
