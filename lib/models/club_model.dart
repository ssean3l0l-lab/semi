class ClubModel {
  final String clubId; // 동아리 고유 ID (pk, not null)
  final String clubName; // 동아리명 (not null)
  final int views; // 조회수 (default 0)
  final String? category; // 카테고리 (null 허용)
  final String? representImg; // 대표이미지 URL (null 허용)

  ClubModel({
    required this.clubId,
    required this.clubName,
    this.views = 0,
    this.category,
    this.representImg,
  });

  // 서버(백엔드)에서 받아온 JSON 데이터를 Dart 객체로 변환
  factory ClubModel.fromJson(Map<String, dynamic> json) {
    return ClubModel(
      clubId: json['club_id'] as String,
      clubName: json['club_name'] as String,
      views: json['views'] as int? ?? 0,
      category: json['category'] as String?,
      representImg: json['represent_img'] as String?,
    );
  }

  // Dart 객체를 서버로 보낼 JSON 데이터 형식으로 변환
  Map<String, dynamic> toJson() {
    return {
      'club_id': clubId,
      'club_name': clubName,
      'views': views,
      'category': category,
      'represent_img': representImg,
    };
  }
}
