class TokenInfo {
  final String? token;
  final String? address;
  final double? balance;
  final double? busdBalance;
  final double? price;

  const TokenInfo(
      {this.token, this.balance, this.address, this.busdBalance, this.price});

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'balance': balance,
      'address': address,
      'busdBalance': busdBalance,
      'price': price
    };
  }

  TokenInfo.fromMap(Map<String, dynamic> map)
      : token = map['token'],
        balance = double.parse(map['balance'].toString()),
        price = double.parse(map['price'].toString()),
        address = map['address'],
        busdBalance = double.parse(map['busdBalance'].toString());
}
