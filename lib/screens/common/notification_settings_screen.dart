import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State {
  final List _settings = [
    {'title': '지원 결과 알림', 'subtitle': '서류 심사 및 면접 결과 발표 알림', 'enabled': true},
    {
      'title': '스케줄 알림',
      'subtitle': '다가오는 면접 일정 및 서류 제출 마감 기한',
      'enabled': false,
    },
    {'title': '동아리 활동 알림', 'subtitle': '내 동아리의 중요 일정 및 공지 사항', 'enabled': true},
    {
      'title': '새 피드 알림',
      'subtitle': '내 동아리 소식에 새로운 피드가 올라왔을 때',
      'enabled': false,
    },
    {
      'title': '마케팅 및 이벤트 알림',
      'subtitle': '새로운 동아리 추천 및 이벤트 알림',
      'enabled': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
          '알림 설정',
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _settings.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1.0,
              thickness: 1.0,
              indent: 20.0,
              endIndent: 20.0,
              color: Color(0xFFF2F2F2),
            ),
            itemBuilder: (context, index) {
              final item = _settings[index] as Map;
              final bool isEnabled = item['enabled'] == true;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 18.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'].toString(),
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF191919),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            item['subtitle'].toString(),
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          item['enabled'] = !isEnabled;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 48.0,
                        height: 28.0,
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: isEnabled
                              ? const Color(0xFF8CC63F)
                              : const Color(0xFF94A3B8),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 180),
                          alignment: isEnabled
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 22.0,
                            height: 22.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
