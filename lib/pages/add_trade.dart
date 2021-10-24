import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanthu_bot/models/token.dart';
import 'package:lanthu_bot/models/token_info.dart';
import 'package:lanthu_bot/models/trade.dart';
import 'package:http/http.dart' as http;
import 'package:lanthu_bot/utils/constants.dart';

class AddTrade extends StatefulWidget {
  const AddTrade({Key? key, this.trade}) : super(key: key);
  @override
  _AddTradeState createState() => _AddTradeState();

  final Trade? trade;
}

class _AddTradeState extends State<AddTrade> {
  TextEditingController amountController = TextEditingController();
  TextEditingController buyLimitController = TextEditingController();
  TextEditingController sellLimitController = TextEditingController();
  TextEditingController stopLossLimitController = TextEditingController();

  List<Token> tokens = [];
  Token _selectedToken = const Token(name: "BNB");
  int _typeIndex = 0;
  final List<String> _status = ["BUYING", "SELLING", "COMPLETED", "ERROR"];
  String _widgetText = "Add Trade";

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<List<Token>> getTokens() async {
    var client = http.Client();
    var query = """query {
                  getTokens{
                    error
                    message
                    result {
                      _id
                      name
                      address
                      base
                    }
                  }
                }
              """;

    try {
      var uri = Uri.parse('$apiUrl/?query=$query');

      var response = await client.get(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final resData = json.decode(response.body);
        if (resData["data"]["getTokens"]["result"] != null) {
          final List<dynamic> message = resData["data"]["getTokens"]["result"];
          tokens.addAll(message.map((m) => Token.fromMap(m)).toList());
        }
      }
    } on SocketException {
      client.close();
      throw 'No Internet connection';
    }
    return tokens;
  }

  Future<TokenInfo> getTokenInfo(String tokenId) async {
    var client = http.Client();
    TokenInfo tokenInfo = const TokenInfo();

    var query = """query {
                  getTokenInfo(tokenId: "$tokenId"){
                    error
                    message
                    result {
                      balance
                      busdBalance
                      bnbPrice
                      price
                      bnbBalance
                      token
                    }
                  }
                }
              """;

    try {
      var uri = Uri.parse('$apiUrl/?query=$query');
      var response = await client.get(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final resData = json.decode(response.body);
        if (resData["data"]["getTokenInfo"]["result"] != null) {
          final Map<String, dynamic> message =
              resData["data"]["getTokenInfo"]["result"];
          tokenInfo = TokenInfo.fromMap(message);
        }
      }
    } on SocketException {
      client.close();
      throw 'No Internet connection';
    }

    return tokenInfo;
  }

