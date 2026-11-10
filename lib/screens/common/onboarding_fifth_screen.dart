import 'package:flutter/material.dart';

import '../../widgets/app_logo.dart';
import '../../widgets/page_indicator.dart';

class OnboardingFifthScreen extends StatelessWidget {
  const OnboardingFifthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // 중앙 상단 로고 이미지
              const AppLogo(size: 110.0),

              const SizedBox(height: 24.0),

              // 앱 영문 타이틀
              const Text(
                'Shindong',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF191919),
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 16.0),

              // 서브 설명 문구
              const Text(
                '당신의 즐거운 대학 생활을 위한\n신구대 전용 동아리 통합 플랫폼',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF424242),
                  height: 1.4,
                  letterSpacing: -0.5,
                ),
              ),

              const Spacer(flex: 3),

              // 로그인하기 버튼
              SizedBox(
                width: double.infinity,
                height: 52.0,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: 로그인 화면 이동 연결
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9EC644),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                  child: const Text(
                    '로그인하기',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32.0),

              // 하단 페이지 인디케이터 (4번째 점 활성화)
              const PageIndicator(currentIndex: 3),

              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}
