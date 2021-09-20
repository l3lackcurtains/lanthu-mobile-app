// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:lanthu_bot/models/token.dart';

class TokenBox extends StatelessWidget {
  const TokenBox(
      {required this.token,
      required this.onTapDelete,
      required this.onTapEdit});
  final Token token;
  final Function onTapEdit, onTapDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        leading: token.name != null ? Image.network('https://raw.githubusercontent.com/spothq/cryptocurrency-icons/master/128/color/${token.name.toString().toLowerCase()}.png') : const Text(""),
        title: Text(token.name ?? ""),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Container(
              height: 8,
            ),
            Text(token.address.toString()),
            
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              child: const Icon(Icons.edit),
              onTap: () {
                onTapEdit();
              },
            ),
            GestureDetector(
              child: const Icon(Icons.delete),
              onTap: () {
                onTapDelete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
