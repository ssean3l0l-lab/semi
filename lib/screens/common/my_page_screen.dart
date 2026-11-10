import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

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
              _buildActivitySection(),
              const SizedBox(height: 24.0),
              _buildMenuSection(context),
              const SizedBox(height: 48.0),
            ],
          ),
        ),
      ),
    );
  }

  // 1. 프로필 카드 영역
  Widget _buildProfileCard() {
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
        ],
      ),
    );
  }

  // 2. 나의 동아리 활동 요약 영역
  Widget _buildActivitySection() {
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
              Expanded(
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
                        '내 동아리',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8CC63F),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        '2개',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF191919),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'INFOS 외 1개',
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
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
                        '3건',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF191919),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        '결과 대기 1건',
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. 설정 및 메뉴 리스트 영역
  Widget _buildMenuSection(BuildContext context) {
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
        children: [
          _buildMenuItem(
            icon: Icons.notifications_none_rounded,
            iconColor: const Color(0xFF8CC63F),
            bgColor: const Color(0xFFF1F8E9),
            title: '알림 설정',
            onTap: () {},
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
            onTap: () {},
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
            onTap: () {},
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
