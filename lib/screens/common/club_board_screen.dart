import 'package:flutter/material.dart';

import '../../config/app_role.dart';
import '../../models/board_post_models.dart';
import '../../services/board_repository.dart';
import 'club_post_detail_screen.dart';
import 'club_post_write_screen.dart';

class ClubBoardScreen extends StatefulWidget {
  final int clubId;
  final String clubName;
  final String clubLogo;
  final int memberCount;
  final bool? isPresident;

  const ClubBoardScreen({
    super.key,
    this.clubId = 1,
    this.clubName = 'HelloWorld',
    this.clubLogo = 'assets/images/logo-helloworld.png',
    this.memberCount = 57,
    this.isPresident,
  });

  @override
  State<ClubBoardScreen> createState() => _ClubBoardScreenState();
}

class _ClubBoardScreenState extends State<ClubBoardScreen> {
  int _selectedTabIndex = 0; // 0: 전체, 1: 공지, 2: 인기
  bool _isSearching = false;
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  PostList _posts = [];

  bool get _effectiveIsPresident {
    return widget.isPresident ?? AppRole.isPresident;
  }

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPosts() async {
    final posts = await BoardRepository.instance.fetchPosts(
      widget.clubId,
      clubName: widget.clubName,
    );
    if (!mounted) return;
    setState(() {
      _posts = posts;
      _isLoading = false;
    });
  }

  BoardPostModel? get _pinnedPost {
    for (final post in _posts) {
      if (post.isPinned) return post;
    }
    return null;
  }

  PostList _getFilteredPosts() {
    final query = _searchController.text.trim().toLowerCase();

    return _posts.where((post) {
      if (_selectedTabIndex == 1 && !post.isNotice) {
        return false;
      }
      if (_selectedTabIndex == 2 && post.likeCount < 15) {
        return false;
      }
      if (query.isNotEmpty) {
        final titleMatch = post.title.toLowerCase().contains(query);
        final contentMatch = post.content.toLowerCase().contains(query);
        final tagMatch = post.tags.any((t) => t.toLowerCase().contains(query));
        return titleMatch || contentMatch || tagMatch;
      }
      return true;
    }).toList();
  }

  Future<void> _openPostDetail(BoardPostModel post) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubPostDetailScreen(
          clubId: widget.clubId,
          clubName: widget.clubName,
          initialPost: post,
          isPresident: _effectiveIsPresident,
        ),
      ),
    );
    await _loadPosts();
  }

  Future<void> _openWriteScreen() async {
    final created = await Navigator.push<BoardPostModel>(
      context,
      MaterialPageRoute(
        builder: (context) => ClubPostWriteScreen(
          clubId: widget.clubId,
          clubName: widget.clubName,
          isPresident: _effectiveIsPresident,
        ),
      ),
    );
    if (created != null) {
      await _loadPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredPosts = _getFilteredPosts();
    final pinnedPost = _pinnedPost;

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
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: '제목, 내용, #태그 검색...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 14.0),
                ),
                style: const TextStyle(fontSize: 14.0),
              )
            : Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      widget.clubLogo,
                      width: 38.0,
                      height: 38.0,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 38.0,
                        height: 38.0,
                        color: const Color(0xFF1E293B),
                        alignment: Alignment.center,
                        child: Text(
                          widget.clubName.substring(0, 1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.clubName,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191919),
                        ),
                      ),
                      Text(
                        '멤버 ${widget.memberCount}명',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        actions: [
          _buildCircleActionButton(
            icon: _isSearching ? Icons.close : Icons.search,
            onTap: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchController.clear();
              });
            },
          ),
          const SizedBox(width: 8.0),
          _buildCircleActionButton(
            icon: Icons.format_list_bulleted,
            onTap: () {
              setState(() {
                _selectedTabIndex = 0;
              });
            },
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      body: Column(
        children: [
          // 상단 탭 (전체 / 공지 / 인기)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
              ),
            ),
            child: Row(
              children: [
                _buildBoardTab(0, '전체'),
                _buildBoardTab(1, '공지'),
                _buildBoardTab(2, '인기'),
              ],
            ),
          ),

          // 필독 공지 고정 배너 (탭 시 해당 고정 게시물 상세로 이동)
          if (pinnedPost != null)
            InkWell(
              onTap: () => _openPostDetail(pinnedPost),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 14.0,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 3.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: const Text(
                        '필독',
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Text(
                        pinnedPost.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191919),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 18.0,
                      color: Color(0xFFBDBDBD),
                    ),
                  ],
                ),
              ),
            ),

          // 게시글 목록
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF8CC63F)),
                  )
                : filteredPosts.isEmpty
                ? const Center(
                    child: Text(
                      '등록된 게시글이 없습니다.',
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 14.0,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    color: const Color(0xFF8CC63F),
                    onRefresh: _loadPosts,
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 84.0),
                      itemCount: filteredPosts.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1.0,
                        thickness: 1.0,
                        color: Color(0xFFF2F2F2),
                      ),
                      itemBuilder: (context, index) {
                        final post = filteredPosts[index];

                        return InkWell(
                          onTap: () => _openPostDetail(post),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 16.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (post.isPinned) ...[
                                      const Icon(
                                        Icons.push_pin,
                                        size: 14.0,
                                        color: Color(0xFF8CC63F),
                                      ),
                                      const SizedBox(width: 4.0),
                                    ],
                                    Expanded(
                                      child: Text(
                                        post.title,
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF191919),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (post.attachments.isNotEmpty) ...[
                                      const SizedBox(width: 6.0),
                                      const Icon(
                                        Icons.attach_file,
                                        size: 15.0,
                                        color: Color(0xFF9E9E9E),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  post.content,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    color: Color(0xFF757575),
                                  ),
                                ),
                                if (post.tags.isNotEmpty) ...[
                                  const SizedBox(height: 8.0),
                                  Wrap(
                                    spacing: 6.0,
                                    runSpacing: 4.0,
                                    children: post.tags.map((tag) {
                                      return Text(
                                        '#$tag',
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF8CC63F),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                                const SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    Text(
                                      post.authorName,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Color(0xFF9E9E9E),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.0,
                                      ),
                                      child: Text(
                                        '•',
                                        style: TextStyle(
                                          fontSize: 11.0,
                                          color: Color(0xFFBDBDBD),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      post.timeAgo,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Color(0xFF9E9E9E),
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () async {
                                        await BoardRepository.instance
                                            .togglePostLike(
                                              widget.clubId,
                                              post.postId,
                                            );
                                        await _loadPosts();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            post.isLiked
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 16.0,
                                            color: post.isLiked
                                                ? Colors.red
                                                : const Color(0xFF9E9E9E),
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            '${post.likeCount}',
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Color(0xFF757575),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12.0),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.chat_bubble_outline,
                                          size: 15.0,
                                          color: Color(0xFF9E9E9E),
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          '${post.commentCount}',
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            color: Color(0xFF757575),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      // 회원 및 회장 모두 게시글 작성 화면으로 이동 가능
      floatingActionButton: FloatingActionButton(
        onPressed: _openWriteScreen,
        backgroundColor: const Color(0xFF8CC63F),
        elevation: 4.0,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28.0),
      ),
    );
  }

  Widget _buildCircleActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.0,
        height: 36.0,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF191919), size: 20.0),
      ),
    );
  }

  Widget _buildBoardTab(int index, String label) {
    final bool isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF8CC63F) : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? const Color(0xFF8CC63F)
                : const Color(0xFF555555),
          ),
        ),
      ),
    );
  }
}
