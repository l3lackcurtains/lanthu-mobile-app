import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanthu_bot/models/token.dart';
import 'package:lanthu_bot/utils/constants.dart';

class ScreenArguments {
  final Token token;
  ScreenArguments(this.token);
}

class AddToken extends StatefulWidget {
  const AddToken({Key? key, this.token}) : super(key: key);
  @override
  _AddTokenState createState() => _AddTokenState();

  final Token? token;
}

class _AddTokenState extends State<AddToken> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController slugController = TextEditingController();

  String _selectSwapWith = "BNB";

  String _widgetText = "Add Token";

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    if (widget.token != null) {
      Token token = widget.token as Token;
      nameController.text = token.name.toString();
      addressController.text = token.address.toString();
      _selectSwapWith = token.swapWith.toString();
      slugController.text = token.slug.toString();
      _widgetText = 'Update Trade';
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    addressController.dispose();
    slugController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_widgetText),
        actions: <Widget>[
          widget.token != null
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Navigator.pop(context);
                    deleteToken();
                  })
              : Container(),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(8, 16, 8, 4),
                  child: Text("Swap with"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: _selectSwapWith,
                    icon: const Icon(Icons.arrow_downward),
                    itemHeight: 60,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectSwapWith = newValue!;
                      });
                    },
                    items: <String>[
                      'BNB',
                      'BUSD',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: slugController,
                    decoration: const InputDecoration(labelText: 'Slug'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.token != null) {
            updateToken();
          } else {
            insertToken();
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  insertToken() async {
    var dio = Dio();

    try {
      await dio.post("$apiUrl/tokens", data: {
        "name": nameController.text.toString(),
        "slug": slugController.text.toString(),
        "address": addressController.text.toString(),
        "swapWith": _selectSwapWith,
      });
      Navigator.pop(context);
    } catch (e) {
      throw Exception('Failed to add token');
    }
  }

  updateToken() async {
    var dio = Dio();
    var tokenName = widget.token!.name;
    try {
      await dio.put("$apiUrl/tokens/$tokenName", data: {
        "name": nameController.text,
        "slug": slugController.text.toString(),
        "address": addressController.text.toString(),
        "swapWith": _selectSwapWith,
      });
      Navigator.pop(context);
    } catch (e) {
      throw Exception('Failed to update token.');
    }
  }

  deleteToken() async {
    var dio = Dio();
    var tokenName = widget.token!.name;
    try {
      await dio.delete("$apiUrl/tokens/$tokenName");
      Navigator.pop(context);
    } catch (e) {
      throw Exception('Failed to delete token');
    }
  }
}
