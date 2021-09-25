// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:lanthu_bot/models/trade.dart';

class CardBox extends StatelessWidget {
  const CardBox(
      {required this.trade,
      required this.onTapDelete,
      required this.onTapEdit});
  final Trade trade;
  final Function onTapEdit, onTapDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      color: Theme.of(context).canvasColor,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        leading: trade.token != null ? Image.network('https://raw.githubusercontent.com/spothq/cryptocurrency-icons/master/128/color/${trade.token.toString().toLowerCase()}.png') : const Text(""),
        title: Text(trade.token ?? ""),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Container(
              height: 8,
            ),
            Text("Amount: " + trade.amount.toString()),
            Container(
              height: 8,
            ),
            Text("Limit: " + trade.limit.toString()),
            
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
