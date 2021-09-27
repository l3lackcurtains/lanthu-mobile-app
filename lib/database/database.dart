import 'package:lanthu_bot/models/token.dart';
import 'package:lanthu_bot/models/trade.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../utils/constants.dart';

class MongoDatabase {
  static var db;

  static connect() async {
    db = await Db.create(mongoConnectionURL);
    await db.open();
  }

  static Future<List<Map<String, dynamic>>> getTrades() async {
    var trade = db.collection(tradeCollection);
    try {
      final trades = await trade.find().toList();
      return trades;
    } catch (e) {
      return [];
    }
  }

  static addTrade(Trade trade) async {
    var tradeDB = db.collection(tradeCollection);
    await tradeDB.insertMany([trade.toMap()]);
  }

  static updateTrade(Trade trade) async {
    var tradeDB = db.collection(tradeCollection);
    var updatedTrade = await tradeDB.findOne(where.id(trade.id as ObjectId));

    updatedTrade["address"] = trade.address ?? updatedTrade["address"];
    updatedTrade["type"] = trade.type ?? updatedTrade["type"];
    updatedTrade["token"] = trade.token ?? updatedTrade["token"];
    updatedTrade["amount"] = trade.amount ?? updatedTrade["amount"];
    updatedTrade["limit"] = trade.limit ?? updatedTrade["limit"];
    updatedTrade["success"] = trade.success ?? updatedTrade["success"];
    updatedTrade["error"] = trade.error ?? updatedTrade["error"];

    await tradeDB.save(updatedTrade);
  }

  static deleteTrade(Trade trade) async {
    var tradeDB = db.collection(tradeCollection);
    await tradeDB.remove(where.id(trade.id as ObjectId));
  }

  static Future<List<Token>> getTokens() async {
    var token = db.collection(tokenCollection);
    try {
      final mappedTokens = await token.find().toList();
      List<Token> tokens = [];
      for (var tkn in mappedTokens) {
        tokens.add(Token.fromMap(tkn));
      }
      return tokens;
    } catch (e) {
      return [];
    }
  }

  static Future<dynamic> getToken(String tokenName) async {
    var tokenDb = db.collection(tokenCollection);
    try {
      var token = await tokenDb.findOne(where.eq("name", tokenName));
      return token;
    } catch (e) {
      return Future;
    }
  }

  static addToken(Token token) async {
    var tokenDB = db.collection(tokenCollection);
    await tokenDB.insertMany([token.toMap()]);
  }

  static updateToken(Token token) async {
    var tokenDB = db.collection(tokenCollection);
    var updatedToken = await tokenDB.findOne({"_id": token.id});

    updatedToken["address"] = token.address;
    updatedToken["name"] = token.name;
    updatedToken["slug"] = token.slug;

    await tokenDB.save(updatedToken);
  }

  static deleteToken(Token token) async {
    var tokenDB = db.collection(tokenCollection);
    await tokenDB.remove(where.id(token.id as ObjectId));
  }
}
