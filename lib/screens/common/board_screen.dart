import 'package:flutter/material.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final boardList = [
      {
        'title': 'HelloWorld',
        'subtitle': 'IT / 코딩 • 회원 32명',
        'logo': 'assets/images/logo-helloworld.png',
        'badge': '+3',
        'posts': [
          {'title': '이번 주 금요일 실시간 백엔드 코딩 세션 공지', 'time': '10분 전'},
          {'title': '2025년도 연합 IT 프로젝트 디자인 시안 피...', 'time': '1시간 전'},
        ],
      },
      {
        'title': '아리아',
        'subtitle': '사회 / 봉사 • 회원 26명',
        'logo': 'assets/images/logo-aria.png',
        'badge': '+2',
        'posts': [
          {'title': '주말 독거노인 급식 봉사 차량 지원 인원 구...', 'time': '18시간 전'},
          {'title': '봉사활동 시간 1365 등록 대장 확인 요청', 'time': '2일 전'},
        ],
      },
    ];

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
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        itemCount: boardList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16.0),
        itemBuilder: (context, index) {
          final board = boardList[index];
          final posts = (board['posts'] as List)
              .map((e) => Map<String, String>.from(e))
              .toList();

          return Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: const Color(0xFFEEEEEE)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
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
                      child: Image.asset(
                        board['logo'] as String,
                        width: 44.0,
                        height: 44.0,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 44.0,
                          height: 44.0,
                          color: const Color(0xFFE8F5E9),
                          child: const Center(
                            child: Icon(
                              Icons.people,
                              color: Color(0xFF8CC63F),
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            board['title'] as String,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF191919),
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            board['subtitle'] as String,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                        board['badge'] as String,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE57373),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
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
                ...posts.map((post) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            post['title']!,
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
                          post['time']!,
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
          );
        },
      ),
    );
  }
}
