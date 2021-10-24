import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanthu_bot/models/log.dart';
import 'package:lanthu_bot/utils/constants.dart';

class LogDetails extends StatefulWidget {
  const LogDetails({Key? key, this.log}) : super(key: key);
  @override
  _LogDetailsState createState() => _LogDetailsState();
  final Log? log;
}

class _LogDetailsState extends State<LogDetails> {
  final String _widgetText = "Log Details";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_widgetText),
        actions: <Widget>[
          widget.log != null
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Navigator.pop(context);
                    deleteLog();
                  })
              : Container(),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.log!.message.toString()),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.log!.details.toString())),
              ],
            ),
          ),
        ],
      ),
    );
  }

  deleteLog() async {
    var logId = widget.log!.id.toString();
    var query = """mutation {
          removeLog(
            _id: "$logId",
          ) {
            message
            error
            result {
              _id
            }
          }
        }""";
    var dio = Dio();
    try {
      await dio.post("$apiUrl/graphql", data: {"query": query});
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pop(context);
      });
    } catch (e) {
      throw Exception('Failed to delete log');
    }
  }
}
