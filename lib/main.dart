import 'package:flutter/material.dart';

import 'screens/common/explore_screen.dart'; // 탐색 화면 임포트
import 'screens/common/board_screen.dart'; // 게시판 화면 임포트
import 'screens/common/home_screen.dart'; // 홈 화면 임포트
import 'screens/common/my_page_screen.dart'; // 마이 페이지 화면 임포트

void main() {
  runApp(const ShinguClubApp());
}

class ShinguClubApp extends StatelessWidget {
  const ShinguClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shingu Club',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8CC63F)),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 2; // 기본 홈 탭 (인덱스 2)

  // 5개의 하단 탭 화면 목록 (탐색, 게시판, 홈, 알림, 마이)
  final List<Widget> _screens = [
    const ExploreScreen(), // 0번 인덱스 탐색 화면
    const BoardScreen(), // 1번 인덱스 게시판 화면
    const HomeScreen(), // 2번 인덱스 홈 화면
    const Center(
      child: Text(
        '알림 화면 (준비중)',
        style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
      ),
    ),
    const MyPageScreen(), // 4번 인덱스 마이 페이지 화면
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF8CC63F),
          unselectedItemColor: const Color(0xFF9E9E9E),
          selectedFontSize: 11.0,
          unselectedFontSize: 11.0,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.explore_outlined),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.explore),
              ),
              label: '탐색',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.article_outlined),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.article),
              ),
              label: '게시판',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.home_outlined),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.home),
              ),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.notifications_none_rounded),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.notifications_rounded),
              ),
              label: '알림',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.person_outline_rounded),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.person_rounded),
              ),
              label: '마이',
            ),
          ],
        ),
      ),
    );
  }
}
