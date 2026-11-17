import 'package:flutter/material.dart';

import '../../config/app_role.dart';
import '../../models/club_models.dart';
import 'club_board_screen.dart';
import 'club_detail_screen.dart';

typedef ClubItemMap = Map<String, dynamic>;

class ClubsNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

class MyClubsScreen extends StatefulWidget {
  final bool? isPresident;

  static final ClubsNotifier clubsNotifier = ClubsNotifier();

  // 홈, 마이 페이지, 게시판 화면과 공유되는 가입 동아리 목록
  static final List<ClubItemMap> joinedClubs = [
    {
      'clubId': 1,
      'isRecruiting': true,
      'clubName': 'HelloWorld',
      'tag': '학술',
      'meetingTime': '매주 수요일 18:00',
      'location': '학관 302호',
      'logo': 'assets/images/logo-helloworld.png',
      'description':
          '프로그래밍 기초부터 실제 웹·모바일 서비스를 출시하는 신구대학교 개발 동아리입니다. 함께 배우고, 만들고, 성장해요.',
      'memberCount': 57,
    },
    {
      'clubId': 9,
      'isRecruiting': true,
      'clubName': '오프레임 (Off-frame)',
      'tag': '문화/예술',
      'meetingTime': '격주 금요일 17:30',
      'location': '디자인관 204호',
      'logo': 'assets/images/logo-offframe.png',
      'description':
          '일상의 순간을 사진과 영상으로 기록하고 전시회와 단편 영화 제작을 함께 진행하는 사진·영상 동아리입니다.',
      'memberCount': 34,
    },
  ];

  const MyClubsScreen({super.key, this.isPresident});

  @override
  State<MyClubsScreen> createState() => _MyClubsScreenState();
}

class _MyClubsScreenState extends State<MyClubsScreen> {
  List<ClubItemMap> get _myClubs => MyClubsScreen.joinedClubs;

  bool get _effectiveIsPresident {
    return widget.isPresident ?? AppRole.isPresident;
  }

