import 'package:mongo_dart/mongo_dart.dart';

class Token {
  final ObjectId? id;
  final String? address;
  final String? name;

  const Token({this.id, this.name, this.address});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'address': address,
    };
  }

  Token.fromMap(Map<String, dynamic> map)
      : id = map['_id'],
        name = map['name'],
        address = map['address'];
}
