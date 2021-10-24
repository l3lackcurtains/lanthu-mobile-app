// ignore_for_file: use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanthu_bot/models/trade.dart';
import 'package:morphable_shape/morphable_shape.dart';

class TradeBox extends StatelessWidget {
  const TradeBox({required this.trade, required this.onTapEdit});
  final Trade trade;
  final Function onTapEdit;

  @override
  Widget build(BuildContext context) {
    String status = trade.status.toString();

    bool success = status == "COMPLETED";
    bool error = status == "ERROR";

    double visible = 1.0;
    if (success || error) {
      visible = 0.50;
    }

    var statusColor = const Color(0xFF5f27cd);

    if (status == "SELLING") {
      statusColor = const Color(0xFF6ab04c);
    } else if (status == "COMPLETED") {
      statusColor = const Color(0xFFff793f);
    } else if (status == "ERROR") {
      statusColor = const Color(0xFFe74c3c);
    }

    return Opacity(
      opacity: visible,
      child: Card(
        shape: RoundedRectangleShapeBorder(
          borderRadius:
              const DynamicBorderRadius.all(DynamicRadius.circular(Length(16))),
          borderSides: RectangleBorderSides.only(
              left: DynamicBorderSide(
            width: 6,
            color: statusColor,
          )),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                onTap: () {
                  onTapEdit();
                },
                dense: false,
                contentPadding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
                leading: trade.token != null && trade.token?.slug != null
                    ? CachedNetworkImage(
                        errorWidget: (context, url, error) => Container(
                            width: 45,
                            height: 45,
                            decoration: const BoxDecoration(
                                color: Colors.black, shape: BoxShape.circle),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  trade.token.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            )),
                        imageUrl:
                            'https://raw.githubusercontent.com/ErikThiart/cryptocurrency-icons/master/128/${trade.token?.slug!.toString().toLowerCase()}.png',
                        width: 45,
                      )
                    : Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                            color: Colors.black, shape: BoxShape.circle),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              trade.token.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        )),
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(trade.token?.name ?? "",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                      ),
                      Text(
                        trade.amount!.toStringAsFixed(6) +
                            " " +
                            trade.token!.name.toString(),
                        style: TextStyle(
                            fontSize: 13, color: Colors.white.withOpacity(0.7)),
                      ),
                    ]),
                subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        backgroundColor: statusColor,
                        label: Text(
                          status,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            success
                                ? Image.asset("assets/success.png", width: 28)
                                : Container(),
                            error
                                ? Image.asset("assets/error.png", width: 28)
                                : Container(),
                          ],
                        ),
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "BUY: " + trade.buyLimit!.toStringAsFixed(6),
                      style: TextStyle(
                          fontSize: 12, color: Colors.white.withOpacity(0.7)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "SELL: " + trade.sellLimit!.toStringAsFixed(6),
                      style: TextStyle(
                          fontSize: 12, color: Colors.white.withOpacity(0.7)),
                    ),
                    const SizedBox(width: 8),
                    Text("STOP: " + trade.stopLossLimit!.toStringAsFixed(6),
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7))),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