  void _showWithdrawConfirmAlert(
    BuildContext reasonDialogContext,
    int index,
    String clubName,
  ) {
    showDialog(
      context: reasonDialogContext,
      barrierDismissible: false,
      builder: (alertContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          title: const Text(
            '동아리 탈퇴',
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF191919),
            ),
          ),
          content: Text(
            '$clubName 동아리에서 정말로 탈퇴하시겠습니까?',
            style: const TextStyle(fontSize: 14.0, color: Color(0xFF555555)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(alertContext),
              child: const Text(
                '취소',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(alertContext);
                Navigator.pop(reasonDialogContext);
                setState(() {
                  _myClubs.removeAt(index);
                });
                MyClubsScreen.clubsNotifier.notify();
              },
              child: const Text(
                '탈퇴하기',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0xFFEF4444),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showWithdrawDialog(int index, String clubName) {
    final List<String> reasons = [
      '동아리 활동이 더 이상 맞지 않아요',
      '시간이 맞지 않아요',
      '다른 동아리에 참여하고 싶어요',
      '기타',
    ];
    int selectedReasonIndex = 0;
    bool isInputError = false;
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final bool isOtherSelected = selectedReasonIndex == 3;

            return Dialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22.0, 24.0, 22.0, 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '탈퇴 사유를 알려주세요',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF191919),
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    const Text(
                      '향후 개선에 참고할게요.',
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(height: 18.0),

                    ...List.generate(reasons.length, (i) {
                      final bool isSelected = selectedReasonIndex == i;
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            selectedReasonIndex = i;
                            if (selectedReasonIndex != 3) {
                              isInputError = false;
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14.0,
                            vertical: 13.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF8CC63F)
                                  : const Color(0xFFEEEEEE),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20.0,
                                height: 20.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF8CC63F)
                                        : const Color(0xFFCBD5E1),
                                    width: 1.8,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: isSelected
                                    ? Container(
                                        width: 10.0,
                                        height: 10.0,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF8CC63F),
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Text(
                                  reasons[i],
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF191919),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    if (isOtherSelected) ...[
                      const SizedBox(height: 4.0),
                      const Text(
                        '직접 입력',
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        height: 92.0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: isInputError
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFEEEEEE),
                            width: isInputError ? 1.5 : 1.0,
                          ),
                        ),
                        child: TextField(
                          controller: reasonController,
                          maxLines: 3,
                          onChanged: (value) {
                            if (isInputError && value.trim().isNotEmpty) {
                              setDialogState(() {
                                isInputError = false;
                              });
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: '탈퇴 사유를 자유롭게 입력해 주세요.',
                            hintStyle: TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF9E9E9E),
                            ),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(fontSize: 13.0),
                        ),
                      ),
                    ],
                    const SizedBox(height: 18.0),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 46.0,
                            child: OutlinedButton(
                              onPressed: () {
                                _showWithdrawConfirmAlert(
                                  dialogContext,
                                  index,
                                  clubName,
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF555555),
                                side: const BorderSide(
                                  color: Color(0xFFE0E0E0),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: const Text(
                                '건너뛰기',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: SizedBox(
                            height: 46.0,
                            child: ElevatedButton(
                              onPressed: () {
                                if (isOtherSelected &&
                                    reasonController.text.trim().isEmpty) {
                                  setDialogState(() {
                                    isInputError = true;
                                  });
                                  return;
                                }

                                _showWithdrawConfirmAlert(
                                  dialogContext,
                                  index,
                                  clubName,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8CC63F),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: const Text(
                                '확인',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isPresident = _effectiveIsPresident;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
        title: const Text(
          '내 동아리',
          style: TextStyle(
            color: Color(0xFF191919),
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFEEEEEE), height: 1.0),
        ),
      ),
      body: _myClubs.isEmpty
          ? const Center(
              child: Text(
                '가입된 동아리가 없습니다.',
                style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14.0),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20.0),
              itemCount: _myClubs.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 16.0),
              itemBuilder: (context, index) {
                final club = _myClubs[index];
                final int clubId = club['clubId'] as int? ?? 1;
                final bool isRecruiting = club['isRecruiting'] as bool? ?? true;
                final String clubName = club['clubName'].toString();
                final String tag = club['tag'].toString();
                final String meetingTime = club['meetingTime'].toString();
                final String location = club['location'].toString();
                final String logo = club['logo'].toString();
                final String description = club['description'].toString();
                final int memberCount = club['memberCount'] as int;

                return Container(
                  padding: const EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.0),
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.asset(
                              logo,
                              width: 54.0,
                              height: 54.0,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 54.0,
                                    height: 54.0,
                                    color: const Color(0xFF1E293B),
                                    alignment: Alignment.center,
                                    child: Text(
                                      clubName.substring(0, 1),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
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
                                  clubName,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF191919),
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  tag,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: Color(0xFF757575),
                                  ),
                                ),
                                const SizedBox(height: 3.0),
                                Text(
                                  meetingTime,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF555555),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Color(0xFF757575),
                              size: 20.0,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 160.0),
                            color: Colors.white,
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            onSelected: (value) {
                              if (value == 'manage') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClubManageScreen(
                                      clubName: clubName,
                                      clubLogo: logo,
                                    ),
                                  ),
                                );
                              } else if (value == 'withdraw') {
                                _showWithdrawDialog(index, clubName);
                              }
                            },
                            itemBuilder: (context) {
                              if (isPresident) {
                                return [
                                  PopupMenuItem<String>(
                                    value: 'manage',
                                    padding: EdgeInsets.zero,
                                    height: 44.0,
                                    child: Container(
                                      width: double.infinity,
                                      height: 44.0,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Color(0xFFEEEEEE),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '동아리 관리하기',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF191919),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'withdraw',
                                    padding: EdgeInsets.zero,
                                    height: 44.0,
                                    child: Center(
                                      child: Text(
                                        '동아리 탈퇴하기',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF191919),
                                        ),
                                      ),
                                    ),
                                  ),
                                ];
                              }
                              return [
                                const PopupMenuItem<String>(
                                  value: 'withdraw',
                                  padding: EdgeInsets.zero,
                                  height: 44.0,
                                  child: Center(
                                    child: Text(
                                      '동아리 탈퇴하기',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF191919),
                                      ),
                                    ),
                                  ),
                                ),
                              ];
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 42.0,
                              child: OutlinedButton(
                                onPressed: () {
                                  final initialClub = ClubModel(
                                    clubId: clubId,
                                    clubName: clubName,
                                    category: tag,
                                    isRecruiting: isRecruiting,
                                    description: description,
                                    logoUrl: logo,
                                    bannerUrl: logo,
                                    meetingTime: meetingTime,
                                    location: location,
                                    memberCount: memberCount,
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ClubDetailScreen(
                                        clubId: clubId,
                                        initialClub: initialClub,
                                        isPresident: isPresident,
                                      ),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF191919),
                                  side: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: const Text(
                                  '동아리 홈',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: SizedBox(
                              height: 42.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ClubBoardScreen(
                                        clubName: clubName,
                                        clubLogo: logo,
                                        memberCount: memberCount,
                                        isPresident: isPresident,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8CC63F),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: const Text(
                                  '게시판 바로가기',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class ClubManageScreen extends StatelessWidget {
  final String clubName;
  final String clubLogo;

  const ClubManageScreen({
    super.key,
    required this.clubName,
    required this.clubLogo,
  });

  @override
  Widget build(BuildContext context) {
    final List<ClubItemMap> manageMenus = [
      {'icon': Icons.edit_outlined, 'title': '동아리 상세 정보 수정'},
      {'icon': Icons.person_add_alt_1_outlined, 'title': '가입 신청 관리'},
      {'icon': Icons.groups_outlined, 'title': '부원 명단 및 권한 관리'},
      {'icon': Icons.assignment_outlined, 'title': '회비 관리'},
      {'icon': Icons.assignment_outlined, 'title': '장부 관리'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
        title: const Text(
          '내 동아리 관리',
          style: TextStyle(
            color: Color(0xFF191919),
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFEEEEEE), height: 1.0),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    clubLogo,
                    width: 56.0,
                    height: 56.0,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 56.0,
                      height: 56.0,
                      color: const Color(0xFF1E293B),
                      alignment: Alignment.center,
                      child: Text(
                        clubName.substring(0, 1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14.0),
                Text(
                  clubName,
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191919),
                  ),
                ),
              ],
            ),
          ),

          Container(
            color: Colors.white,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: manageMenus.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1.0,
                thickness: 1.0,
                color: Color(0xFFF2F2F2),
              ),
              itemBuilder: (context, index) {
                final menu = manageMenus[index];
                return InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${menu['title']} 화면으로 이동합니다.'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 17.0,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          menu['icon'] as IconData,
                          size: 21.0,
                          color: const Color(0xFF9E9E9E),
                        ),
                        const SizedBox(width: 14.0),
                        Text(
                          menu['title'].toString(),
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF191919),
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
      ),
    );
  }
}
