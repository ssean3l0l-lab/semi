class RecruitmentModel {
  final DateTime reDate; // 모집 시작일 (pk, not null)
  final String clubId; // 동아리 ID (fk, not null)
  final DateTime? deadlineDate; // 마감일 (null 허용)
  final String? statusCode; // 모집 상태코드 (null 허용)

  RecruitmentModel({
    required this.reDate,
    required this.clubId,
    this.deadlineDate,
    this.statusCode,
  });

  // 서버(백엔드)에서 받아온 JSON 데이터를 Dart 객체로 변환
  factory RecruitmentModel.fromJson(Map<String, dynamic> json) {
    return RecruitmentModel(
      reDate: DateTime.parse(json['re_date'] as String),
      clubId: json['club_id'] as String,
      deadlineDate: json['deadline_date'] != null
          ? DateTime.parse(json['deadline_date'] as String)
          : null,
      statusCode: json['status_code'] as String?,
    );
  }

  // Dart 객체를 서버로 보낼 JSON 데이터 형식으로 변환
  Map<String, dynamic> toJson() {
    return {
      're_date': reDate.toIso8601String().split('T')[0], // YYYY-MM-DD 형식 변환
      'club_id': clubId,
      'deadline_date': deadlineDate?.toIso8601String().split('T')[0],
      'status_code': statusCode,
    };
  }
}
