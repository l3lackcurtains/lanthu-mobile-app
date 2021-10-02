class Token {
  final String? id;
  final String? address;
  final String? name;
  final String? slug;
  final String? swapWith;
  final int? decimal;

  const Token(
      {this.id,
      this.name,
      this.address,
      this.slug,
      this.swapWith,
      this.decimal});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'address': address,
      'slug': slug,
      'swapWith': swapWith,
      'decimal': decimal
    };
  }

  Token.fromMap(Map<String, dynamic> map)
      : id = map['_id'].toString(),
        name = map['name'],
        address = map['address'],
        slug = map['slug'],
        swapWith = map['swapWith'],
        decimal = map['decimal'];
}
