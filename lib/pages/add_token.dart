import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanthu_bot/database/database.dart';
import 'package:lanthu_bot/models/token.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class ScreenArguments {
  final Token token;
  ScreenArguments(this.token);
}

class AddToken extends StatefulWidget {
  const AddToken({Key? key}) : super(key: key);
  @override
  _AddTokenState createState() => _AddTokenState();
}

class _AddTokenState extends State<AddToken> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments?;

    Token? token;
    if(args != null) {
      token = args.token;
    }

    var widgetText = 'Add Token';
    if (token != null) {
      nameController.text = token.name.toString();
      addressController.text = token.address.toString();
      widgetText = 'Update Token';
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
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
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
                  if (token != null) {
                    updateToken(token);
                  } else {
                    insertToken();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  insertToken() async {
    final token = Token(
      id: mongo.ObjectId(),
      name: nameController.text.toString(),
      address: addressController.text.toString(),
    );
    await MongoDatabase.addToken(token);
    Navigator.pop(context);
    setState(() {});
  }

  updateToken(Token token) async {
    final utoken = Token(
      id: token.id,
      name: nameController.text,
      address: addressController.text.toString(),
    );
    await MongoDatabase.updateToken(utoken);
    Navigator.pop(context);
  }
}
