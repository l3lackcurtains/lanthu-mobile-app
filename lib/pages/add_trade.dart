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
  TextEditingController limitController = TextEditingController();

  List<Token> tokens = [];
  Token _selectedToken = const Token(name: "BNB");
  int _typeIndex = 0;
  final List<String> _types = ["BUY", "SELL"];
  String _widgetText = "Add Trade";

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<List<Token>> getTokens() async {
    var client = http.Client();
    try {
      var url = Uri.parse('$apiUrl/tokens');

      var response = await client.get(url);

      if (response.statusCode == 200) {
        final resData = json.decode(response.body);
        final List<dynamic> message = resData["message"];

        tokens.addAll(message.map((m) => Token.fromMap(m)).toList());
      }
    } on SocketException {
      client.close();
      throw 'No Internet connection';
    }
    return tokens;
  }

  Future<TokenInfo> getTokenInfo(String token) async {
    var client = http.Client();
    TokenInfo tokenInfo = const TokenInfo();

    try {
      var url = Uri.parse('$apiUrl/tokeninfo/${token.toString()}');

      var response = await client.get(url);

      if (response.statusCode == 200) {
        final resData = json.decode(response.body);
        final Map<String, dynamic> message = resData["message"];

        tokenInfo = TokenInfo.fromMap(message);
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
      limitController.text = trade.limit.toString();
      final index = tokens.indexWhere(
          (element) => element.name == trade.token.toString().toUpperCase());
      setState(() {
        if (index >= 0 && index < tokens.length) {
          _selectedToken = tokens[index];
        }
        if (trade.type == _types[0]) _typeIndex = 0;
        if (trade.type == _types[1]) _typeIndex = 1;
      });
      _widgetText = 'Update Trade';
    }
  }

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
    limitController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_widgetText),
        actions: <Widget>[
          widget.trade != null
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Navigator.pop(context);
                    deleteTrade();
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ActionChip(
                          backgroundColor: _typeIndex == 0
                              ? Colors.green.shade500
                              : Colors.grey.shade700,
                          label: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(32, 16, 32, 16),
                              child: const Text('BUY')),
                          onPressed: () {
                            setState(() {
                              _typeIndex = 0;
                            });
                          }),
                      Container(
                        width: 32,
                      ),
                      ActionChip(
                          backgroundColor: _typeIndex == 1
                              ? Colors.green.shade500
                              : Colors.grey.shade700,
                          label: Container(
                            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                            child: const Text('SELL'),
                          ),
                          onPressed: () {
                            setState(() {
                              _typeIndex = 1;
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
                        child: Text(tkn.name!.toUpperCase()),
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
                    controller: limitController,
                    decoration: const InputDecoration(labelText: 'Limit'),
                  ),
                ),
                Container(height: 16),
                FutureBuilder(
                    future: getTokenInfo(_selectedToken.name.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(height: 150);
                      } else {
                        if (snapshot.hasData) {
                          final tokenInfo = snapshot.data as TokenInfo;
                          return Material(
                            child: Container(
                              height: 150,
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
            updateTrade();
          } else {
            insertTrade();
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  insertTrade() async {
    var dio = Dio();

    try {
      await dio.post("$apiUrl/trades", data: {
        "token": _selectedToken.name,
        "amount": double.parse(amountController.text),
        "limit": double.parse(limitController.text),
        "type": _types[_typeIndex],
        "success": false,
        "error": false
      });
      Navigator.pop(context);
    } catch (e) {
      throw Exception('Failed to add trade');
    }
  }

  updateTrade() async {
    var dio = Dio();
    var tradeId = widget.trade!.id;
    try {
      await dio.put("$apiUrl/trades/$tradeId", data: {
        "token": _selectedToken.name,
        "amount": double.parse(amountController.text),
        "limit": double.parse(limitController.text),
        "type": _types[_typeIndex],
        "success": false,
        "error": false
      });
      Navigator.pop(context);
    } catch (e) {
      throw Exception('Failed to update trade');
    }
  }

  deleteTrade() async {
    var dio = Dio();
    var tradeId = widget.trade!.id;
    try {
      await dio.delete("$apiUrl/trades/$tradeId");
      Navigator.pop(context);
    } catch (e) {
      throw Exception('Failed to delete trade');
    }
  }
}
