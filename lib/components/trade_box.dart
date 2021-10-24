// ignore_for_file: use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
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

    bool success = status == "SOLD";
    bool error = status == "ERROR";

    double visible = 1.0;
    if (success || error) {
      visible = 0.50;
    }

    return Opacity(
      opacity: visible,
      child: Material(
        elevation: 3.0,
        shape: status == "INIT"
            ? const RoundedRectangleShapeBorder(
                borderRadius:
                    DynamicBorderRadius.all(DynamicRadius.circular(Length(16))),
                borderSides: RectangleBorderSides.only(
                    left: DynamicBorderSide(
                  width: 6,
                  color: Color(0xFF5f27cd),
                )),
              )
            : status == "BOUGHT"
                ? const RoundedRectangleShapeBorder(
                    borderRadius: DynamicBorderRadius.all(
                        DynamicRadius.circular(Length(16))),
                    borderSides: RectangleBorderSides.only(
                        left: DynamicBorderSide(
                      width: 6,
                      color: Color(0xFF44bd32),
                    )),
                  )
                : const RoundedRectangleShapeBorder(
                    borderRadius: DynamicBorderRadius.all(
                        DynamicRadius.circular(Length(16))),
                    borderSides: RectangleBorderSides.only(
                        left: DynamicBorderSide(
                      width: 6,
                      color: Color(0xFFe77f67),
                    )),
                  ),
        child: ListTile(
          onTap: () {
            onTapEdit();
          },
          dense: false,
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
          leading: trade.token != null && trade.token?.slug != null
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
                            trade.token.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      )),
                  imageUrl:
                      'https://raw.githubusercontent.com/ErikThiart/cryptocurrency-icons/master/128/${trade.token?.slug!.toString().toLowerCase()}.png',
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
                        trade.token.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  )),
          title: Row(children: [
            Chip(
              label: Text(
                status,
                style: const TextStyle(fontSize: 10),
              ),
            ),
            Container(
              width: 10,
            ),
            Text(trade.token?.name ?? "",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600))
          ]),
          subtitle:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Amount: " + trade.amount!.toStringAsFixed(4)),
                Text("Buy Limit: " + trade.buyLimit!.toStringAsFixed(4)),
                Text("Sell Limit: " + trade.sellLimit!.toStringAsFixed(4)),
                Text("Stop Loss Limit: " +
                    trade.stopLossLimit!.toStringAsFixed(4)),
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
