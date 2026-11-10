class UserModel {
  final String stId; // 학번 (pk, not null)
  final String? department; // 학과 (null 허용)
  final String? profileImg; // 프로필 이미지 URL (null 허용)

  UserModel({required this.stId, this.department, this.profileImg});

  // 서버(백엔드)에서 받아온 JSON 데이터를 Dart 객체로 변환
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      stId: json['st_id'] as String,
      department: json['department'] as String?,
      profileImg: json['profile_img'] as String?,
    );
  }

  // Dart 객체를 서버로 보낼 JSON 데이터 형식으로 변환
  Map<String, dynamic> toJson() {
    return {'st_id': stId, 'department': department, 'profile_img': profileImg};
  }
}
