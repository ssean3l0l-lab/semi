import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List faqList = [
      {
        'question': '동아리는 어디에서 찾아볼 수 있나요?',
        'answer': '탐색에서 관심 있는 동아리를 찾아보세요.\n동아리를 선택하면 상세 정보를 볼 수 있어요.',
      },
      {
        'question': '동아리에 지원하려면 어떻게 하나요?',
        'answer': '동아리 상세 정보에서 모집 내용을 확인한 뒤\n지원서를 작성해 제출해 주세요.',
      },
      {
        'question': '지원 현황은 어디에서 확인하나요?',
        'answer': '마이 페이지의 ‘지원 현황’에서 지원 내역과\n진행 상태를 확인할 수 있어요.',
      },
      {
        'question': '알림은 어디에서 설정하나요?',
        'answer': '마이 페이지의 ‘알림 설정’을 확인해 주세요.\n기기 설정에서도 앱의 알림 권한을 확인해요.',
      },
      {
        'question': '내 정보는 어디에서 확인하나요?',
        'answer': '마이 페이지 상단에서 이름, 학과, 학번을\n확인할 수 있어요.',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF191919),
            size: 20.0,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '자주 묻는 질문',
          style: TextStyle(
            color: Color(0xFF191919),
            fontWeight: FontWeight.w800,
            fontSize: 19.0,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 32.0),
        itemCount: faqList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14.0),
        itemBuilder: (context, index) {
          final item = faqList[index] as Map;
          return Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.0),
              border: Border.all(color: const Color(0xFFE8ECEF), width: 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Q.',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF5FA832),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        item['question'].toString(),
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF191919),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Text(
                  item['answer'].toString(),
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF6E7781),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
