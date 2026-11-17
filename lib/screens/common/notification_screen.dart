import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    // 알림 데이터 내부에 정렬 기준점(timestamp) 추가
    final notifications = [
      {
        'type': '지원 상태',
        'time': '10분 전',
        'title': '<HelloWorld> 서류 합격',
        'content': '축하해요! 9월 29일 면접 일정과 준비 사항을 확인해 주세요.',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
      },
      {
        'type': '마감 임박',
        'time': '1시간 전',
        'title': '<아리아> 모집이 오늘 마감돼요',
        'content': '지원서 임시 저장 내용이 있어요. 오늘 18시 전에 제출해 주세요.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      },
      {
        'type': '지원 상태',
        'time': '어제',
        'title': '<신구FC>가 지원서를 확인했어요',
        'content': '결과가 등록되면 바로 알려드릴게요.',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      },
    ];

    // timestamp를 기준으로 최신순(내림차순) 정렬 수행
    notifications.sort(
      (a, b) =>
          (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20.0,
        title: const Text(
          '알림',
          style: TextStyle(
            color: Color(0xFF191919),
            fontWeight: FontWeight.w800,
            fontSize: 22.0,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 1.0,
            thickness: 1.0,
            color: Color(0xFFF5F5F5),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          final notification = notifications[index];

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notification['type'] as String,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      notification['time'] as String,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  notification['title'] as String,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  notification['content'] as String,
                  style: const TextStyle(
                    fontSize: 13.0,
                    color: Color(0xFF757575),
                    height: 1.4,
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
