class ClubFaqModel {
  final int faqId;
  final String question;
  final String answer;

  const ClubFaqModel({
    required this.faqId,
    required this.question,
    required this.answer,
  });

  factory ClubFaqModel.fromJson(Map<String, dynamic> json) {
    return ClubFaqModel(
      faqId: json['faq_id'] as int? ?? 0,
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
    );
  }
}

class ClubModel {
  final int clubId;
  final String clubName;
  final String category;
  final bool isRecruiting;
  final DateTime? recruitDeadline;
  final String description;
  final String logoUrl;
  final String bannerUrl;
  final String meetingTime;
  final String location;
  final int memberCount;
  final List<String> activities;
  final List<ClubFaqModel> faqs;
  final List<String> newsImages;

  const ClubModel({
    required this.clubId,
    required this.clubName,
    required this.category,
    required this.isRecruiting,
    this.recruitDeadline,
    required this.description,
    required this.logoUrl,
    required this.bannerUrl,
    this.meetingTime = '',
    this.location = '',
    this.memberCount = 0,
    this.activities = const [],
    this.faqs = const [],
    this.newsImages = const [],
  });

  String get statusLabel => isRecruiting ? '모집중' : '모집완료';

  String get formattedDeadline {
    if (recruitDeadline == null) return '상시 모집';
    return '~ ${recruitDeadline!.month}월 ${recruitDeadline!.day}일';
  }

  factory ClubModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawRecruiting = json['is_recruiting'];
    final bool parsedRecruiting = rawRecruiting is bool
        ? rawRecruiting
        : (rawRecruiting == 1 || rawRecruiting?.toString() == 'true');

    final String? deadlineStr = json['recruit_deadline']?.toString();
    final DateTime? parsedDeadline = deadlineStr != null
        ? DateTime.tryParse(deadlineStr)
        : null;

    return ClubModel(
      clubId: json['club_id'] as int? ?? 0,
      clubName: json['club_name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      isRecruiting: parsedRecruiting,
      recruitDeadline: parsedDeadline,
      description: json['description']?.toString() ?? '',
      logoUrl: json['logo_url']?.toString() ?? '',
      bannerUrl: json['banner_url']?.toString() ?? '',
      meetingTime: json['meeting_time']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      memberCount: json['member_count'] as int? ?? 0,
      activities:
          (json['activities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      faqs:
          (json['faqs'] as List<dynamic>?)
              ?.map((e) => ClubFaqModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      newsImages:
          (json['news_images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}

class BoardPostPreviewModel {
  final int postId;
  final String title;
  final String timeAgo;

  const BoardPostPreviewModel({
    required this.postId,
    required this.title,
    required this.timeAgo,
  });

  factory BoardPostPreviewModel.fromJson(Map<String, dynamic> json) {
    return BoardPostPreviewModel(
      postId: json['post_id'] as int? ?? 0,
      title: json['title']?.toString() ?? '',
      timeAgo: json['time_ago']?.toString() ?? '',
    );
  }
}

class BoardSummaryModel {
  final int clubId;
  final String clubName;
  final String category;
  final int memberCount;
  final String logoUrl;
  final int newPostCount;
  final List<BoardPostPreviewModel> recentPosts;

  const BoardSummaryModel({
    required this.clubId,
    required this.clubName,
    required this.category,
    required this.memberCount,
    required this.logoUrl,
    required this.newPostCount,
    required this.recentPosts,
  });

  String get subtitle => '$category • 회원 $memberCount명';
  String get badgeText => newPostCount > 0 ? '+$newPostCount' : '';

  factory BoardSummaryModel.fromJson(Map<String, dynamic> json) {
    return BoardSummaryModel(
      clubId: json['club_id'] as int? ?? 0,
      clubName: json['club_name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      memberCount: json['member_count'] as int? ?? 0,
      logoUrl: json['logo_url']?.toString() ?? '',
      newPostCount: json['new_post_count'] as int? ?? 0,
      recentPosts:
          (json['recent_posts'] as List<dynamic>?)
              ?.map(
                (e) =>
                    BoardPostPreviewModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );
  }
}
