import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanthu_bot/database/database.dart';
import 'package:lanthu_bot/models/token.dart';
import 'package:lanthu_bot/models/trade.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

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
  Token _selectedToken = const Token();
  int _typeIndex = 0;
  final List<String> _types = ["BUY", "SELL"];
  String _widgetText = "Add Trade";

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    List<Token> allTokens = await MongoDatabase.getTokens();
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
    final trade = Trade(
        id: mongo.ObjectId(),
        token: _selectedToken.name,
        address: _selectedToken.address,
        amount: double.parse(amountController.text),
        limit: double.parse(limitController.text),
        type: _types[_typeIndex],
        success: false,
        error: false);

    await MongoDatabase.addTrade(trade);
    Navigator.pop(context);
  }

  updateTrade() async {
    if (widget.trade != null) {
      final utrade = Trade(
          id: widget.trade!.id,
          token: _selectedToken.name,
          address: _selectedToken.address,
          amount: double.parse(amountController.text),
          limit: double.parse(limitController.text),
          type: _types[_typeIndex],
          success: false,
          error: false);
      await MongoDatabase.updateTrade(utrade);
    }
    Navigator.pop(context);
  }

  deleteTrade() async {
    if (widget.trade != null) {
      await MongoDatabase.deleteTrade(widget.trade as Trade);
      setState(() {});
    }
  }
}
