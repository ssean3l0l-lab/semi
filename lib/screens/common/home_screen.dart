import 'dart:async';

import 'package:flutter/material.dart';

import '../../widgets/app_logo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _bannerPageController;
  late final Timer _bannerTimer;

  final _bannerImages = const [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
  ];

  @override
  void initState() {
    super.initState();
    _bannerPageController = PageController(
      initialPage: _bannerImages.length * 1000,
    );

    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_bannerPageController.hasClients) {
        _bannerPageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer.cancel();
    _bannerPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20.0,
        title: const Row(
          children: [
            AppLogo(size: 26.0),
            SizedBox(width: 8.0),
            Text(
              'SHINGU CLUB',
              style: TextStyle(
                color: Color(0xFF191919),
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF191919), size: 26),
            onPressed: () {},
          ),
          const SizedBox(width: 8.0),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12.0),
            _buildBannerSection(),
            const SizedBox(height: 36.0),
            _buildMyClubsSection(),
            const SizedBox(height: 36.0),
            _buildAiRecommendedSection(),
            const SizedBox(height: 36.0),
            _buildHotClubsSection(),
            const SizedBox(height: 36.0),
            _buildUrgentDeadlineSection(),
            const SizedBox(height: 48.0),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        height: 130.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: PageView.builder(
            controller: _bannerPageController,
            itemBuilder: (context, index) {
              final realIndex = index % _bannerImages.length;
              return Image.asset(
                _bannerImages[realIndex],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFDCEBC2),
                  child: Center(
                    child: Text(
                      'banner${realIndex + 1}.png',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF557722),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMyClubsSection() {
    final myClubs = [
      {
        'title': 'HelloWorld',
        'desc': '프로그래밍 기초부터 실제 앱 출시까지 함...',
        'time': '매주 수요일 18:00',
        'image': 'assets/images/logo-helloworld.png',
      },
      {
        'title': '아리아',
        'desc': '작은 나눔으로 따뜻한 변화를 만들어요',
        'time': '매주 화요일 18:00',
        'image': 'assets/images/logo-aria.png',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            '내 동아리',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w800,
              color: Color(0xFF191919),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 114.0,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            scrollDirection: Axis.horizontal,
            itemCount: myClubs.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12.0),
            itemBuilder: (context, index) {
              final club = myClubs[index];
              final title = club['title']!;
              final desc = club['desc']!;
              final time = club['time']!;
              final imagePath = club['image']!;

              return Container(
                width: 290.0,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: Image.asset(
                        imagePath,
                        width: 64.0,
                        height: 64.0,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 64.0,
                          height: 64.0,
                          color: const Color(0xFF263238),
                          child: Center(
                            child: Text(
                              '$title\npng',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF191919),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            desc,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF757575),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 13,
                                color: Color(0xFF9E9E9E),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                time,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Color(0xFF9E9E9E),
                                ),
                              ),
                            ],
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
    );
  }

  Widget _buildAiRecommendedSection() {
    final aiClubs = [
      {
        'tag': '스포츠',
        'title': 'ORANGE',
        'desc': '왼손은 거들 뿐! 🏀 당신의 숨겨진 농구 본능을 채워줄 ORANGE',
        'image': 'assets/images/orange.png',
      },
      {
        'tag': '사진 / 영상',
        'title': '오프레임 (Off-frame)',
        'desc': '찰나의 순간을 영원한 추억으로. 사진 속에서 함께 웃고 즐길 당신의...',
        'image': 'assets/images/offframe.png',
      },
      {
        'tag': '교류 / 친목',
        'title': '버디',
        'desc': '캠퍼스 안에서 떠나는 세계 여행! 외국인 친구와 우정을 만드는 곳.',
        'image': 'assets/images/buddy.png',
      },
      {
        'tag': '스포츠',
        'title': '풀코스',
        'desc': '달리는 즐거움부터 완주의 성취감까지, 러닝 크루 \'풀코스\'',
        'image': 'assets/images/fullcourse.png',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Text(
                'AI 맞춤 동아리 추천',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF191919),
                ),
              ),
              SizedBox(width: 6.0),
              Text('🧩', style: TextStyle(fontSize: 18.0)),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 234.0,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            scrollDirection: Axis.horizontal,
            itemCount: aiClubs.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14.0),
            itemBuilder: (context, index) {
              final club = aiClubs[index];
              final tag = club['tag']!;
              final title = club['title']!;
              final desc = club['desc']!;
              final imagePath = club['image']!;
              final shortTitle = title.split(' ')[0];

              return Container(
                width: 160.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16.0),
                      ),
                      child: Image.asset(
                        imagePath,
                        height: 104.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 104.0,
                          color: Color(0xFFE8F5E9 + (index * 0x1100)),
                          child: Center(
                            child: Text(
                              '$shortTitle\npng',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black38,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 3.0,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F8E9),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8CC63F),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF191919),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            desc,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF757575),
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
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHotClubsSection() {
    final hotClubs = [
      {
        'rank': '1',
        'title': '디포스 (D-Force)',
        'tag': '댄스 / 예술',
        'desc': '함께 춤추고 무대를 채우는 댄스 동아리',
        'image': 'assets/images/logo-dforce.png',
      },
      {
        'rank': '2',
        'title': 'HelloWorld',
        'tag': 'IT / 코딩',
        'desc': '코딩 기초부터 앱 개발까지 함께해요',
        'image': 'assets/images/logo-helloworld.png',
      },
      {
        'rank': '3',
        'title': '아리아 (ARIA)',
        'tag': '사회 / 봉사',
        'desc': '작은 나눔으로 따뜻한 변화를 만들어요',
        'image': 'assets/images/logo-aria.png',
      },
      {
        'rank': '4',
        'title': 'ORANGE',
        'tag': '스포츠',
        'desc': '코트 위에서 함께 뛰는 농구 동아리',
        'image': 'assets/images/logo-orange.png',
      },
      {
        'rank': '5',
        'title': '라온',
        'tag': '공연 / 예술',
        'desc': '음악과 공연으로 즐거움을 나누는 동아리',
        'image': 'assets/images/logo-laon.png',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                '지금 가장 핫한 동아리',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF191919),
                ),
              ),
              SizedBox(width: 6.0),
              Text('🔥', style: TextStyle(fontSize: 18.0)),
            ],
          ),
          const SizedBox(height: 16.0),
          Column(
            children: hotClubs.map((club) {
              final rank = club['rank']!;
              final title = club['title']!;
              final tag = club['tag']!;
              final desc = club['desc']!;
              final imagePath = club['image']!;
              final shortTitle = title.split(' ')[0];

              return Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 14.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24.0,
                      child: Text(
                        rank,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8CC63F),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        imagePath,
                        width: 48.0,
                        height: 48.0,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 48.0,
                          height: 48.0,
                          color: const Color(0xFFECEFF1),
                          child: Center(
                            child: Text(
                              '$shortTitle\npng',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 8,
                                color: Colors.black38,
                                fontWeight: FontWeight.bold,
                              ),
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
                              Flexible(
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF191919),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0,
                                  vertical: 2.0,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F8E9),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF8CC63F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            desc,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF757575),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentDeadlineSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                '모집 마감 임박',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF191919),
                ),
              ),
              SizedBox(width: 6.0),
              Text('⏰', style: TextStyle(fontSize: 18.0)),
            ],
          ),
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14.0),
                  child: Image.asset(
                    'assets/images/cube.png',
                    width: 64.0,
                    height: 64.0,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 64.0,
                      height: 64.0,
                      color: const Color(0xFFE0F2F1),
                      child: const Center(
                        child: Text(
                          'cube\npng',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF00796B),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14.0),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '학술/학회',
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        '경영/컨설팅 분석학회 \'CUBE\'',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191919),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        '모집 마감일: 10월 16일 (수)',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFFF5252)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Text(
                    'D-1',
                    style: TextStyle(
                      color: Color(0xFFFF5252),
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
