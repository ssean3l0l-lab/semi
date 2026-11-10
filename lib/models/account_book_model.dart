class AccountBookModel {
  final DateTime createdAt; // 장부 등록일시 (pk, not null)
  final String clubId; // 동아리 ID (fk, not null)
  final int amount; // 금액 (not null)
  final String? description; // 내역 (null 허용)
  final String? proofImg; // 증빙 이미지 URL (null 허용)

  AccountBookModel({
    required this.createdAt,
    required this.clubId,
    required this.amount,
    this.description,
    this.proofImg,
  });

  // 서버(백엔드)에서 받아온 JSON 데이터를 Dart 객체로 변환
  factory AccountBookModel.fromJson(Map<String, dynamic> json) {
    return AccountBookModel(
      createdAt: DateTime.parse(json['created_at'] as String),
      clubId: json['club_id'] as String,
      amount: json['amount'] as int,
      description: json['description'] as String?,
      proofImg: json['proof_img'] as String?,
    );
  }

  // Dart 객체를 서버로 보낼 JSON 데이터 형식으로 변환
  Map<String, dynamic> toJson() {
    return {
      'created_at': createdAt.toIso8601String(), // ISO 8601 형식 일시 문자열 전송
      'club_id': clubId,
      'amount': amount,
      'description': description,
      'proof_img': proofImg,
    };
  }
}
