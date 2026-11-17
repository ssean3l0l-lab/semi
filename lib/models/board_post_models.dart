enum BoardAttachmentType { image, file }

class BoardAttachmentModel {
  final int? attachmentId;
  final String fileName;
  final String fileUrl;
  final int fileSizeBytes;
  final String mimeType;
  final BoardAttachmentType type;

  const BoardAttachmentModel({
    this.attachmentId,
    required this.fileName,
    required this.fileUrl,
    required this.fileSizeBytes,
    required this.mimeType,
    required this.type,
  });

  String get formattedSize {
    if (fileSizeBytes < 1024) {
      return '${fileSizeBytes}B';
    } else if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  factory BoardAttachmentModel.fromJson(Map<String, dynamic> json) {
    final String rawType = json['type']?.toString() ?? 'file';
    return BoardAttachmentModel(
      attachmentId: json['attachmentId'] as int?,
      fileName: json['fileName']?.toString() ?? '',
      fileUrl: json['fileUrl']?.toString() ?? '',
      fileSizeBytes: json['fileSizeBytes'] as int? ?? 0,
      mimeType: json['mimeType']?.toString() ?? 'application/octet-stream',
      type: rawType == 'image'
          ? BoardAttachmentType.image
          : BoardAttachmentType.file,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (attachmentId != null) 'attachmentId': attachmentId,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'fileSizeBytes': fileSizeBytes,
      'mimeType': mimeType,
      'type': type == BoardAttachmentType.image ? 'image' : 'file',
    };
  }
}

class BoardCommentModel {
  final int commentId;
  final int postId;
  final String authorName;
  final bool isAnonymous;
  final String content;
  final String timeAgo;
  final int likeCount;
  final bool isLiked;

  const BoardCommentModel({
    required this.commentId,
    required this.postId,
    required this.authorName,
    this.isAnonymous = false,
    required this.content,
    required this.timeAgo,
    this.likeCount = 0,
    this.isLiked = false,
  });

  String get displayAuthor => isAnonymous ? '익명' : authorName;

  BoardCommentModel copyWith({int? likeCount, bool? isLiked}) {
    return BoardCommentModel(
      commentId: commentId,
      postId: postId,
      authorName: authorName,
      isAnonymous: isAnonymous,
      content: content,
      timeAgo: timeAgo,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  factory BoardCommentModel.fromJson(Map<String, dynamic> json) {
    return BoardCommentModel(
      commentId: json['commentId'] as int? ?? 0,
      postId: json['postId'] as int? ?? 0,
      authorName: json['authorName']?.toString() ?? '익명',
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      content: json['content']?.toString() ?? '',
      timeAgo: json['timeAgo']?.toString() ?? '방금 전',
      likeCount: json['likeCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'postId': postId,
      'authorName': authorName,
      'isAnonymous': isAnonymous,
      'content': content,
      'timeAgo': timeAgo,
      'likeCount': likeCount,
      'isLiked': isLiked,
    };
  }
}

class BoardPostModel {
  final int postId;
  final int clubId;
  final String boardCategory;
  final String title;
  final String content;
  final String authorName;
  final String timeAgo;
  final int viewCount;
  final int likeCount;
  final bool isLiked;
  final bool isNotice;
  final bool isPinned;
  final List<String> tags;
  final List<BoardAttachmentModel> attachments;
  final List<BoardCommentModel> comments;

  const BoardPostModel({
    required this.postId,
    required this.clubId,
    required this.boardCategory,
    required this.title,
    required this.content,
    required this.authorName,
    required this.timeAgo,
    this.viewCount = 0,
    this.likeCount = 0,
    this.isLiked = false,
    this.isNotice = false,
    this.isPinned = false,
    this.tags = const [],
    this.attachments = const [],
    this.comments = const [],
  });

  int get commentCount => comments.length;

  List<BoardAttachmentModel> get imageAttachments => attachments
      .where((item) => item.type == BoardAttachmentType.image)
      .toList();

  List<BoardAttachmentModel> get fileAttachments => attachments
      .where((item) => item.type == BoardAttachmentType.file)
      .toList();

  BoardPostModel copyWith({
    String? boardCategory,
    String? title,
    String? content,
    int? viewCount,
    int? likeCount,
    bool? isLiked,
    bool? isNotice,
    bool? isPinned,
    List<String>? tags,
    List<BoardAttachmentModel>? attachments,
    List<BoardCommentModel>? comments,
  }) {
    return BoardPostModel(
      postId: postId,
      clubId: clubId,
      boardCategory: boardCategory ?? this.boardCategory,
      title: title ?? this.title,
      content: content ?? this.content,
      authorName: authorName,
      timeAgo: timeAgo,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isNotice: isNotice ?? this.isNotice,
      isPinned: isPinned ?? this.isPinned,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
      comments: comments ?? this.comments,
    );
  }

  factory BoardPostModel.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tags'] as List<dynamic>? ?? const [];
    final rawAttachments = json['attachments'] as List<dynamic>? ?? const [];
    final rawComments = json['comments'] as List<dynamic>? ?? const [];

    return BoardPostModel(
      postId: json['postId'] as int? ?? 0,
      clubId: json['clubId'] as int? ?? 1,
      boardCategory: json['boardCategory']?.toString() ?? '자유게시판',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      authorName: json['authorName']?.toString() ?? '익명',
      timeAgo: json['timeAgo']?.toString() ?? '방금 전',
      viewCount: json['viewCount'] as int? ?? 0,
      likeCount: json['likeCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      isNotice: json['isNotice'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      tags: rawTags.map((e) => e.toString()).toList(),
      attachments: rawAttachments
          .map((e) => BoardAttachmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      comments: rawComments
          .map((e) => BoardCommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'clubId': clubId,
      'boardCategory': boardCategory,
      'title': title,
      'content': content,
      'authorName': authorName,
      'timeAgo': timeAgo,
      'viewCount': viewCount,
      'likeCount': likeCount,
      'isLiked': isLiked,
      'isNotice': isNotice,
      'isPinned': isPinned,
      'tags': tags,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'comments': comments.map((e) => e.toJson()).toList(),
    };
  }
}

class BoardPostDraftModel {
  final int draftId;
  final int clubId;
  final String? boardCategory;
  final String title;
  final String content;
  final List<String> tags;
  final List<BoardAttachmentModel> attachments;
  final bool isPinned;
  final String savedAt;

  const BoardPostDraftModel({
    required this.draftId,
    required this.clubId,
    this.boardCategory,
    required this.title,
    required this.content,
    this.tags = const [],
    this.attachments = const [],
    this.isPinned = false,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'draftId': draftId,
      'clubId': clubId,
      'boardCategory': boardCategory,
      'title': title,
      'content': content,
      'tags': tags,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'isPinned': isPinned,
      'savedAt': savedAt,
    };
  }
}

/// 백엔드 POST /api/clubs/{clubId}/posts 요청용 DTO
class CreatePostRequestDto {
  final int clubId;
  final String boardCategory;
  final String title;
  final String content;
  final List<String> tags;
  final List<BoardAttachmentModel> attachments;
  final bool isPinned;

  const CreatePostRequestDto({
    required this.clubId,
    required this.boardCategory,
    required this.title,
    required this.content,
    this.tags = const [],
    this.attachments = const [],
    this.isPinned = false,
  });

  bool get isNotice => boardCategory == '공지사항' || isPinned;

  Map<String, dynamic> toJson() {
    return {
      'clubId': clubId,
      'boardCategory': boardCategory,
      'title': title,
      'content': content,
      'tags': tags,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'isPinned': isPinned,
      'isNotice': isNotice,
    };
  }
}
