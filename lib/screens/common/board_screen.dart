import 'package:flutter/material.dart';

import '../../services/club_repository.dart';
import 'club_board_screen.dart';
import 'my_clubs_screen.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  BoardSummaryList _boardList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBoards();
    MyClubsScreen.clubsNotifier.addListener(_loadBoards);
  }

  @override
  void dispose() {
    MyClubsScreen.clubsNotifier.removeListener(_loadBoards);
    super.dispose();
  }

  Future<void> _loadBoards() async {
    final BoardSummaryList data = await ClubRepository.instance
        .fetchMyBoardSummaries();
    if (!mounted) return;
    setState(() {
      _boardList = data;
      _isLoading = false;
    });
  }

  Widget _buildClubLogo(String path) {
    final Widget fallback = Container(
      width: 44.0,
      height: 44.0,
      color: const Color(0xFFE8F5E9),
      child: const Center(
        child: Icon(Icons.people, color: Color(0xFF8CC63F), size: 22),
      ),
    );

    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: 44.0,
        height: 44.0,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      );
    }
    return Image.asset(
      path,
      width: 44.0,
      height: 44.0,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => fallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20.0,
        title: const Text(
          '동아리 게시판',
          style: TextStyle(
            color: Color(0xFF191919),
            fontWeight: FontWeight.w800,
            fontSize: 20.0,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF8CC63F)),
            )
          : _boardList.isEmpty
          ? const Center(
              child: Text(
                '가입된 동아리 게시판이 없습니다.',
                style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14.0),
              ),
            )
          : RefreshIndicator(
              color: const Color(0xFF8CC63F),
              onRefresh: _loadBoards,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
                itemCount: _boardList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16.0),
                itemBuilder: (context, index) {
                  final board = _boardList[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClubBoardScreen(
                            clubName: board.clubName,
                            clubLogo: board.logoUrl,
                            memberCount: board.memberCount,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: const Color(0xFFEEEEEE)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: _buildClubLogo(board.logoUrl),
                              ),
                              const SizedBox(width: 14.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      board.clubName,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF191919),
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      board.subtitle,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Color(0xFF757575),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (board.newPostCount > 0) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFEBEE),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    board.badgeText,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFE57373),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                              ],
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFFBDBDBD),
                                size: 22.0,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          const Divider(height: 1, color: Color(0xFFF5F5F5)),
                          const SizedBox(height: 12.0),
                          ...board.recentPosts.map((post) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      post.title,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        color: Color(0xFF333333),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  Text(
                                    post.timeAgo,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Color(0xFF9E9E9E),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
