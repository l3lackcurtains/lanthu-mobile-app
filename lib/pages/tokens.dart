import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lanthu_bot/components/token_box.dart';
import 'package:lanthu_bot/models/token.dart';
import 'package:lanthu_bot/pages/add_token.dart';
import 'package:http/http.dart' as http;
import 'package:lanthu_bot/utils/constants.dart';

class Tokens extends StatefulWidget {
  const Tokens({Key? key}) : super(key: key);
  @override
  _TokensState createState() => _TokensState();
}

class _TokensState extends State<Tokens> {
  List<dynamic> tokens = [];
  Future<List<dynamic>>? _futureTokens;

  @override
  void initState() {
    super.initState();
    _futureTokens = fetchFutureTokens();
  }

  Future<List<dynamic>> fetchFutureTokens() async {
    var client = http.Client();
    tokens = [];
    var query = """query {
                  getTokens(info:1) {
                    error
                    message
                    result {
                      _id
                      name
                      address
                      slug
                      base
                      decimal
                      info {
                        price
                        balance
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureTokens,
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
              final tokensList = snapshot.data as List<dynamic>;
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: tokensList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TokenBox(
                      token: tokensList[index],
                      onTapEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return AddToken(token: tokensList[index]);
                            },
                          ),
                        ).then((value) {
                          setState(() {
                            _futureTokens = fetchFutureTokens();
                          });
                        });
                      },
                    ),
                  );
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
