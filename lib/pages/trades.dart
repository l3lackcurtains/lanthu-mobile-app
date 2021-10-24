import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lanthu_bot/components/trade_box.dart';
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
    trades = [];

    var query = """query {
                  getTrades(token:1) {
                    error
                    message
                    result {
                      _id
                      amount
                      status
                      buyLimit
                      sellLimit
                      stopLossLimit
                      token {
                        name
                        address
                        slug
                      }
                    }
                  }
                }
              """;

    try {
      var uri = Uri.parse('$graphUrl/?query=$query');

      var response = await client.get(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final resData = json.decode(response.body);
        if (resData["data"]["getTrades"]["result"] != null) {
          final List<dynamic> message = resData["data"]["getTrades"]["result"];
          trades.addAll(message.map((m) => Trade.fromMap(m)).toList());
        }
      }
    } on SocketException {
      client.close();
      throw 'No Internet connection';
    }
    return trades;
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
                      child: TradeBox(
                        trade: tradesList[index],
                        onTapEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return AddTrade(trade: tradesList[index]);
                            }),
                          ).then((value) => setState(() {
                                _futureTrades = fetchFutureTrades();
                              }));
                        },
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
                color: Colors.black,
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
