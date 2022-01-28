class Token {
  Token({
    required this.id,
    required this.date,
    required this.token,
    this.deviceDetail,
  });

  String id;
  DateTime date;
  String token;
  String? deviceDetail;
}
