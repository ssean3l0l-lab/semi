class ApplicationModel {
  final String stId; // 지원자 학번 (pk, fk, not null)
  final DateTime appliedAt; // 지원일시 (pk, not null)
  final DateTime reDate; // 모집일 (fk, not null)
  final String? statusCode; // 지원 상태코드 (null 허용)

  ApplicationModel({
    required this.stId,
    required this.appliedAt,
    required this.reDate,
    this.statusCode,
  });

  // 서버(백엔드)에서 받아온 JSON 데이터를 Dart 객체로 변환
  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      stId: json['st_id'] as String,
      appliedAt: DateTime.parse(json['applied_at'] as String),
      reDate: DateTime.parse(json['re_date'] as String),
      statusCode: json['status_code'] as String?,
    );
  }

  // Dart 객체를 서버로 보낼 JSON 데이터 형식으로 변환
  Map<String, dynamic> toJson() {
    return {
      'st_id': stId,
      'applied_at': appliedAt.toIso8601String(), // 날짜 및 시간 정보(timestamp) 전체 전송
      're_date': reDate.toIso8601String().split(
        'T',
      )[0], // YYYY-MM-DD(date) 형식만 변환
      'status_code': statusCode,
    };
  }
}