  void initializeData() async {
    List<Token> allTokens = await getTokens();
    setState(() {
      tokens = allTokens;
      _selectedToken = tokens[0];
    });

    if (widget.trade != null) {
      Trade trade = widget.trade as Trade;
      amountController.text = trade.amount.toString();
      buyLimitController.text = trade.buyLimit.toString();
      sellLimitController.text = trade.sellLimit.toString();
      stopLossLimitController.text = trade.stopLossLimit.toString();

      final index = tokens.indexWhere((element) =>
          element.name == trade.token?.name.toString().toUpperCase());
      setState(() {
        if (index >= 0 && index < tokens.length) {
          _selectedToken = tokens[index];
        }
        for (var stat = 0; stat < _status.length; stat++) {
          if (trade.status == _status[stat]) _typeIndex = stat;
        }
      });
      _widgetText = 'Update Trade';
    }
  }

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
    buyLimitController.dispose();
    sellLimitController.dispose();
    stopLossLimitController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AlertDialog insertDialog = AlertDialog(
      title: const Text('Add new Trade'),
      contentPadding: const EdgeInsets.all(24),
      content: const Text("Are you sure, you want to add this token?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Nope'),
        ),
        TextButton(
          onPressed: () => insertTrade(),
          child: const Text('Sure'),
        ),
      ],
    );

    final AlertDialog updateDialog = AlertDialog(
      title: const Text('Upate Trade'),
      contentPadding: const EdgeInsets.all(24),
      content: const Text("Are you sure, you want to update this trade?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Nope'),
        ),
        TextButton(
          onPressed: () => updateTrade(),
          child: const Text('Sure'),
        ),
      ],
    );

    final AlertDialog deleteDialog = AlertDialog(
      title: const Text('Delete Trade'),
      contentPadding: const EdgeInsets.all(24),
      content: const Text("Are you sure, you want to delete this trade?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Nope'),
        ),
        TextButton(
          onPressed: () => deleteTrade(),
          child: const Text('Sure'),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_widgetText),
        actions: <Widget>[
          widget.trade != null
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog<void>(
                        context: context, builder: (context) => deleteDialog);
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
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActionChip(
                          backgroundColor: _typeIndex == 0
                              ? const Color(0xFF5f27cd)
                              : Colors.grey.shade700,
                          label: Container(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: const Text('INIT')),
                          onPressed: () {
                            setState(() {
                              _typeIndex = 0;
                            });
                          }),
                      ActionChip(
                          backgroundColor: _typeIndex == 1
                              ? const Color(0xFF5f27cd)
                              : Colors.grey.shade700,
                          label: Container(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: const Text('BOUGHT'),
                          ),
                          onPressed: () {
                            setState(() {
                              _typeIndex = 1;
                            });
                          }),
                      ActionChip(
                          backgroundColor: _typeIndex == 2
                              ? const Color(0xFF44bd32)
                              : Colors.grey.shade700,
                          label: Container(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: const Text('SOLD'),
                          ),
                          onPressed: () {
                            setState(() {
                              _typeIndex = 2;
                            });
                          }),
                      ActionChip(
                          backgroundColor: _typeIndex == 3
                              ? Colors.red.shade500
                              : Colors.grey.shade700,
                          label: Container(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: const Text('ERROR'),
                          ),
                          onPressed: () {
                            setState(() {
                              _typeIndex = 3;
                            });
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButton<Token>(
                    value: _selectedToken,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 18,
                    itemHeight: 60,
                    isExpanded: true,
                    onChanged: (Token? newValue) {
                      setState(() {
                        _selectedToken = newValue!;
                      });
                    },
                    items: tokens.map((tkn) {
                      return DropdownMenuItem<Token>(
                        value: tkn,
                        child: Text("${tkn.name!.toUpperCase()} (${tkn.base})"),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: buyLimitController,
                    decoration: const InputDecoration(labelText: 'Buy Limit'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: sellLimitController,
                    decoration: const InputDecoration(labelText: 'Sell Limit'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: stopLossLimitController,
                    decoration:
                        const InputDecoration(labelText: 'Stop Loss Limit'),
                  ),
                ),
                Container(height: 16),
                FutureBuilder(
                    future: getTokenInfo(_selectedToken.id.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(height: 150);
                      } else {
                        if (snapshot.hasData) {
                          final tokenInfo = snapshot.data as TokenInfo;
                          return Material(
                            child: Container(
                              height: 180,
                              padding: const EdgeInsets.all(16.0),
                              child: ListTile(
                                title: Text(
                                    "${tokenInfo.token} (${tokenInfo.price.toString()})"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 8,
                                    ),
                                    Text(
                                        "${tokenInfo.balance} ${tokenInfo.token}"),
                                    Container(
                                      height: 8,
                                    ),
                                    Text("${tokenInfo.bnbBalance} BNB"),
                                    Container(
                                      height: 8,
                                    ),
                                    Text("${tokenInfo.busdBalance} BUSD"),
                                    Container(
                                      height: 8,
                                    ),
                                    TextButton(
                                      child: const Text('INSERT MAX'),
                                      onPressed: () {
                                        amountController.text =
                                            tokenInfo.balance.toString();
                                      },
                                    ),
                                    Container(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        return Container(
                          color: Colors.black,
                          child: const LinearProgressIndicator(
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.trade != null) {
            showDialog<void>(
                context: context, builder: (context) => updateDialog);
          } else {
            showDialog<void>(
                context: context, builder: (context) => insertDialog);
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  insertTrade() async {
    var amount = double.parse(amountController.text);
    var buyLimit = double.parse(buyLimitController.text);
    var sellLimit = double.parse(sellLimitController.text);
    var stopLossLimit = double.parse(stopLossLimitController.text);
    var status = _status[_typeIndex];
    var tokenId = _selectedToken.id;

    var query = """mutation {
          addTrade(
            amount: $amount,
            buyLimit: $buyLimit,
            sellLimit: $sellLimit,
            stopLossLimit: $stopLossLimit,
            status: "$status",
            tokenId: "$tokenId"
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
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      throw Exception('Failed to add trade');
    }
  }

  updateTrade() async {
    var tradeId = widget.trade!.id;
    var amount = double.parse(amountController.text);
    var buyLimit = double.parse(buyLimitController.text);
    var sellLimit = double.parse(sellLimitController.text);
    var stopLossLimit = double.parse(stopLossLimitController.text);
    var status = _status[_typeIndex];
    var tokenId = _selectedToken.id;

    var query = """mutation {
          updateTrade(
            _id: "$tradeId",
            amount: $amount,
            buyLimit: $buyLimit,
            sellLimit: $sellLimit,
            stopLossLimit: $stopLossLimit,
            status: "$status",
            tokenId: "$tokenId"
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
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      throw Exception('Failed to update trade');
    }
  }

  deleteTrade() async {
    var tradeId = widget.trade!.id;
    var query = """mutation {
          removeTrade(
            _id: "$tradeId",
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
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      throw Exception('Failed to delete trade');
    }
  }
}
