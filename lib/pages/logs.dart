import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lanthu_bot/components/log_box.dart';
import 'package:lanthu_bot/models/log.dart';
import 'package:lanthu_bot/pages/log_details.dart';
import 'package:http/http.dart' as http;
import 'package:lanthu_bot/utils/constants.dart';

class Logs extends StatefulWidget {
  const Logs({Key? key}) : super(key: key);
  @override
  _LogsState createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  List<dynamic> logs = [];
  Future<List<dynamic>>? _futureLogs;

  @override
  void initState() {
    super.initState();
    _futureLogs = fetchFutureLogs();
  }

  Future<List<dynamic>> fetchFutureLogs() async {
    var client = http.Client();
    logs = [];
    try {
      var url = Uri.parse('$apiUrl/logs');

      var response = await client.get(url);

      if (response.statusCode == 200) {
        final resData = json.decode(response.body);
        if (resData["message"] is! String) {
          final List<dynamic> message = resData["message"];
          logs.addAll(message.map((m) => Log.fromMap(m)).toList());
        }
      }
    } on SocketException {
      client.close();
      throw 'No Internet connection';
    }
    return logs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureLogs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: const LinearProgressIndicator(
                backgroundColor: Colors.black,
              ),
            );
          } else {
            if (snapshot.hasData) {
              final logsList = snapshot.data as List<dynamic>;
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: logsList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LogBox(
                      log: logsList[index],
                      onTapEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return LogDetails(log: logsList[index]);
                            },
                          ),
                        ).then((value) => setState(() {
                              _futureLogs = fetchFutureLogs();
                            }));
                      },
                    ),
                  );
                },
              );
            } else {
              return Container(
                color: Colors.white,
                child: Center(
                  child: Text(
                    'Something went wrong, try again.',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              );
            }
          }
        });
  }
}
