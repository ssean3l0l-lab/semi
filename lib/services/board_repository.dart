import '../models/board_post_models.dart';

typedef PostList = List<BoardPostModel>;
typedef DraftList = List<BoardPostDraftModel>;

class BoardRepository {
  BoardRepository._();
  static final BoardRepository instance = BoardRepository._();

  int _nextPostId = 1005;
  int _nextCommentId = 5010;
  int _nextDraftId = 2;

  final Map<int, PostList> _postsByClub = {
    1: [
      const BoardPostModel(
        postId: 1001,
        clubId: 1,
        boardCategory: '자유게시판',
        title: '백엔드 파트',
        content: '이번에 백엔드 파트 지원하려는데 코딩테스트 보나요??',
        authorName: '익명',
        timeAgo: '2시간 전',
        viewCount: 64,
        likeCount: 18,
        isLiked: false,
        isNotice: false,
        isPinned: false,
        tags: ['백엔드', '지원문의'],
        comments: [
          BoardCommentModel(
            commentId: 5001,
            postId: 1001,
            authorName: '운영진 박시현',
            content: '별도 코딩테스트 없이 지원서와 간단한 면접으로 진행됩니다!',
            timeAgo: '1시간 전',
            likeCount: 4,
          ),
        ],
      ),
      const BoardPostModel(
        postId: 1002,
        clubId: 1,
        boardCategory: '자유게시판',
        title: '헬로월드 분위기',
        content: '이번 신입생인데 헬로월드 동아리 분위기 어떤가요',
        authorName: '익명',
        timeAgo: '15시간 전',
        viewCount: 91,
        likeCount: 12,
        isLiked: false,
        isNotice: false,
        isPinned: false,
        tags: ['신입생', '분위기'],
        comments: [
          BoardCommentModel(
            commentId: 5002,
            postId: 1002,
            authorName: '익명',
            isAnonymous: true,
            content: '스터디랑 프로젝트 분위기 모두 편하고 선배들이 잘 알려줘요!',
            timeAgo: '12시간 전',
            likeCount: 3,
          ),
        ],
      ),
      const BoardPostModel(
        postId: 1003,
        clubId: 1,
        boardCategory: '자유게시판',
        title: '작년 공모전 대회 수상 실적 공유합니다!',
        content: '안녕하세요, HelloWorld입니다! 지난 학기 교내 캡스톤 경진대회에서 저희 팀이 최우수상을 수상했습니다. 기획부터 개발, 발표까지 함께 달린 팀원들의 경험을 정리해 공유합니다. 다음 공모전을 준비하는 분들께 도움이 되길 바랍니다.',
        authorName: '정보부장 이도현',
        timeAgo: '1일 전',
        viewCount: 142,
        likeCount: 30,
        isLiked: false,
        isNotice: true,
        isPinned: true,
        tags: ['공모전', '캡스톤', '수상후기'],
        attachments: [
          BoardAttachmentModel(
            attachmentId: 3001,
            fileName: '2026_공모전_회고.pdf',
            fileUrl: 'https://shingu.club/files/2026_공모전_회고.pdf',
            fileSizeBytes: 2516582,
            mimeType: 'application/pdf',
            type: BoardAttachmentType.file,
          ),
        ],
        comments: [
          BoardCommentModel(
            commentId: 5003,
            postId: 1003,
            authorName: '김신구',
            content: '자료 공유 감사합니다! 발표 준비 파트가 특히 도움이 됐어요.',
            timeAgo: '20시간 전',
            likeCount: 2,
          ),
          BoardCommentModel(
            commentId: 5004,
            postId: 1003,
            authorName: '익명',
            isAnonymous: true,
            content: '다음 공모전 모집 일정도 올라오나요?',
            timeAgo: '18시간 전',
            likeCount: 1,
          ),
          BoardCommentModel(
            commentId: 5005,
            postId: 1003,
            authorName: '정보부장 이도현',
            content: '다음 주 중으로 공지사항 게시판에 팀 빌딩 일정 업로드 예정입니다!',
            timeAgo: '15시간 전',
            likeCount: 3,
          ),
        ],
      ),
      const BoardPostModel(
        postId: 1004,
        clubId: 1,
        boardCategory: '자유게시판',
        title: '오늘 동방 열려있나요??',
        content: 'ㅈㄱㄴ',
        authorName: '익명',
        timeAgo: '1일 전',
        viewCount: 38,
        likeCount: 1,
        isLiked: false,
        isNotice: false,
        isPinned: false,
        comments: [
          BoardCommentModel(
            commentId: 5006,
            postId: 1004,
            authorName: '익명',
            isAnonymous: true,
            content: '네 오후 6시까지 열려있습니다!',
            timeAgo: '1일 전',
          ),
        ],
      ),
    ],
  };

