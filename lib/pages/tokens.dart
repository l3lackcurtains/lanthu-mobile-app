import 'package:flutter/material.dart';
import 'package:lanthu_bot/components/token_box.dart';
import 'package:lanthu_bot/database/database.dart';
import 'package:lanthu_bot/pages/add_token.dart';

class Tokens extends StatefulWidget {
  const Tokens({Key? key}) : super(key: key);
  @override
  _TokensState createState() => _TokensState();
}

class _TokensState extends State<Tokens> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MongoDatabase.getTokens(),
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
              final tokens = snapshot.data as dynamic;
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: tokens.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TokenBox(
                      token: tokens[index],
                      onTapEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return AddToken(token: tokens[index]);
                            },
                          ),
                        ).then((value) => setState(() {}));
                      },
                    ),
                  );
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
