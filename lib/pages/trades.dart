import 'package:flutter/material.dart';
import 'package:lanthu_bot/components/card_box.dart';
import 'package:lanthu_bot/database/database.dart';
import 'package:lanthu_bot/models/token.dart';
import 'package:lanthu_bot/models/trade.dart';
import 'package:lanthu_bot/pages/add_trade.dart';

class Trades extends StatefulWidget {
  const Trades({Key? key}) : super(key: key);
  @override
  _TradesState createState() => _TradesState();
}

class _TradesState extends State<Trades> {
  @override
  void initState() {
    super.initState();
  }

  Future<Token> getFutureToken(Trade trade) async {
    var newToken = await MongoDatabase.getToken(trade.token.toString());
    if (newToken != null) {
      Token token = Token.fromMap(newToken);
      return token;
    }
    return const Token();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MongoDatabase.getTrades(),
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
              final trades = snapshot.data as dynamic;
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: trades.length,
                itemBuilder: (context, index) {
                  return Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CardBox(
                        trade: Trade.fromMap(trades[index]),
                        onTapEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return AddTrade(
                                  trade: Trade.fromMap(trades[index]));
                            }),
                          ).then((value) => setState(() {}));
                        },
                        getFutureToken:
                            getFutureToken(Trade.fromMap(trades[index])),
                      ),
                    ),
                    index == trades.length - 1
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

  deleteUser(Trade trade) async {
    await MongoDatabase.deleteTrade(trade);
    setState(() {});
  }
}