  final Map<int, DraftList> _draftsByClub = {
    1: [
      const BoardPostDraftModel(
        draftId: 1,
        clubId: 1,
        boardCategory: '자유게시판',
        title: '이번 주 금요일 스터디 회고 정리',
        content: 'Flutter 상태 관리 및 REST API 연동 실습 내용을 정리 중입니다.',
        tags: ['스터디', 'Flutter'],
        savedAt: '2026.11.17 14:10',
      ),
    ],
  };

  PostList _ensureClubPosts(int clubId, String clubName) {
    return _postsByClub.putIfAbsent(clubId, () {
      return [
        BoardPostModel(
          postId: _nextPostId++,
          clubId: clubId,
          boardCategory: '공지사항',
          title: '$clubName 2학기 정기 활동 안내',
          content: '안녕하세요, $clubName 운영진입니다. 이번 학기 정기 모임 및 주요 일정 안내드립니다.',
          authorName: '회장 김신구',
          timeAgo: '1일 전',
          viewCount: 85,
          likeCount: 19,
          isNotice: true,
          isPinned: true,
          tags: const ['정기모임', '공지'],
        ),
      ];
    });
  }

  Future<PostList> fetchPosts(
    int clubId, {
    String clubName = 'HelloWorld',
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List<BoardPostModel>.from(_ensureClubPosts(clubId, clubName));
  }

  Future<BoardPostModel> fetchPostDetail(int clubId, int postId) async {
    await Future.delayed(const Duration(milliseconds: 80));
    final list = _postsByClub[clubId] ?? [];
    final index = list.indexWhere((p) => p.postId == postId);
    if (index == -1) {
      throw StateError('게시글을 찾을 수 없습니다. (postId: $postId)');
    }
    final updated = list[index].copyWith(viewCount: list[index].viewCount + 1);
    list[index] = updated;
    return updated;
  }

  Future<BoardPostModel> createPost(
    CreatePostRequestDto dto, {
    required String authorName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final list = _postsByClub.putIfAbsent(dto.clubId, () => []);

    if (dto.isPinned) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].isPinned) {
          list[i] = list[i].copyWith(isPinned: false);
        }
      }
    }

    final newPost = BoardPostModel(
      postId: _nextPostId++,
      clubId: dto.clubId,
      boardCategory: dto.boardCategory,
      title: dto.title,
      content: dto.content,
      authorName: authorName,
      timeAgo: '방금 전',
      viewCount: 1,
      likeCount: 0,
      isLiked: false,
      isNotice: dto.isNotice,
      isPinned: dto.isPinned,
      tags: List<String>.from(dto.tags),
      attachments: List<BoardAttachmentModel>.from(dto.attachments),
      comments: const [],
    );

    list.insert(0, newPost);
    return newPost;
  }

  Future<BoardPostModel> togglePostLike(int clubId, int postId) async {
    final list = _postsByClub[clubId] ?? [];
    final index = list.indexWhere((p) => p.postId == postId);
    if (index == -1) {
      throw StateError('게시글을 찾을 수 없습니다.');
    }
    final current = list[index];
    final nextLiked = !current.isLiked;
    final updated = current.copyWith(
      isLiked: nextLiked,
      likeCount: nextLiked ? current.likeCount + 1 : current.likeCount - 1,
    );
    list[index] = updated;
    return updated;
  }

  Future<BoardPostModel> togglePostPin(int clubId, int postId) async {
    final list = _postsByClub[clubId] ?? [];
    final index = list.indexWhere((p) => p.postId == postId);
    if (index == -1) {
      throw StateError('게시글을 찾을 수 없습니다.');
    }
    final target = list[index];
    final nextPinned = !target.isPinned;

    if (nextPinned) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].isPinned) {
          list[i] = list[i].copyWith(isPinned: false);
        }
      }
    }

    final updated = list[index].copyWith(
      isPinned: nextPinned,
      isNotice: nextPinned ? true : list[index].isNotice,
    );
    list[index] = updated;
    return updated;
  }

  Future<void> deletePost(int clubId, int postId) async {
    final list = _postsByClub[clubId];
    list?.removeWhere((p) => p.postId == postId);
  }

  Future<BoardPostModel> addComment(
    int clubId,
    int postId, {
    required String authorName,
    required String content,
    bool isAnonymous = false,
  }) async {
    final list = _postsByClub[clubId] ?? [];
    final index = list.indexWhere((p) => p.postId == postId);
    if (index == -1) {
      throw StateError('게시글을 찾을 수 없습니다.');
    }
    final current = list[index];
    final newComment = BoardCommentModel(
      commentId: _nextCommentId++,
      postId: postId,
      authorName: authorName,
      isAnonymous: isAnonymous,
      content: content,
      timeAgo: '방금 전',
    );
    final updated = current.copyWith(
      comments: [...current.comments, newComment],
    );
    list[index] = updated;
    return updated;
  }

  Future<BoardPostModel> toggleCommentLike(
    int clubId,
    int postId,
    int commentId,
  ) async {
    final list = _postsByClub[clubId] ?? [];
    final postIndex = list.indexWhere((p) => p.postId == postId);
    if (postIndex == -1) {
      throw StateError('게시글을 찾을 수 없습니다.');
    }
    final post = list[postIndex];
    final updatedComments = post.comments.map((comment) {
      if (comment.commentId != commentId) return comment;
      final nextLiked = !comment.isLiked;
      return comment.copyWith(
        isLiked: nextLiked,
        likeCount: nextLiked ? comment.likeCount + 1 : comment.likeCount - 1,
      );
    }).toList();

    final updatedPost = post.copyWith(comments: updatedComments);
    list[postIndex] = updatedPost;
    return updatedPost;
  }

  DraftList getDrafts(int clubId) {
    return List<BoardPostDraftModel>.from(_draftsByClub[clubId] ?? const []);
  }

  BoardPostDraftModel saveDraft({
    required int clubId,
    String? boardCategory,
    required String title,
    required String content,
    required List<String> tags,
    required List<BoardAttachmentModel> attachments,
    required bool isPinned,
  }) {
    final drafts = _draftsByClub.putIfAbsent(clubId, () => []);
    final now = DateTime.now();
    final formattedTime =
        '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final draft = BoardPostDraftModel(
      draftId: _nextDraftId++,
      clubId: clubId,
      boardCategory: boardCategory,
      title: title.isEmpty ? '(제목 없음)' : title,
      content: content,
      tags: List<String>.from(tags),
      attachments: List<BoardAttachmentModel>.from(attachments),
      isPinned: isPinned,
      savedAt: formattedTime,
    );
    drafts.insert(0, draft);
    return draft;
  }

  void deleteDraft(int clubId, int draftId) {
    _draftsByClub[clubId]?.removeWhere((d) => d.draftId == draftId);
  }
}
