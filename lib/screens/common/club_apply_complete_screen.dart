import 'package:flutter/material.dart';

class ClubApplyCompleteScreen extends StatelessWidget {
  final String clubName;

  ClubApplyCompleteScreen({super.key, required this.clubName}) {
    // 생성 시점의 실제 현재 시각 포맷팅 (예: 11월 13일 17:41)
    final now = DateTime.now();
    _formattedDate =
        '${now.month}월 ${now.day}일 ${_twoDigits(now.hour)}:${_twoDigits(now.minute)}';
  }

  late final String _formattedDate;

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 첨부하신 UI 스타일의 이중 원형 체크 아이콘 반영
                  Container(
                    width: 72.0,
                    height: 72.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F8E9),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: const BoxDecoration(
                          color: Color(0xFF8CC63F),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 32.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  const Text(
                    '지원서를 제출했어요',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF191919),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    '$clubName에서 지원서를 확인한 뒤 알림으로 결과를\n안내해 드릴게요.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF757575),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40.0),

                  // 첨부하신 UI 스타일의 영수증 형태 상세 내역 카드 반영
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clubName,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF191919),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Divider(height: 1.0, color: Color(0xFFEEEEEE)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              '접수 번호',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xFF9E9E9E),
                              ),
                            ),
                            Text(
                              'HW-2026-031',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '제출 시간',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xFF9E9E9E),
                              ),
                            ),
                            Text(
                              _formattedDate, // 시스템 현 시각 자동 입력
                              style: const TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 하단 버튼들
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52.0,
                    child: ElevatedButton(
                      onPressed: () {
                        // 지원 현황 화면으로 이동 (추후 구현)
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8CC63F),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        '지원 현황 보기',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  SizedBox(
                    width: double.infinity,
                    height: 52.0,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFFEEEEEE)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        '홈으로',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
