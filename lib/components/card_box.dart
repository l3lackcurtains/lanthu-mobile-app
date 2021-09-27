// ignore_for_file: use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lanthu_bot/models/token.dart';
import 'package:lanthu_bot/models/trade.dart';
import 'package:morphable_shape/morphable_shape.dart';

class CardBox extends StatelessWidget {
  const CardBox(
      {required this.trade,
      required this.onTapEdit,
      required this.getFutureToken});
  final Trade trade;
  final Function onTapEdit;
  final Future<Token> getFutureToken;

  @override
  Widget build(BuildContext context) {
    String type = trade.type.toString();

    bool success = trade.success ?? false;
    bool error = trade.error ?? false;

    double visible = 1.0;
    if (success || error) {
      visible = 0.50;
    }

    return Opacity(
      opacity: visible,
      child: Material(
        elevation: 3.0,
        shape: type == "BUY"
            ? const RoundedRectangleShapeBorder(
                borderRadius:
                    DynamicBorderRadius.all(DynamicRadius.circular(Length(16))),
                borderSides: RectangleBorderSides.only(
                    left: DynamicBorderSide(
                  width: 6,
                  color: Color(0xFF27ae60),
                )),
              )
            : const RoundedRectangleShapeBorder(
                borderRadius:
                    DynamicBorderRadius.all(DynamicRadius.circular(Length(16))),
                borderSides: RectangleBorderSides.only(
                    left: DynamicBorderSide(
                  width: 6,
                  color: Color(0xFF5352ed),
                )),
              ),
        child: ListTile(
          onTap: () {
            onTapEdit();
          },
          dense: false,
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
          leading: FutureBuilder<Token>(
              future: getFutureToken,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Token token = snapshot.data as Token;
                  return token.slug != null
                      ? CachedNetworkImage(
                          errorWidget: (context, url, error) => Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                  color: Colors.black, shape: BoxShape.circle),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    trade.token.toString(),
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
                            children: [
                              Text(
                                trade.token.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ));
                }
                return Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          trade.token.toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ));
              }),
          title: Row(children: [
            Chip(
              label: Text(
                trade.type.toString(),
                style: const TextStyle(fontSize: 10),
              ),
            ),
            Container(
              width: 10,
            ),
            Text(trade.token.toString(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600))
          ]),
          subtitle:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Amount: " + trade.amount!.toStringAsFixed(4)),
                Container(
                  height: 8,
                ),
                Text("Limit: " + trade.limit!.toStringAsFixed(4)),
                Container(
                  height: 8,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                success
                    ? Image.asset("assets/success.png", width: 32)
                    : Container(),
                error
                    ? Image.asset("assets/error.png", width: 32)
                    : Container(),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
