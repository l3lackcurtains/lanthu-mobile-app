import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanthu_bot/database/database.dart';
import 'package:lanthu_bot/models/token.dart';
import 'package:lanthu_bot/models/trade.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class ScreenArguments {
  final Trade trade;
  ScreenArguments(this.trade);
}

class AddTrade extends StatefulWidget {
  const AddTrade({Key? key}) : super(key: key);
  @override
  _AddTradeState createState() => _AddTradeState();
}

class _AddTradeState extends State<AddTrade> {
  TextEditingController amountController = TextEditingController();
  TextEditingController limitController = TextEditingController();

  List<Token> tokens = [];
  Token _selectedToken = const Token();

  @override
  void initState() {
    super.initState();
    getAllTokens();
  }

  void getAllTokens() async {
    List<Token> allTokens = await MongoDatabase.getTokens();
    setState(() {
      tokens = allTokens;
      _selectedToken = tokens[0];
    });
  }

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
    limitController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments?;

    Trade? trade;
    if (args != null) {
      trade = args.trade;
    }

    var widgetText = 'Add Trade';
    if (trade != null) {
      amountController.text = trade.amount.toString();
      limitController.text = trade.limit.toString();

      final index = tokens.indexWhere((element) =>
        element.name == trade!.token.toString().toUpperCase());

      setState(() {
        if(index >= 0 && index < tokens.length) {
           _selectedToken = tokens[index];
        }
       
      });

      widgetText = 'Update Trade';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widgetText),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
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
                    decoration: const InputDecoration(labelText: 'Amount'),
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
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
              child: ElevatedButton(
                child: Text(widgetText),
                onPressed: () {
                  if (trade != null) {
                    updateTrade(trade);
                  } else {
                    insertTrade();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  insertTrade() async {
    final trade = Trade(
      id: mongo.ObjectId(),
      token: _selectedToken.name,
      address: _selectedToken.address,
      amount: double.parse(amountController.text),
      limit: double.parse(limitController.text),
    );
    await MongoDatabase.addTrade(trade);
    Navigator.pop(context);
  }

  updateTrade(Trade trade) async {
    final utrade = Trade(
      id: trade.id,
      token: _selectedToken.name,
      address: _selectedToken.address,
      amount: double.parse(amountController.text),
      limit: double.parse(limitController.text),
    );
    await MongoDatabase.updateTrade(utrade);
    Navigator.pop(context);
  }
}
