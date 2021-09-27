import 'package:mongo_dart/mongo_dart.dart';

class Trade {
  final ObjectId? id;
  final String? address;
  final String? type;
  final String? token;
  final double? amount;
  final double? limit;
  final bool? success;
  final bool? error;

  Trade(
      {this.id,
      this.address,
      this.type,
      this.token,
      this.amount,
      this.limit,
      this.success,
      this.error});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'address': address,
      'type': type,
      'token': token,
      'amount': amount,
      'limit': limit,
      'success': success,
      'error': error
    };
  }

  Trade.fromMap(Map<String, dynamic> map)
      : id = map['_id'],
        address = map['address'],
        type = map['type'],
        token = map['token'],
        amount = map['amount'],
        limit = map['limit'],
        success = map['success'],
        error = map['error'];
}
