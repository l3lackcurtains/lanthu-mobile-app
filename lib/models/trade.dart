import 'package:lanthu_bot/models/token.dart';

class Trade {
  final String? id;
  final String? status;
  final Token? token;
  final String? slug;
  final String? tokenId;
  final double? amount;
  final double? buyLimit;
  final double? sellLimit;
  final double? stopLossLimit;

  Trade({
    this.id,
    this.status,
    this.token,
    this.slug,
    this.tokenId,
    this.amount,
    this.buyLimit,
    this.sellLimit,
    this.stopLossLimit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'slug': slug,
      'token': token,
      'tokenId': tokenId,
      'amount': amount,
      'buyLimit': buyLimit,
      'sellLimit': sellLimit,
      'stopLossLimit': stopLossLimit,
    };
  }

  Trade.fromMap(Map<String, dynamic> map)
      : id = map['_id'].toString(),
        status = map['status'],
        token = Token.fromMap(map['token']),
        slug = map['token']['slug'],
        tokenId = map['tokenId'],
        amount = double.parse(map['amount'].toString()),
        buyLimit = map['buyLimit'] != null
            ? double.parse(map['buyLimit'].toString())
            : 0,
        sellLimit = map['sellLimit'] != null
            ? double.parse(map['sellLimit'].toString())
            : 0,
        stopLossLimit = map['stopLossLimit'] != null
            ? double.parse(map['stopLossLimit'].toString())
            : 0;
}
