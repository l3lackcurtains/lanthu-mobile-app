// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:lanthu_bot/models/log.dart';

class LogBox extends StatelessWidget {
  const LogBox({required this.log, required this.onTapEdit});
  final Log log;
  final Function onTapEdit;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Theme.of(context).canvasColor,
      child: ListTile(
        onTap: () {
          onTapEdit();
        },
        dense: false,
        contentPadding: const EdgeInsets.fromLTRB(20, 0, 8, 16),
        title: Text(log.message.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 8,
            ),
            Text(log.details.toString().substring(0, 50)),
            Container(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
