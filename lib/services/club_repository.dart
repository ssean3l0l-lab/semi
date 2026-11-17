import '../models/club_models.dart';
import '../screens/common/my_clubs_screen.dart';

typedef ClubList = List<ClubModel>;
typedef BoardSummaryList = List<BoardSummaryModel>;

class ClubRepository {
  ClubRepository._();
  static final ClubRepository instance = ClubRepository._();

  Set<int> get joinedClubIds {
    return MyClubsScreen.joinedClubs
        .map((club) => club['clubId'] as int? ?? 0)
        .where((id) => id != 0)
        .toSet();
  }

  bool isClubJoined(int clubId) {
    return joinedClubIds.contains(clubId);
  }

  Future<ClubList> fetchClubs() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _mockClubs;
  }

  Future<ClubModel> fetchClubDetail(int clubId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _mockClubs.firstWhere(
      (club) => club.clubId == clubId,
      orElse: () => _mockClubs.first,
    );
  }

  Future<BoardSummaryList> fetchAllBoardSummaries() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _allBoardSummaries;
  }

  Future<BoardSummaryList> fetchMyBoardSummaries() async {
    await Future.delayed(const Duration(milliseconds: 150));
    final currentJoinedIds = joinedClubIds;
    return _allBoardSummaries
        .where((board) => currentJoinedIds.contains(board.clubId))
        .toList();
  }

  static const BoardSummaryList _allBoardSummaries = [
    BoardSummaryModel(
      clubId: 1,
      clubName: 'HelloWorld',
      category: '학술',
      memberCount: 57,
      logoUrl: 'assets/images/logo-helloworld.png',
      newPostCount: 3,
      recentPosts: [
        BoardPostPreviewModel(
          postId: 101,
          title: '이번 주 금요일 실시간 백엔드 코딩 세션 공지',
          timeAgo: '10분 전',
        ),
        BoardPostPreviewModel(
          postId: 102,
          title: '2026년도 연합 IT 프로젝트 디자인 시안 피드백 요청',
          timeAgo: '1시간 전',
        ),
      ],
    ),
    BoardSummaryModel(
      clubId: 2,
      clubName: 'CUBE (큐브)',
      category: '학술',
      memberCount: 28,
      logoUrl: 'assets/images/logo-cube.png',
      newPostCount: 2,
      recentPosts: [
        BoardPostPreviewModel(
          postId: 201,
          title: '이번 주 비즈니스 케이스 스터디 발제 자료 공유',
          timeAgo: '35분 전',
        ),
        BoardPostPreviewModel(
          postId: 202,
          title: '하반기 산학 연계 마케팅 공모전 팀 빌딩 안내',
          timeAgo: '3시간 전',
        ),
      ],
    ),
    BoardSummaryModel(
      clubId: 3,
      clubName: '오름',
      category: '체육/스포츠',
      memberCount: 31,
      logoUrl: 'assets/images/logo-oleum.png',
      newPostCount: 1,
      recentPosts: [
        BoardPostPreviewModel(
          postId: 301,
          title: '이번 주 토요일 남한산성 정기 산행 집결 장소 공지',
          timeAgo: '2시간 전',
        ),
        BoardPostPreviewModel(
          postId: 302,
          title: '등산화 및 보온 의류 준비물 체크리스트 안내',
          timeAgo: '1일 전',
        ),
      ],
    ),
    BoardSummaryModel(
      clubId: 4,
      clubName: '픽셀 (Pixel)',
      category: '체육/스포츠',
      memberCount: 40,
      logoUrl: 'assets/images/logo-pixel.png',
      newPostCount: 4,
      recentPosts: [
        BoardPostPreviewModel(
          postId: 401,
          title: '교내 e스포츠 친선 대진표 및 경기 일정 확정',
          timeAgo: '25분 전',
        ),
        BoardPostPreviewModel(
          postId: 402,
          title: '금요일 풋살·배드민턴 번개 모임 참여 인원 조사',
          timeAgo: '5시간 전',
        ),
      ],
    ),
    BoardSummaryModel(
      clubId: 5,
      clubName: 'ORANGE',
      category: '체육/스포츠',
      memberCount: 35,
      logoUrl: 'assets/images/logo-orange.png',
      newPostCount: 2,
      recentPosts: [
        BoardPostPreviewModel(
          postId: 501,
          title: '수요일 대운동장 농구코트 5:5 자체 청백전 로스터',
          timeAgo: '40분 전',
        ),
        BoardPostPreviewModel(
          postId: 502,
          title: '인근 대학 농구 동아리 교류전 유니폼 사이즈 조사',
          timeAgo: '6시간 전',
        ),
      ],
    ),
    BoardSummaryModel(
      clubId: 6,
      clubName: '풀코스',
      category: '체육/스포츠',
      memberCount: 42,
      logoUrl: 'assets/images/logo-fullcourse.png',
      newPostCount: 3,
      recentPosts: [
        BoardPostPreviewModel(
          postId: 601,
          title: '목요일 탄천 야간 러닝 페이스별 그룹 편성표',
          timeAgo: '15분 전',
        ),
        BoardPostPreviewModel(
          postId: 602,
          title: '성남 시민 마라톤 10km 단체 접수 마감 임박 안내',
          timeAgo: '4시간 전',
        ),
      ],
    ),
    BoardSummaryModel(
      clubId: 7,
      clubName: '디포스 (D-Force)',
      category: '문화/예술',
      memberCount: 45,
      logoUrl: 'assets/images/logo-dforce.png',
      newPostCount: 5,
      recentPosts: [
        BoardPostPreviewModel(
          postId: 701,
          title: '대학 축제 무대 엔딩 곡 안무 동선 최종 수정본',
          timeAgo: '12분 전',
        ),
        BoardPostPreviewModel(
          postId: 702,
          title: '이번 주 연습실 대관 시간표 및 팀별 연습 배정',
          timeAgo: '2시간 전',
        ),
      ],
    ),
    BoardSummaryModel(
      clubId: 8,
      clubName: '독서삼도',
      category: '문화/예술',
      memberCount: 22,
      logoUrl: 'assets/images/logo-dokseosamdo.png',
      newPostCount: 1,
      recentPosts: [
        BoardPostPreviewModel(
          postId: 801,
          title: '11월 둘째 주 지정 도서 및 토론 발제문 공유',
          timeAgo: '3시간 전',
        ),
        BoardPostPreviewModel(
          postId: 802,
          title: '연말 독서 에세이 문집 원고 제출 마감일 안내',
          timeAgo: '1일 전',
        ),
      ],
    ),
    BoardSummaryModel(
      clubId: 9,
      clubName: '오프레임 (Off-frame)',
      category: '문화/예술',
      memberCount: 34,
      logoUrl: 'assets/images/logo-offframe.png',
      newPostCount: 2,
      recentPosts: [
        BoardPostPreviewModel(
          postId: 901,
          title: '이번 주 금요일 야간 캠퍼스 스냅 출사 장소 공지',
          timeAgo: '20분 전',
        ),
        BoardPostPreviewModel(
          postId: 902,
          title: '교내 정기 사진전 출품작 보정본 제출 안내',
          timeAgo: '3시간 전',
        ),
      ],
    ),
    BoardSummaryModel(
      clubId: 10,
      clubName: '버디',
      category: '문화/예술',
      memberCount: 29,
      logoUrl: 'assets/images/logo-buddy.png',
      newPostCount: 2,
      recentPosts: [
        BoardPostPreviewModel(
          postId: 1001,
          title: '주말 성수동 전시회 단체 관람 예매 인원 확인',
          timeAgo: '50분 전',
        ),
        BoardPostPreviewModel(
          postId: 1002,
          title: '11월 문화 교류 네트워킹 데이 조 편성 안내',
          timeAgo: '7시간 전',
        ),
      ],
    ),
    BoardSummaryModel(
      clubId: 11,
      clubName: '라온',
      category: '문화/예술',
      memberCount: 33,
      logoUrl: 'assets/images/logo-laon.png',
      newPostCount: 3,
      recentPosts: [
        BoardPostPreviewModel(
          postId: 1101,
          title: '정기 공연 셋리스트 확정 및 세션별 합주 일정',
          timeAgo: '30분 전',
        ),
        BoardPostPreviewModel(
          postId: 1102,
          title: '지하 합주실 앰프·드럼 장비 점검 및 사용 수칙',
          timeAgo: '5시간 전',
        ),
      ],
    ),
    BoardSummaryModel(
      clubId: 12,
      clubName: '아리아 (ARIA)',
      category: '사회/봉사',
      memberCount: 26,
      logoUrl: 'assets/images/logo-aria.png',
      newPostCount: 2,
      recentPosts: [
        BoardPostPreviewModel(
          postId: 1201,
          title: '주말 독거노인 급식 봉사 차량 지원 인원 구합니다',
          timeAgo: '18시간 전',
        ),
        BoardPostPreviewModel(
          postId: 1202,
          title: '봉사활동 시간 1365 등록 대장 확인 요청',
          timeAgo: '2일 전',
        ),
      ],
    ),
  ];

  static final ClubList _mockClubs = [
    ClubModel(
      clubId: 1,
      clubName: 'HelloWorld',
      category: '학술',
      isRecruiting: true,
      recruitDeadline: DateTime(2026, 3, 15),
      description:
          '프로그래밍 기초부터 실제 웹·모바일 서비스를 출시하는 신구대학교 개발 동아리입니다. 함께 배우고, 만들고, 성장해요.',
      logoUrl: 'assets/images/logo-helloworld.png',
      bannerUrl: 'assets/images/helloworld.png',
      meetingTime: '매주 수요일 18:00',
      location: '학관 302호',
      memberCount: 57,
      activities: const [
        '프로그래밍 언어 문법 학습',
        '해커톤, 코딩 경진대회 참가',
        '웹사이트, 애플리케이션 제작',
      ],
      faqs: const [
        ClubFaqModel(
          faqId: 101,
          question: '프로그래밍을 전혀 모르는 신입생도 지원할 수 있나요?',
          answer: '네, 가능합니다. 기초 문법부터 시작해 함께 성장할 수 있도록 구성되어 있으며, 기초 학습 시간을 통해 빠르게 따라올 수 있습니다.',
        ),
        ClubFaqModel(
          faqId: 102,
          question: '해커톤과 경진대회는 필수 참여인가요?',
          answer: '필수는 아니지만, 관심 있는 팀원과 함께 참여할 수 있습니다. 운영진이 준비와 제출까지 함께 도와드립니다.',
        ),
      ],
    ),
    ClubModel(
      clubId: 2,
      clubName: 'CUBE (큐브)',
      category: '학술',
      isRecruiting: true,
      recruitDeadline: DateTime(2026, 3, 20),
      description: '경영 및 컨설팅 분석을 연구하고 실제 사례를 토론하는 학술 학회입니다.',
      logoUrl: 'assets/images/logo-cube.png',
      bannerUrl: 'assets/images/cube.png',
      meetingTime: '매주 목요일 18:00',
      location: '본관 405호',
      memberCount: 28,
      activities: const ['비즈니스 케이스 스터디', '산학 공모전 참가'],
      faqs: const [
        ClubFaqModel(
          faqId: 201,
          question: '경영학과가 아닌 타 전공 학생도 가입할 수 있나요?',
          answer: '네, 전공과 무관하게 비즈니스 분석과 전략 기획에 관심이 있다면 누구나 환영합니다.',
        ),
        ClubFaqModel(
          faqId: 202,
          question: '발표나 케이스 스터디 준비 난이도가 높은 편인가요?',
          answer: '초반에는 선배 기수와 한 팀이 되어 자료 조사부터 장표 작성까지 함께 배우며 진행하므로 부담 없이 참여할 수 있습니다.',
        ),
      ],
    ),
    ClubModel(
      clubId: 3,
      clubName: '오름',
      category: '체육/스포츠',
      isRecruiting: true,
      recruitDeadline: DateTime(2026, 3, 18),
      description: '캠퍼스 내외에서 등산과 트레킹을 즐기며 체력을 단련하는 모임입니다.',
      logoUrl: 'assets/images/logo-oleum.png',
      bannerUrl: 'assets/images/oleum.png',
      meetingTime: '격주 토요일 09:00',
      location: '남한산성 및 인근 산행지',
      memberCount: 31,
      activities: const ['정기 주말 산행', '친목 트레킹 캠프'],
      faqs: const [
        ClubFaqModel(
          faqId: 301,
          question: '등산 초보자도 따라갈 수 있는 코스로 진행하나요?',
          answer:
              '네, 난이도 하~중 수준의 둘레길과 근교 산행 위주로 코스를 선정하며, 체력에 맞춰 후미 인솔자를 배치합니다.',
        ),
        ClubFaqModel(
          faqId: 302,
          question: '전문 등산 장비가 꼭 있어야 하나요?',
          answer: '일반 산행은 운동화와 편한 복장만으로도 충분하며, 장거리 산행 시 필요한 장비는 사전에 안내해 드립니다.',
        ),
      ],
    ),
    ClubModel(
      clubId: 4,
      clubName: '픽셀 (Pixel)',
      category: '체육/스포츠',
      isRecruiting: false,
      description: '다양한 스포츠 활동과 e스포츠 대회를 아우르는 활동적인 동아리입니다.',
      logoUrl: 'assets/images/logo-pixel.png',
      bannerUrl: 'assets/images/pixel.png',
      meetingTime: '매주 화요일 18:30',
      location: '학생회관 201호',
      memberCount: 40,
      activities: const ['교내 e스포츠 대회 개최', '친선 스포츠 매치'],
      faqs: const [
        ClubFaqModel(
          faqId: 401,
          question: 'e스포츠와 야외 스포츠 중 한 분야만 참여해도 되나요?',
          answer: '네, 본인이 희망하는 종목 세션만 선택해 자유롭게 참여하실 수 있습니다.',
        ),
        ClubFaqModel(
          faqId: 402,
          question: '다음 추가 모집은 언제 진행되나요?',
          answer: '매 학기 초 정기 모집 외에 결원 발생 시 공지사항을 통해 추가 모집을 진행합니다.',
        ),
      ],
    ),
    ClubModel(
      clubId: 5,
      clubName: 'ORANGE',
      category: '체육/스포츠',
      isRecruiting: true,
      recruitDeadline: DateTime(2026, 3, 22),
      description: '코트 위에서 땀 흘리며 농구를 즐기는 최고의 농구 스포츠 크루입니다.',
      logoUrl: 'assets/images/logo-orange.png',
      bannerUrl: 'assets/images/orange.png',
      meetingTime: '매주 수요일 19:00',
      location: '대운동장 농구코트',
      memberCount: 35,
      activities: const ['정기 5:5 농구 연습', '대학 농구 교류전'],
      faqs: const [
        ClubFaqModel(
          faqId: 501,
          question: '농구 규칙을 잘 모르거나 실력이 부족해도 지원 가능한가요?',
          answer: '물론입니다. 기본 드리블과 슛 연습부터 함께 진행하므로 농구를 좋아하는 열정만 있다면 누구나 환영합니다.',
        ),
        ClubFaqModel(
          faqId: 502,
          question: '매니저로도 지원할 수 있나요?',
          answer: '네, 경기 기록과 촬영, 교류전 운영을 함께할 매니저 부원도 상시 모집하고 있습니다.',
        ),
      ],
    ),
    ClubModel(
      clubId: 6,
      clubName: '풀코스',
      category: '체육/스포츠',
      isRecruiting: true,
      recruitDeadline: DateTime(2026, 3, 25),
      description: '달리는 즐거움부터 마라톤 완주의 성취감까지 함께하는 러닝 크루입니다.',
      logoUrl: 'assets/images/logo-fullcourse.png',
      bannerUrl: 'assets/images/fullcourse.png',
      meetingTime: '매주 목요일 19:30',
      location: '탄천 러닝 코스',
      memberCount: 42,
      activities: const ['야간 그룹 러닝', '10km·하프 마라톤 대회 참가'],
      faqs: const [
        ClubFaqModel(
          faqId: 601,
          question: '3km도 쉬지 않고 뛰기 힘든데 참여할 수 있을까요?',
          answer:
              '입문자 그룹(걷뛰·조깅 반)과 중급자 그룹으로 나누어 달리므로 본인의 체력에 맞춰 안전하게 러닝할 수 있습니다.',
        ),
        ClubFaqModel(
          faqId: 602,
          question: '마라톤 대회 참가비는 지원되나요?',
          answer: '동아리 회비 예산 내에서 단체 참가비 일부를 지원하며, 완주 메달과 기념 티셔츠도 함께 맞춥니다.',
        ),
      ],
    ),
    ClubModel(
      clubId: 7,
      clubName: '디포스 (D-Force)',
      category: '문화/예술',
      isRecruiting: true,
      recruitDeadline: DateTime(2026, 3, 19),
      description: '함께 춤추고 무대를 채우는 열정 넘치는 댄스 및 공연 예술 동아리입니다.',
      logoUrl: 'assets/images/logo-dforce.png',
      bannerUrl: 'assets/images/dforce.png',
      meetingTime: '매주 화·목 18:00',
      location: '학생회관 연습실',
      memberCount: 45,
      activities: const ['축제 및 버스킹 무대 공연', '장르별 안무 창작 및 커버'],
      faqs: const [
        ClubFaqModel(
          faqId: 701,
          question: '춤을 처음 배워보는 사람도 오디션을 보나요?',
          answer:
              '간단한 리듬감과 열정을 확인하는 자리일 뿐이며, 기본기 트레이닝을 통해 누구나 무대에 설 수 있도록 도와드립니다.',
        ),
        ClubFaqModel(
          faqId: 702,
          question: '시험 기간에도 정기 연습을 진행하나요?',
          answer: '중간·기말고사 2주 전부터는 공식 연습을 중단하여 학업에 집중할 수 있도록 배려하고 있습니다.',
        ),
      ],
    ),
    ClubModel(
      clubId: 8,
      clubName: '독서삼도',
      category: '문화/예술',
      isRecruiting: true,
      recruitDeadline: DateTime(2026, 3, 21),
      description: '책을 읽고 생각을 나누며 깊이 있는 문학과 인문학적 대화를 나누는 모임입니다.',
      logoUrl: 'assets/images/logo-dokseosamdo.png',
      bannerUrl: 'assets/images/dokseosamdo.png',
      meetingTime: '격주 수요일 17:30',
      location: '도서관 스터디룸',
      memberCount: 22,
      activities: const ['격주 지정 도서 토론', '독서 에세이 공유'],
      faqs: const [
        ClubFaqModel(
          faqId: 801,
          question: '토론 도서는 어떤 장르 위주로 선정되나요?',
          answer: '소설, 인문, 사회과학, 에세이 등 부원들의 투표를 통해 매달 다양한 분야의 도서를 균형 있게 선정합니다.',
        ),
        ClubFaqModel(
          faqId: 802,
          question: '책을 끝까지 다 읽지 못했을 때도 모임에 참석할 수 있나요?',
          answer: '네, 읽은 부분까지의 감상만 나누어도 충분하며 편한 분위기에서 대화를 이어갑니다.',
        ),
      ],
    ),
    ClubModel(
      clubId: 9,
      clubName: '오프레임 (Off-frame)',
      category: '문화/예술',
      isRecruiting: true,
      recruitDeadline: DateTime(2026, 3, 17),
      description: '찰나의 순간을 사진과 영상으로 기록하며 추억을 만드는 미디어 동아리입니다.',
      logoUrl: 'assets/images/logo-offframe.png',
      bannerUrl: 'assets/images/offframe.png',
      meetingTime: '격주 금요일 17:30',
      location: '디자인관 204호',
      memberCount: 34,
      activities: const ['정기 출사 및 사진 보정 스터디', '교내 사진전 개최'],
      faqs: const [
        ClubFaqModel(
          faqId: 901,
          question: 'DSLR이나 미러리스 카메라가 없어도 가입할 수 있나요?',
          answer: '네, 스마트폰 카메라로도 충분히 참여 가능하며 동아리 공용 카메라 대여 및 촬영 기초 강의를 제공합니다.',
        ),
        ClubFaqModel(
          faqId: 902,
          question: '사진 보정이나 영상 편집 프로그램을 다룰 줄 몰라도 되나요?',
          answer: '라이트룸과 프리미어 프로 기초 세션을 정기적으로 진행하므로 처음 접하는 분도 쉽게 익힐 수 있습니다.',
        ),
      ],
    ),
    ClubModel(
      clubId: 10,
      clubName: '버디',
      category: '문화/예술',
      isRecruiting: true,
      recruitDeadline: DateTime(2026, 3, 24),
      description: '문화 교류와 친목을 다지며 다양한 예술적 경험을 공유하는 곳입니다.',
      logoUrl: 'assets/images/logo-buddy.png',
      bannerUrl: 'assets/images/buddy.png',
      meetingTime: '매주 금요일 17:00',
      location: '학생회관 305호',
      memberCount: 29,
      activities: const ['전시회 및 공연 단체 관람', '문화 교류 네트워킹'],
      faqs: const [
        ClubFaqModel(
          faqId: 1001,
          question: '외국어를 잘 못해도 문화 교류 활동에 참여할 수 있나요?',
          answer:
              '네, 한국인 학생과 유학생이 조를 이루어 활동하므로 언어 실력보다 열린 마음으로 소통하는 자세가 중요합니다.',
        ),
        ClubFaqModel(
          faqId: 1002,
          question: '전시회나 문화 체험 비용은 어떻게 처리되나요?',
          answer: '학생 단체 할인과 동아리 지원금을 활용해 개인 부담을 최소화하여 운영하고 있습니다.',
        ),
      ],
    ),
    ClubModel(
      clubId: 11,
      clubName: '라온',
      category: '문화/예술',
      isRecruiting: false,
      description: '음악과 악기 연주를 사랑하는 사람들이 모여 아름다운 선율을 나눕니다.',
      logoUrl: 'assets/images/logo-laon.png',
      bannerUrl: 'assets/images/laon.png',
      meetingTime: '매주 수요일 18:30',
      location: '음악 연습실',
      memberCount: 33,
      activities: const ['밴드 합주 및 정기 공연', '어쿠스틱 버스킹'],
      faqs: const [
        ClubFaqModel(
          faqId: 1101,
          question: '개인 악기가 없어도 합주실 장비를 사용할 수 있나요?',
          answer:
              '네, 합주실에 구비된 드럼, 키보드, 일렉·베이스 기타 및 앰프를 부원 누구나 자유롭게 이용할 수 있습니다.',
        ),
        ClubFaqModel(
          faqId: 1102,
          question: '보컬과 악기 세션 중 중복 지원도 가능한가요?',
          answer: '네, 지원서에 주력 파트와 서브 파트를 함께 기재해 주시면 팀 구성 시 반영해 드립니다.',
        ),
      ],
    ),
    ClubModel(
      clubId: 12,
      clubName: '아리아 (ARIA)',
      category: '사회/봉사',
      isRecruiting: true,
      recruitDeadline: DateTime(2026, 3, 26),
      description: '작은 나눔과 따뜻한 손길로 지역 사회에 선한 영향력을 전파하는 봉사 동아리입니다.',
      logoUrl: 'assets/images/logo-aria.png',
      bannerUrl: 'assets/images/aria.png',
      meetingTime: '격주 토요일 10:00',
      location: '성남시 지역 봉사센터',
      memberCount: 26,
      activities: const ['지역 사회 정기 봉사활동', '1365 봉사시간 인증 프로그램'],
      faqs: const [
        ClubFaqModel(
          faqId: 1201,
          question: '봉사활동 시간은 1365나 VMS로 공식 인정되나요?',
          answer: '네, 모든 정기 봉사활동은 성남시 자원봉사센터와 연계되어 1365 포털에 공식 봉사시간으로 등록됩니다.',
        ),
        ClubFaqModel(
          faqId: 1202,
          question: '매주 토요일 봉사에 모두 참여해야 하나요?',
          answer:
              '격주로 진행되는 봉사 일정 중 월 1회 이상 참여를 권장하며, 개인 일정에 맞춰 유연하게 신청할 수 있습니다.',
        ),
      ],
    ),
  ];
}
