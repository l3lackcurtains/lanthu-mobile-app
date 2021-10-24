// ignore_for_file: use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lanthu_bot/models/token.dart';

class TokenBox extends StatelessWidget {
  const TokenBox({
    required this.token,
    required this.onTapEdit,
  });
  final Token token;
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
        leading: token.slug != null
            ? CachedNetworkImage(
                errorWidget: (context, url, error) => Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          token.name.toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    )),
                imageUrl:
                    'https://raw.githubusercontent.com/ErikThiart/cryptocurrency-icons/master/128/${token.slug!.toString().toLowerCase()}.png',
                width: 56,
              )
            : Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                    color: Colors.black, shape: BoxShape.circle),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      token.name.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                )),
        title: Text(token.name.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 8,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              height: 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  token.info?.price != null
                      ? Text(
                          "Price: ${double.parse(token.info?.price.toString() ?? "0")} USD")
                      : const Text("N/A"),
                  token.info?.balance != null
                      ? Text(
                          "Balance: ${double.parse(token.info?.balance.toString() ?? "0")} ${token.name}")
                      : const Text(""),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
