import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lanthu_bot/components/card_box.dart';
import 'package:lanthu_bot/models/token.dart';
import 'package:lanthu_bot/models/trade.dart';
import 'package:lanthu_bot/pages/add_trade.dart';
import 'package:http/http.dart' as http;
import 'package:lanthu_bot/utils/constants.dart';

class Trades extends StatefulWidget {
  const Trades({Key? key}) : super(key: key);
  @override
  _TradesState createState() => _TradesState();
}

class _TradesState extends State<Trades> {
  List<dynamic> trades = [];
  Future<List<dynamic>>? _futureTrades;

  @override
  void initState() {
    super.initState();
    _futureTrades = fetchFutureTrades();
  }

  Future<List<dynamic>> fetchFutureTrades() async {
    var client = http.Client();
    try {
      var url = Uri.parse('$apiUrl/trades');

      var response = await client.get(url);

      if (response.statusCode == 200) {
        final resData = json.decode(response.body);
        final List<dynamic> message = resData["message"];

        trades.addAll(message.map((m) => Trade.fromMap(m)).toList());
      }
    } on SocketException {
      client.close();
      throw 'No Internet connection';
    }
    return trades;
  }

  Future<Token> getFutureToken(Trade trade) async {
    final newToken = await getToken(trade.token.toString());
    if (newToken != null) {
      Token token = Token.fromMap(newToken);
      return token;
    }
    return const Token();
  }

  Future<dynamic> getToken(String name) async {
    var client = http.Client();
    try {
      var url = Uri.parse('$apiUrl/tokens/$name');

      var response = await client.get(url);

      if (response.statusCode == 200) {
        final resData = json.decode(response.body);
        final dynamic message = resData["message"];
        return message;
      }
    } on SocketException {
      client.close();
      throw 'No Internet connection';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureTrades,
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
              final tradesList = snapshot.data as List<dynamic>;
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: tradesList.length,
                itemBuilder: (context, index) {
                  return Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CardBox(
                        trade: tradesList[index],
                        onTapEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return AddTrade(trade: tradesList[index]);
                            }),
                          ).then((value) => setState(() {}));
                        },
                        getFutureToken: getFutureToken(tradesList[index]),
                      ),
                    ),
                    index == tradesList.length - 1
                        ? Container(height: 60)
                        : Container()
                  ]);
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
