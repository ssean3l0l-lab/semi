import 'package:flutter/material.dart';

import '../../widgets/app_logo.dart';
import '../../widgets/highlighted_text.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 60.0),

              // 1. 상단 앱 로고
              AppLogo(size: 96.0),

              SizedBox(height: 36.0),

              // 2. 메인 타이틀 (포인트 강조 문구)
              HighlightedText(highlight: '신', text: '구대학교'),
              SizedBox(height: 4.0),
              HighlightedText(highlight: '동', text: '아리 앱에서'),
              SizedBox(height: 4.0),
              Text(
                '특별함을 만나다',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF191919),
                  height: 1.25,
                  letterSpacing: -0.5,
                ),
              ),

              SizedBox(height: 48.0),

              // 3. 서브 타이틀 설명 문구
              Text(
                '동아리 구경부터\n모집까지',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF505050),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
