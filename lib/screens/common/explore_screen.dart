import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedCategory = '전체';

  @override
  Widget build(BuildContext context) {
    final categories = ['전체', '학술', '체육', '공연/예술', '사회/봉사'];

    final clubs = [
      {
        'title': 'HelloWorld',
        'category': 'IT / 코딩',
        'status': '모집중',
        'desc': '프로그래밍 기초부터 실제 앱 출시까지 함께 달리는 개발 동아리입니다.',
        'image': 'assets/images/logo-helloworld.png',
        'banner': 'assets/images/banner1.png',
      },
      {
        'title': '디포스 (D-Force)',
        'category': '댄스 / 예술',
        'status': '모집중',
        'desc': '함께 춤추고 무대를 채우는 열정 넘치는 댄스 동아리입니다.',
        'image': 'assets/images/logo-dforce.png',
        'banner': 'assets/images/banner2.png',
      },
      {
        'title': 'ORANGE',
        'category': '스포츠',
        'status': '모집중',
        'desc': '코트 위에서 땀 흘리며 농구를 즐기는 최고의 스포츠 크루입니다.',
        'image': 'assets/images/logo-orange.png',
        'banner': 'assets/images/banner3.png',
      },
      {
        'title': '체육과',
        'category': '스포츠',
        'status': '모집완료',
        'desc': '다양한 구기 종목과 신체 활동을 통해 건강을 다지는 모임입니다.',
        'image': 'assets/images/cube.png',
        'banner': 'assets/images/banner1.png',
      },
      {
        'title': '독서삼도',
        'category': '학술',
        'status': '모집중',
        'desc': '책을 읽고 생각을 나누며 깊이 있는 대화를 나누는 독서 토론 동아리입니다.',
        'image': 'assets/images/logo-aria.png',
        'banner': 'assets/images/banner2.png',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20.0,
        title: const Text(
          '동아리 탐색',
          style: TextStyle(
            color: Color(0xFF191919),
            fontWeight: FontWeight.w800,
            fontSize: 20.0,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 검색 바 영역
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              height: 46.0,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: Color(0xFF9E9E9E),
                    size: 20.0,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '관심 있는 동아리를 검색해보세요',
                        hintStyle: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 14.0,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8.0),

          // 2. 카테고리 칩 가로 스크롤 영역
          SizedBox(
            height: 40.0,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8.0),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedCategory == category;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF8CC63F)
                          : const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF757575),
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12.0),

          // 3. 동아리 카드 목록 영역
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              itemCount: clubs.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 20.0),
              itemBuilder: (context, index) {
                final club = clubs[index];
                final isRecruiting = club['status'] == '모집중';

                return Container(
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
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20.0),
                        ),
                        child: Image.asset(
                          club['banner'] as String,
                          height: 140.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 140.0,
                                color: const Color(0xFFE8F5E9),
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    color: Color(0xFF8CC63F),
                                    size: 32,
                                  ),
                                ),
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.asset(
                                club['image'] as String,
                                width: 44.0,
                                height: 44.0,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 44.0,
                                      height: 44.0,
                                      color: const Color(0xFFF1F8E9),
                                      child: const Center(
                                        child: Icon(
                                          Icons.group,
                                          color: Color(0xFF8CC63F),
                                          size: 20,
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
                                  Row(
                                    children: [
                                      Text(
                                        club['title'] as String,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF191919),
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0,
                                          vertical: 2.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isRecruiting
                                              ? const Color(0xFFF1F8E9)
                                              : const Color(0xFFF5F5F5),
                                          borderRadius: BorderRadius.circular(
                                            4.0,
                                          ),
                                        ),
                                        child: Text(
                                          club['status'] as String,
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.bold,
                                            color: isRecruiting
                                                ? const Color(0xFF8CC63F)
                                                : const Color(0xFF9E9E9E),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    club['category'] as String,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Color(0xFF9E9E9E),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    club['desc'] as String,
                                    style: const TextStyle(
                                      fontSize: 13.0,
                                      color: Color(0xFF555555),
                                      height: 1.3,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
