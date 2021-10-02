import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lanthu_bot/components/token_box.dart';
import 'package:lanthu_bot/models/token.dart';
import 'package:lanthu_bot/models/token_info.dart';
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
    try {
      var url = Uri.parse('$apiUrl/tokens');

      var response = await client.get(url);

      if (response.statusCode == 200) {
        final resData = json.decode(response.body);
        if (resData["message"] is! String) {
          final List<dynamic> message = resData["message"];

          tokens.addAll(message.map((m) => Token.fromMap(m)).toList());
        }
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
        if (resData["message"] is! String) {
          final Map<String, dynamic> message = resData["message"];
          tokenInfo = TokenInfo.fromMap(message);
        }
      }
    } on SocketException {
      client.close();
      throw 'No Internet connection';
    }

    return tokenInfo;
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
                      getTokenInfo: getTokenInfo(tokensList[index].name),
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
