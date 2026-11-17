import 'package:flutter/material.dart';

import 'application_status_screen.dart';
import 'faq_screen.dart';
import 'login_screen.dart';
import 'my_clubs_screen.dart';
import 'notification_settings_screen.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State {
  void _showLogoutDialog(BuildContext context) {
    final rootNavigator = Navigator.of(context, rootNavigator: true);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 28.0, 24.0, 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 상단 연분홍 원형 로그아웃 아이콘
                Container(
                  width: 56.0,
                  height: 56.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDECEC),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFD64545),
                    size: 26.0,
                  ),
                ),
                const SizedBox(height: 18.0),
                const Text(
                  '로그아웃할까요?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF191919),
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  '다시 이용하려면 학교 계정으로 로그인해야 해요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.0, color: Color(0xFF757575)),
                ),
                const SizedBox(height: 24.0),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48.0,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF424242),
                            side: const BorderSide(
                              color: Color(0xFFE0E0E0),
                              width: 1.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: const Text(
                            '취소',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: SizedBox(
                        height: 48.0,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            rootNavigator.pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD64545),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: const Text(
                            '로그아웃',
                            style: TextStyle(
                              fontSize: 14.5,
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
          '마이 페이지',
          style: TextStyle(
            color: Color(0xFF191919),
            fontWeight: FontWeight.w800,
            fontSize: 20.0,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12.0),
              _buildProfileCard(),
              const SizedBox(height: 24.0),
              _buildActivitySection(context),
              const SizedBox(height: 24.0),
              _buildMenuSection(context),
              const SizedBox(height: 48.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
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
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 64.0,
                height: 64.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 36.0,
                    color: Color(0xFF8CC63F),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 14.0,
                  height: 14.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8CC63F),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16.0),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '김신구',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191919),
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  '소프트웨어학과 · 20241234',
                  style: TextStyle(fontSize: 13.0, color: Color(0xFF757575)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 5.0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F8E9),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Text(
              '재학생',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7CB342),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection(BuildContext context) {
    return AnimatedBuilder(
      animation: MyClubsScreen.clubsNotifier,
      builder: (context, _) {
        final clubs = MyClubsScreen.joinedClubs;
        final int clubCount = clubs.length;
        final String clubSummary;

        if (clubCount == 0) {
          clubSummary = '가입된 동아리 없음';
        } else if (clubCount == 1) {
          clubSummary = (clubs[0] as Map)['clubName'].toString();
        } else {
          clubSummary = '${(clubs[0] as Map)['clubName']} 외 ${clubCount - 1}개';
        }

        return Container(
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
              const Text(
                '나의 동아리 활동',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF191919),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  // 클릭 시 내 동아리 화면으로 이동 후 복귀 시 상태 갱신
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyClubsScreen(),
                          ),
                        );
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FBE7),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '내 동아리',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8CC63F),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              '$clubCount개',
                              style: const TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF191919),
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              clubSummary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11.0,
                                color: Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  // 클릭 시 나의 지원현황 화면으로 이동
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ApplicationStatusScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FBE7),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '지원 현황',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8CC63F),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              '2건',
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF191919),
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              '지난 이력 4건',
                              style: TextStyle(
                                fontSize: 11.0,
                                color: Color(0xFF757575),
                              ),
                            ),
                          ],
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
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Container(
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
        children: [
          _buildMenuItem(
            icon: Icons.notifications_none_rounded,
            iconColor: const Color(0xFF8CC63F),
            bgColor: const Color(0xFFF1F8E9),
            title: '알림 설정',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationSettingsScreen(),
                ),
              );
            },
          ),
          const Divider(
            height: 1,
            color: Color(0xFFEEEEEE),
            indent: 20,
            endIndent: 20,
          ),
          _buildMenuItem(
            icon: Icons.help_outline_rounded,
            iconColor: const Color(0xFF8CC63F),
            bgColor: const Color(0xFFF1F8E9),
            title: 'FAQ (자주 묻는 질문)',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FaqScreen()),
              );
            },
          ),
          const Divider(
            height: 1,
            color: Color(0xFFEEEEEE),
            indent: 20,
            endIndent: 20,
          ),
          _buildMenuItem(
            icon: Icons.logout_rounded,
            iconColor: const Color(0xFFE57373),
            bgColor: const Color(0xFFFFEBEE),
            title: '로그아웃',
            titleColor: const Color(0xFFD32F2F),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    Color titleColor = const Color(0xFF191919),
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          children: [
            Container(
              width: 38.0,
              height: 38.0,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(icon, color: iconColor, size: 20.0),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFBDBDBD),
              size: 22.0,
            ),
          ],
        ),
      ),
    );
  }
}
