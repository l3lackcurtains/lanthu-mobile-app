import 'package:lanthu_bot/models/token_info.dart';

class Token {
  final String? id;
  final String? address;
  final String? name;
  final String? slug;
  final String? base;
  final int? decimal;
  final TokenInfo? info;

  const Token(
      {this.id,
      this.name,
      this.address,
      this.slug,
      this.base,
      this.decimal,
      this.info});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'address': address,
      'slug': slug,
      'base': base,
      'decimal': decimal,
      'info': info
    };
  }

  Token.fromMap(Map<String, dynamic> map)
      : id = map['_id'].toString(),
        name = map['name'],
        info = map['info'] != null ? TokenInfo.fromMap(map['info']) : null,
        address = map['address'],
        slug = map['slug'],
        base = map['base'],
        decimal = map['decimal'];
}
