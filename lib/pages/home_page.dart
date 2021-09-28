import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lanthu_bot/pages/add_token.dart';
import 'package:lanthu_bot/pages/add_trade.dart';
import 'package:lanthu_bot/pages/logs.dart';
import 'package:lanthu_bot/pages/tokens.dart';
import 'package:lanthu_bot/pages/trades.dart';
import 'package:lanthu_bot/utils/constants.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    _startFirebase();
  }

  void _startFirebase() {
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) async {
      String token = value.toString();

      try {
        var client = http.Client();
        var url = Uri.parse('$apiUrl/devices/$token');
        var response = await client.get(url);
        if (response.statusCode == 200) {
          final resData = json.decode(response.body);
          final dynamic message = resData["message"];
          if (message == null) {
            var dio = Dio();
            await dio.post("$apiUrl/devices", data: {
              "token": value.toString(),
            });
          }
        }
      } catch (e) {
        throw Exception('Failed to add device');
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Notification"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: const Text("Dismiss"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lanthu'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        child: [const Trades(), const Tokens(), const Logs()]
            .elementAt(_selectedIndex),
      ),
      floatingActionButton: _selectedIndex < 2
          ? FloatingActionButton(
              onPressed: () {
                if (_selectedIndex == 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const AddTrade();
                  })).then((value) => setState(() {}));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const AddToken();
                  })).then((value) => setState(() {}));
                }
              },
              child: const Icon(Icons.add),
            )
          : Container(),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes),
              label: "Trading",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cable),
              label: "Tokens",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bug_report),
              label: "Logs",
            ),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.white,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed),
    );
  }
}
