import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/club_models.dart';
import '../../widgets/app_logo.dart';
import 'banner_detail_screen.dart';
import 'club_create_request_screen.dart';
import 'club_detail_screen.dart';
import 'my_clubs_screen.dart';

typedef HomeDataMap = Map<String, dynamic>;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _bannerPageController;
  late final Timer _bannerTimer;
  int _currentBannerIndex = 0;

  final List<HomeDataMap> _bannerData = [
    {
      'type': 'banner',
      'homeImage': 'assets/images/banner1.png',
      'detailImage': 'assets/images/banner_detail1.png',
      'title': '2026 동아리 연합 축제',
      'date': '2026. 11. 3(화) 12:00-20:00',
      'location': '신구대학교 운동장 · 국제관 앞 광장',
      'participants': '중앙동아리 18팀 · 신구대생 누구나',
      'shareUrl': 'shingu.club/banner/20261103/festival',
      'tags': ['HelloWorld', '디포스', 'ORANGE', '아리아', '오프레임', '+13'],
    },
    {
      'type': 'banner',
      'homeImage': 'assets/images/banner2.png',
      'detailImage': 'assets/images/banner_detail2.png',
      'title': 'SW중심대학 연합 해커톤 2026',
      'date': '2026. 10. 29 (토) 12:00-20:00',
      'location': '신구대학교 남관 402호',
      'participants': '신구대생 누구나',
      'shareUrl': 'shingu.club/banner/20261029/hackathon',
      'tags': <String>[],
    },
    {
      'type': 'club',
      'clubId': 2,
      'isRecruiting': true,
      'homeImage': 'assets/images/banner3.png',
      'title': 'CUBE (큐브)',
      'tag': '학술',
      'desc': '경영 및 컨설팅 분석을 연구하고 실제 사례를 토론하는 학술 학회입니다.',
      'clubImage': 'assets/images/cube.png',
      'time': '매주 목요일 18:00',
      'location': '본관 405호',
    },
  ];

  void _onJoinedClubsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    MyClubsScreen.clubsNotifier.addListener(_onJoinedClubsChanged);

    _bannerPageController = PageController(
      initialPage: _bannerData.length * 1000,
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
    MyClubsScreen.clubsNotifier.removeListener(_onJoinedClubsChanged);
    _bannerTimer.cancel();
    _bannerPageController.dispose();
    super.dispose();
  }

  void _navigateToClubDetail(BuildContext context, HomeDataMap club) {
    final int clubId = club['clubId'] as int? ?? 1;
    final String clubName =
        (club['clubName'] ?? club['title'])?.toString() ?? '동아리';
    final String category = club['tag']?.toString() ?? '기타';
    final String description =
        (club['description'] ?? club['desc'])?.toString() ?? '동아리 소개가 없습니다.';
    final String logoUrl =
        (club['logo'] ?? club['image'])?.toString() ??
        'assets/images/logo-helloworld.png';
    final String meetingTime =
        (club['meetingTime'] ?? club['time'])?.toString() ?? '별도 공지';
    final String location = club['location']?.toString() ?? '동아리방';
    final bool isRecruiting = club['isRecruiting'] as bool? ?? true;
    final int memberCount = club['memberCount'] as int? ?? 0;

    final initialClub = ClubModel(
      clubId: clubId,
      clubName: clubName,
      category: category,
      isRecruiting: isRecruiting,
      description: description,
      logoUrl: logoUrl,
      bannerUrl: logoUrl,
      meetingTime: meetingTime,
      location: location,
      memberCount: memberCount,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ClubDetailScreen(clubId: clubId, initialClub: initialClub),
      ),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClubCreateRequestScreen(),
                ),
              );
            },
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            height: 130.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: PageView.builder(
                controller: _bannerPageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentBannerIndex = index % _bannerData.length;
                  });
                },
                itemBuilder: (context, index) {
                  final realIndex = index % _bannerData.length;
                  final banner = _bannerData[realIndex];

                  return GestureDetector(
                    onTap: () {
                      if (banner['type'] == 'club') {
                        _navigateToClubDetail(context, {
                          'clubId': banner['clubId'],
                          'isRecruiting': banner['isRecruiting'],
                          'title': banner['title'].toString(),
                          'tag': banner['tag'].toString(),
                          'desc': banner['desc'].toString(),
                          'image': banner['clubImage'].toString(),
                          'time': banner['time'].toString(),
                          'location': banner['location'].toString(),
                        });
                      } else {
                        final tags = (banner['tags'] as List<dynamic>)
                            .map((e) => e.toString())
                            .toList();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BannerDetailScreen(
                              bannerImage: banner['detailImage'].toString(),
                              title: banner['title'].toString(),
                              date: banner['date'].toString(),
                              location: banner['location'].toString(),
                              participants: banner['participants'].toString(),
                              shareUrl: banner['shareUrl'].toString(),
                              clubTags: tags,
                            ),
                          ),
                        );
                      }
                    },
                    child: Image.asset(
                      banner['homeImage'].toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFDCEBC2),
                        child: Center(
                          child: Text(
                            banner['title'].toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF557722),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_bannerData.length, (index) {
            return Container(
              width: _currentBannerIndex == index ? 16.0 : 6.0,
              height: 6.0,
              margin: const EdgeInsets.symmetric(horizontal: 3.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: _currentBannerIndex == index
                    ? const Color(0xFF8CC63F)
                    : const Color(0xFFE0E0E0),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMyClubsSection() {
    final myClubs = MyClubsScreen.joinedClubs;

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
        if (myClubs.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: const Center(
                child: Text(
                  '가입된 동아리가 없습니다.',
                  style: TextStyle(fontSize: 13.5, color: Color(0xFF9E9E9E)),
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 114.0,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              scrollDirection: Axis.horizontal,
              itemCount: myClubs.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12.0),
              itemBuilder: (context, index) {
                final club = myClubs[index];
                final String clubName = club['clubName'].toString();
                final String description = club['description'].toString();
                final String meetingTime = club['meetingTime'].toString();
                final String logo = club['logo'].toString();

                return GestureDetector(
                  onTap: () => _navigateToClubDetail(context, club),
                  child: Container(
                    width: 290.0,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
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
                            logo,
                            width: 64.0,
                            height: 64.0,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 64.0,
                                  height: 64.0,
                                  color: const Color(0xFF263238),
                                  child: Center(
                                    child: Text(
                                      clubName,
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
                                clubName,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF191919),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                description,
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
                                    meetingTime,
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
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildAiRecommendedSection() {
    final List<HomeDataMap> aiClubs = [
      {
        'clubId': 5,
        'isRecruiting': true,
        'tag': '체육/스포츠',
        'title': 'ORANGE',
        'desc': '왼손은 거들 뿐! 당신의 숨겨진 농구 본능을 채워줄 ORANGE',
        'image': 'assets/images/orange.png',
        'time': '매주 수요일 19:00',
        'location': '대운동장 농구코트',
      },
      {
        'clubId': 9,
        'isRecruiting': true,
        'tag': '문화/예술',
        'title': '오프레임 (Off-frame)',
        'desc': '찰나의 순간을 영원한 추억으로. 사진 속에서 함께 웃고 즐길 당신의 공간',
        'image': 'assets/images/offframe.png',
        'time': '격주 금요일 17:30',
        'location': '디자인관 204호',
      },
      {
        'clubId': 10,
        'isRecruiting': true,
        'tag': '문화/예술',
        'title': '버디',
        'desc': '캠퍼스 안에서 떠나는 세계 여행! 외국인 친구와 우정을 만드는 곳.',
        'image': 'assets/images/buddy.png',
        'time': '매주 금요일 17:00',
        'location': '학생회관 305호',
      },
      {
        'clubId': 6,
        'isRecruiting': true,
        'tag': '체육/스포츠',
        'title': '풀코스',
        'desc': '달리는 즐거움부터 완주의 성취감까지, 러닝 크루 풀코스',
        'image': 'assets/images/fullcourse.png',
        'time': '매주 목요일 19:30',
        'location': '탄천 러닝 코스',
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

              return GestureDetector(
                onTap: () => _navigateToClubDetail(context, club),
                child: Container(
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
                          club['image'].toString(),
                          height: 104.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 104.0,
                                color: Color(0xFFE8F5E9 + (index * 0x1100)),
                                child: Center(
                                  child: Text(
                                    club['title'].toString(),
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
                                club['tag'].toString(),
                                style: const TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8CC63F),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            Text(
                              club['title'].toString(),
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
                              club['desc'].toString(),
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHotClubsSection() {
    final List<HomeDataMap> hotClubs = [
      {
        'clubId': 7,
        'isRecruiting': true,
        'rank': '1',
        'title': '디포스 (D-Force)',
        'tag': '문화/예술',
        'desc': '함께 춤추고 무대를 채우는 댄스 동아리',
        'image': 'assets/images/logo-dforce.png',
        'time': '매주 화·목 18:00',
        'location': '학생회관 연습실',
      },
      {
        'clubId': 1,
        'isRecruiting': true,
        'rank': '2',
        'title': 'HelloWorld',
        'tag': '학술',
        'desc': '코딩 기초부터 앱 개발까지 함께해요',
        'image': 'assets/images/logo-helloworld.png',
        'time': '매주 수요일 18:00',
        'location': '학관 302호',
      },
      {
        'clubId': 12,
        'isRecruiting': true,
        'rank': '3',
        'title': '아리아 (ARIA)',
        'tag': '사회/봉사',
        'desc': '작은 나눔으로 따뜻한 변화를 만들어요',
        'image': 'assets/images/logo-aria.png',
        'time': '격주 토요일 10:00',
        'location': '성남시 지역 봉사센터',
      },
      {
        'clubId': 5,
        'isRecruiting': true,
        'rank': '4',
        'title': 'ORANGE',
        'tag': '체육/스포츠',
        'desc': '코트 위에서 함께 뛰는 농구 동아리',
        'image': 'assets/images/logo-orange.png',
        'time': '매주 수요일 19:00',
        'location': '대운동장 농구코트',
      },
      {
        'clubId': 11,
        'isRecruiting': false,
        'rank': '5',
        'title': '라온',
        'tag': '문화/예술',
        'desc': '음악과 공연으로 즐거움을 나누는 동아리',
        'image': 'assets/images/logo-laon.png',
        'time': '매주 수요일 18:30',
        'location': '음악 연습실',
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
              return GestureDetector(
                onTap: () => _navigateToClubDetail(context, club),
                child: Container(
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
                        color: Colors.black.withValues(alpha: 0.01),
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
                          club['rank'].toString(),
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
                          club['image'].toString(),
                          width: 48.0,
                          height: 48.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 48.0,
                                height: 48.0,
                                color: const Color(0xFFECEFF1),
                                child: Center(
                                  child: Text(
                                    club['title'].toString(),
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
                                    club['title'].toString(),
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
                                    club['tag'].toString(),
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
                              club['desc'].toString(),
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
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentDeadlineSection() {
    final HomeDataMap cubeClub = {
      'clubId': 2,
      'isRecruiting': true,
      'title': 'CUBE (큐브)',
      'tag': '학술',
      'desc': '경영 및 컨설팅 분석을 연구하고 실제 사례를 토론하는 학술 학회입니다.',
      'image': 'assets/images/cube.png',
      'time': '매주 목요일 18:00',
      'location': '본관 405호',
    };

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
          GestureDetector(
            onTap: () => _navigateToClubDetail(context, cubeClub),
            child: Container(
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
                      cubeClub['image'].toString(),
                      width: 64.0,
                      height: 64.0,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 64.0,
                        height: 64.0,
                        color: const Color(0xFFE0F2F1),
                        child: const Center(
                          child: Text(
                            'cube',
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cubeClub['tag'].toString(),
                          style: const TextStyle(
                            fontSize: 11.0,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          cubeClub['desc'].toString(),
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF191919),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        const Text(
                          '모집 마감일: 3월 20일',
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
          ),
        ],
      ),
    );
  }
}
