class TokenInfo {
  final String? token;
  final String? address;
  final double? balance;
  final double? bnbBalance;
  final double? busdBalance;
  final double? price;

  const TokenInfo(
      {this.token,
      this.balance,
      this.address,
      this.bnbBalance,
      this.busdBalance,
      this.price});

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'balance': balance,
      'address': address,
      'bnbBalance': bnbBalance,
      'busdBalance': busdBalance,
      'price': price
    };
  }

  TokenInfo.fromMap(Map<String, dynamic> map)
      : token = map['token'],
        balance = map['balance'] != null
            ? double.parse(map['balance'].toString())
            : 0,
        price =
            map['price'] != null ? double.parse(map['price'].toString()) : 0,
        address = map['address'],
        bnbBalance = map['bnbBalance'] != null
            ? double.parse(map['bnbBalance'].toString())
            : 0,
        busdBalance = map['busdBalance'] != null
            ? double.parse(map['busdBalance'].toString())
            : 0;
}
