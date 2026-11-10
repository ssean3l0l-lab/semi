class DueModel {
  final String stId; // 납부자 학번 (pk, fk, not null)
  final DateTime paidAt; // 납부일시 (pk, not null)
  final String clubId; // 동아리 ID (fk, not null)
  final int amount; // 금액 (not null)

  DueModel({
    required this.stId,
    required this.paidAt,
    required this.clubId,
    required this.amount,
  });

  // 서버(백엔드)에서 받아온 JSON 데이터를 Dart 객체로 변환
  factory DueModel.fromJson(Map<String, dynamic> json) {
    return DueModel(
      stId: json['st_id'] as String,
      paidAt: DateTime.parse(json['paid_at'] as String),
      clubId: json['club_id'] as String,
      amount: json['amount'] as int,
    );
  }

  // Dart 객체를 서버로 보낼 JSON 데이터 형식으로 변환
  Map<String, dynamic> toJson() {
    return {
      'st_id': stId,
      'paid_at': paidAt.toIso8601String(), // ISO 8601 형식 일시 문자열 전송
      'club_id': clubId,
      'amount': amount,
    };
  }
}
