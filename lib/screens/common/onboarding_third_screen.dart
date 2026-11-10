import 'package:flutter/material.dart';

import '../../widgets/page_indicator.dart';

class OnboardingThirdScreen extends StatelessWidget {
  const OnboardingThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 48.0),

              // 상단 타이틀 문구 (포인트 색상 적용)
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191919),
                    height: 1.35,
                    letterSpacing: -0.5,
                  ),
                  children: [
                    TextSpan(
                      text: '원 터치',
                      style: TextStyle(color: Color(0xFFFF522A)),
                    ),
                    TextSpan(text: ' 지원서 제출!'),
                  ],
                ),
              ),

              const SizedBox(height: 28.0),

              // 중앙 폰 목업 PNG 이미지
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/onboarding_phone2.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F8F9),
                          borderRadius: BorderRadius.circular(36.0),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported_outlined,
                                size: 48,
                                color: Color(0xFFBDBDBD),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'onboarding_phone2.png 파일 필요',
                                style: TextStyle(
                                  color: Color(0xFF757575),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // 하단 페이지 인디케이터 (2번째 점 활성화)
              const PageIndicator(currentIndex: 1),

              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}
