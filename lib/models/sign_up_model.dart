class SignUpModel {
  final String stId; // 학번 (pk, fk, not null)
  final String clubId; // 동아리 ID (pk, fk, not null)
  final DateTime joinedAt; // 가입일 (not null)

  SignUpModel({
    required this.stId,
    required this.clubId,
    required this.joinedAt,
  });

  // 서버(백엔드)에서 받아온 JSON 데이터를 Dart 객체로 변환
  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      stId: json['st_id'] as String,
      clubId: json['club_id'] as String,
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }

  // Dart 객체를 서버로 보낼 JSON 데이터 형식으로 변환
  Map<String, dynamic> toJson() {
    return {
      'st_id': stId,
      'club_id': clubId,
      'joined_at': joinedAt.toIso8601String().split('T')[0], // YYYY-MM-DD 형식 변환
    };
  }
}
