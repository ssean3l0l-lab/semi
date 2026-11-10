import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String highlight; // 강조할 첫 글자 (예: '신', '동')
  final String text; // 나머지 문구 (예: '구대학교', '아리 앱에서')
  final double fontSize;

  const HighlightedText({
    super.key,
    required this.highlight,
    required this.text,
    this.fontSize = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          height: 1.25,
          letterSpacing: -0.5,
        ),
        children: [
          TextSpan(
            text: highlight,
            style: const TextStyle(
              color: Color(0xFF4CA60C), // 포인트 그린 색상
            ),
          ),
          TextSpan(
            text: text,
            style: const TextStyle(
              color: Color(0xFF191919), // 메인 텍스트 색상
            ),
          ),
        ],
      ),
    );
  }
}
