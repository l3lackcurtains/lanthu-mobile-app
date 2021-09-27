class Trade {
  final int? id;
  final String? type;
  final String? token;
  final double? amount;
  final double? limit;
  final bool? success;
  final bool? error;

  Trade(
      {this.id,
      this.type,
      this.token,
      this.amount,
      this.limit,
      this.success,
      this.error});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'token': token,
      'amount': amount,
      'limit': limit,
      'success': success,
      'error': error
    };
  }

  Trade.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        type = map['type'],
        token = map['token'],
        amount = double.parse(map['amount'].toString()),
        limit = double.parse(map['limit'].toString()),
        success = map['success'],
        error = map['error'];
}
