import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/app_role.dart';
import '../../models/board_post_models.dart';
import '../../services/board_repository.dart';

class ClubPostDetailScreen extends StatefulWidget {
  final int clubId;
  final String clubName;
  final BoardPostModel initialPost;
  final bool? isPresident;

  const ClubPostDetailScreen({
    super.key,
    required this.clubId,
    required this.clubName,
    required this.initialPost,
    this.isPresident,
  });

  @override
  State<ClubPostDetailScreen> createState() => _ClubPostDetailScreenState();
}

class _ClubPostDetailScreenState extends State<ClubPostDetailScreen> {
  late BoardPostModel _post;
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  bool get _effectiveIsPresident {
    return widget.isPresident ?? AppRole.isPresident;
  }

  @override
  void initState() {
    super.initState();
    _post = widget.initialPost;
    _incrementViewAndRefresh();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _incrementViewAndRefresh() async {
    try {
      final refreshed = await BoardRepository.instance.fetchPostDetail(
        widget.clubId,
        _post.postId,
      );
      if (!mounted) return;
      setState(() {
        _post = refreshed;
      });
    } catch (_) {
      // 초기 전달 데이터 유지
    }
  }

  Future<void> _toggleLike() async {
    final updated = await BoardRepository.instance.togglePostLike(
      widget.clubId,
      _post.postId,
    );
    if (!mounted) return;
    setState(() {
      _post = updated;
    });
  }

  Future<void> _togglePin() async {
    final updated = await BoardRepository.instance.togglePostPin(
      widget.clubId,
      _post.postId,
    );
    if (!mounted) return;
    setState(() {
      _post = updated;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          updated.isPinned ? '상단 필독 공지로 고정되었습니다.' : '게시물 상단 고정이 해제되었습니다.',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _deletePost() async {
    await BoardRepository.instance.deletePost(widget.clubId, _post.postId);
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final String currentAuthor = _effectiveIsPresident ? '회장 김신구' : '박시현';

    final updated = await BoardRepository.instance.addComment(
      widget.clubId,
      _post.postId,
      authorName: currentAuthor,
      content: text,
      isAnonymous: false,
    );
    if (!mounted) return;
    _commentController.clear();
    _commentFocusNode.unfocus();
    setState(() {
      _post = updated;
    });
  }

  Future<void> _toggleCommentLike(int commentId) async {
    final updated = await BoardRepository.instance.toggleCommentLike(
      widget.clubId,
      _post.postId,
      commentId,
    );
    if (!mounted) return;
    setState(() {
      _post = updated;
    });
  }

  void _sharePost() {
    final shareUrl =
        'https://shingu.club/clubs/${widget.clubId}/posts/${_post.postId}';
    Clipboard.setData(ClipboardData(text: shareUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('게시글 링크가 클립보드에 복사되었습니다.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPresident = _effectiveIsPresident;
    final imageList = _post.imageAttachments;
    final fileList = _post.fileAttachments;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF191919),
            size: 20.0,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Text(
          widget.clubName,
          style: const TextStyle(
            color: Color(0xFF191919),
            fontSize: 18.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          if (isPresident)
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: Color(0xFF555555),
                size: 21.0,
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              onSelected: (value) {
                if (value == 'pin') {
                  _togglePin();
                } else if (value == 'delete') {
                  _deletePost();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'pin',
                  child: Text(
                    _post.isPinned ? '게시물 고정 해제' : '상단 필독 공지 고정',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text(
                    '게시글 삭제',
                    style: TextStyle(fontSize: 14.0, color: Color(0xFFEF4444)),
                  ),
                ),
              ],
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFEEEEEE), height: 1.0),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 게시글 본문 영역
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 게시판 카테고리 + 고정 배지
                        Row(
                          children: [
                            Text(
                              '${_post.boardCategory} >',
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF8CC63F),
                              ),
                            ),
                            if (_post.isPinned) ...[
                              const SizedBox(width: 8.0),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0,
                                  vertical: 2.0,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: const Text(
                                  '필독 고정',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFEF4444),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 10.0),

                        // 제목
                        Text(
                          _post.title,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF191919),
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 14.0),

                        // 작성자 프로필 + 작성 시간 · 조회수
                        Row(
                          children: [
                            Container(
                              width: 38.0,
                              height: 38.0,
                              decoration: const BoxDecoration(
                                color: Color(0xFFECEFF1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: Color(0xFF90A4AE),
                                size: 22.0,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _post.authorName,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF191919),
                                  ),
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  '${_post.timeAgo} · 조회 ${_post.viewCount}',
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Color(0xFF9E9E9E),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Divider(height: 1.0, color: Color(0xFFEEEEEE)),
                        ),

                        // 본문 텍스트
                        Text(
                          _post.content,
                          style: const TextStyle(
                            fontSize: 14.5,
                            color: Color(0xFF333333),
                            height: 1.65,
                          ),
                        ),

                        // 첨부 사진 영역
                        if (imageList.isNotEmpty) ...[
                          const SizedBox(height: 18.0),
                          Column(
                            children: imageList.map((img) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.asset(
                                    img.fileUrl,
                                    width: double.infinity,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width: double.infinity,
                                              height: 160.0,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF1F8E9),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.image_outlined,
                                                    size: 36.0,
                                                    color: Color(0xFF8CC63F),
                                                  ),
                                                  const SizedBox(height: 6.0),
                                                  Text(
                                                    img.fileName,
                                                    style: const TextStyle(
                                                      fontSize: 12.5,
                                                      color: Color(0xFF555555),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],

                        // 첨부 파일 카드 영역
                        if (fileList.isNotEmpty) ...[
                          const SizedBox(height: 18.0),
                          Column(
                            children: fileList.map((file) {
                              return InkWell(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${file.fileName} 다운로드를 시작합니다.',
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12.0),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8.0),
                                  padding: const EdgeInsets.all(14.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: const Color(0xFFE5E7EB),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3F4F6),
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.description_outlined,
                                          color: Color(0xFF555555),
                                          size: 21.0,
                                        ),
                                      ),
                                      const SizedBox(width: 12.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              file.fileName,
                                              style: const TextStyle(
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF191919),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2.0),
                                            Text(
                                              file.formattedSize,
                                              style: const TextStyle(
                                                fontSize: 11.5,
                                                color: Color(0xFF9E9E9E),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.download_outlined,
                                        color: Color(0xFF555555),
                                        size: 21.0,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],

                        // 태그 목록
                        if (_post.tags.isNotEmpty) ...[
                          const SizedBox(height: 16.0),
                          Wrap(
                            spacing: 6.0,
                            runSpacing: 6.0,
                            children: _post.tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 5.0,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F8E9),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF8CC63F),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],

                        const SizedBox(height: 20.0),

                        // 하단 좋아요 · 댓글 수 · 공유 바
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _toggleLike,
                              child: Row(
                                children: [
                                  Icon(
                                    _post.isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 19.0,
                                    color: _post.isLiked
                                        ? Colors.red
                                        : const Color(0xFF757575),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    '${_post.likeCount}',
                                    style: const TextStyle(
                                      fontSize: 13.0,
                                      color: Color(0xFF757575),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 18.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.chat_bubble_outline,
                                  size: 18.0,
                                  color: Color(0xFF757575),
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  '${_post.commentCount}',
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    color: Color(0xFF757575),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 18.0),
                            GestureDetector(
                              onTap: _sharePost,
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.share_outlined,
                                    size: 18.0,
                                    color: Color(0xFF757575),
                                  ),
                                  SizedBox(width: 5.0),
                                  Text(
                                    '공유',
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      color: Color(0xFF757575),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 본문과 댓글 영역 구분선
                  Container(height: 8.0, color: const Color(0xFFF5F6F8)),

                  // 댓글 영역
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '댓글 ${_post.commentCount}',
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF191919),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        if (_post.comments.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.0),
                            child: Center(
                              child: Text(
                                '첫 번째 댓글을 남겨보세요.',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Color(0xFF9E9E9E),
                                ),
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _post.comments.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 18.0),
                            itemBuilder: (context, index) {
                              final comment = _post.comments[index];

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 34.0,
                                    height: 34.0,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFECEFF1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.person_outline,
                                      color: Color(0xFF90A4AE),
                                      size: 19.0,
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              comment.displayAuthor,
                                              style: const TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF191919),
                                              ),
                                            ),
                                            const SizedBox(width: 6.0),
                                            Text(
                                              comment.timeAgo,
                                              style: const TextStyle(
                                                fontSize: 11.5,
                                                color: Color(0xFF9E9E9E),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          comment.content,
                                          style: const TextStyle(
                                            fontSize: 13.5,
                                            color: Color(0xFF333333),
                                            height: 1.45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  GestureDetector(
                                    onTap: () =>
                                        _toggleCommentLike(comment.commentId),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Icon(
                                        comment.isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 16.0,
                                        color: comment.isLiked
                                            ? Colors.red
                                            : const Color(0xFF9E9E9E),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 하단 고정 댓글 입력창
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 16.0, right: 6.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F8),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        focusNode: _commentFocusNode,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _submitComment(),
                        decoration: const InputDecoration(
                          hintText: '댓글을 남겨 주세요.',
                          hintStyle: TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF9E9E9E),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: Color(0xFF191919),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _submitComment,
                      child: Container(
                        width: 34.0,
                        height: 34.0,
                        decoration: const BoxDecoration(
                          color: Color(0xFF8CC63F),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                          size: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
