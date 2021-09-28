class Log {
  final String? id;
  final String? message;
  final String? details;

  const Log({this.id, this.details, this.message});

  Map<String, dynamic> toMap() {
    return {'_id': id, 'details': details, 'message': message};
  }

  Log.fromMap(Map<String, dynamic> map)
      : id = map['_id'].toString(),
        details = map['details'],
        message = map['message'];
}
