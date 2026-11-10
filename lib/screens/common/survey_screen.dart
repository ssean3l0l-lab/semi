import 'package:flutter/material.dart';

import '../../widgets/app_logo.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  // 각 질문별 선택 상태 저장 변수
  final Set<String> _q1Selected = {'문화 / 예술', 'IT / 코딩'};
  final Set<String> _q2Selected = {'친구 사귀기', '함께 배우기'};
  String? _q3Selected = '처음이에요 · 기초부터 배우고 싶어요';
  final Set<String> _q4Selected = {'평일 저녁', '주말'};
  String? _q5Selected = '주 1회';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20.0,
        title: Row(
          children: [
            const AppLogo(size: 28.0),
            const SizedBox(width: 8.0),
            const Text(
              'SHINGU CLUB',
              style: TextStyle(
                color: Color(0xFF191919),
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: 나중에 하기 클릭 시 메인으로 이동
            },
            child: const Text(
              '나중에',
              style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14.0),
            ),
          ),
          const SizedBox(width: 12.0),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI 맞춤 배지 영역
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.auto_awesome,
                      size: 18,
                      color: Color(0xFF8CC63F),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'AI 맞춤 동아리 추천',
                      style: TextStyle(
                        color: Color(0xFF8CC63F),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Text(
                    '약 1분',
                    style: TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12.0),

            // 메인 타이틀
            const Text(
              '나에게 맞는 동아리,\n함께 찾아볼까요?',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF191919),
                height: 1.3,
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 8.0),

            const Text(
              '5가지 질문에 편하게 답해 주세요.\n정답은 없어요, 처음이어도 괜찮아요!',
              style: TextStyle(
                fontSize: 14.0,
                color: Color(0xFF757575),
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24.0),

            // Q1 카드
            _buildCard(
              qNum: 'Q1',
              selectType: '복수 선택',
              title: '어떤 분야에 관심 있나요?',
              subTitle: '흥미롭거나 궁금한 분야를 모두 골라 주세요.',
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2.8,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: ['학술', '체육', '문화 / 예술', '사회 / 봉사', 'IT / 코딩', '음악']
                    .map((item) {
                      final isSelected = _q1Selected.contains(item);
                      return _buildCheckboxChip(
                        label: item,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _q1Selected.remove(item);
                            } else {
                              _q1Selected.add(item);
                            }
                          });
                        },
                      );
                    })
                    .toList(),
              ),
            ),

            const SizedBox(height: 16.0),

            // Q2 카드
            _buildCard(
              qNum: 'Q2',
              selectType: '복수 선택',
              title: '동아리에서 무엇을 하고 싶나요?',
              subTitle: '원하는 활동과 목표를 모두 골라 주세요.',
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2.8,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children:
                    [
                      '친구 사귀기',
                      '취미 즐기기',
                      '함께 배우기',
                      '프로젝트·대회',
                      '공연·작품 만들기',
                      '봉사·나눔',
                    ].map((item) {
                      final isSelected = _q2Selected.contains(item);
                      return _buildCheckboxChip(
                        label: item,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _q2Selected.remove(item);
                            } else {
                              _q2Selected.add(item);
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 16.0),

            // Q3 카드
            _buildCard(
              qNum: 'Q3',
              selectType: '단일 선택',
              title: '관심 분야의 경험은 어느 정도인가요?',
              subTitle: '지금 나와 가장 가까운 답을 하나 골라 주세요.',
              child: Column(
                children:
                    [
                      '처음이에요 · 기초부터 배우고 싶어요',
                      '조금 해봤어요 · 더 익히고 싶어요',
                      '익숙해요 · 적극적으로 활동하고 싶어요',
                    ].map((item) {
                      final isSelected = _q3Selected == item;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: _buildRadioTile(
                          label: item,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _q3Selected = item;
                            });
                          },
                        ),
                      );
                    }).toList(),
              ),
              footerNote: '선택한 관심 분야를 기준으로 답해 주세요.',
            ),

            const SizedBox(height: 16.0),

            // Q4 카드
            _buildCard(
              qNum: 'Q4',
              selectType: '복수 선택',
              title: '언제 참여할 수 있나요?',
              subTitle: '보통 참여 가능한 시간대를 모두 골라 주세요.',
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2.8,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: ['평일 낮', '평일 저녁', '주말', '아직 미정'].map((item) {
                  final isSelected = _q4Selected.contains(item);
                  return _buildCheckboxChip(
                    label: item,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _q4Selected.remove(item);
                        } else {
                          _q4Selected.add(item);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16.0),

            // Q5 카드
            _buildCard(
              qNum: 'Q5',
              selectType: '단일 선택',
              title: '얼마나 자주 활동하고 싶나요?',
              subTitle: '부담 없이 참여할 수 있는 빈도를 골라 주세요.',
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2.8,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: ['월 1~2회', '주 1회', '주 2회 이상', '유동적으로'].map((item) {
                  final isSelected = _q5Selected == item;
                  return _buildRadioChip(
                    label: item,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _q5Selected = item;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 32.0),

            // 하단 제출 섹션
            Center(
              child: Column(
                children: [
                  const Text(
                    '답변을 바탕으로 잘 맞는 동아리를 추천해 드려요.',
                    style: TextStyle(fontSize: 13.0, color: Color(0xFF757575)),
                  ),
                  const SizedBox(height: 12.0),
                  SizedBox(
                    width: double.infinity,
                    height: 52.0,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: 결과 페이지 이동 또는 추천 요청 연결
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9EC644),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                      ),
                      child: const Text(
                        '나에게 맞는 동아리 추천받기',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  const Text(
                    '관심사가 바뀌면 언제든 다시 추천받을 수 있어요.',
                    style: TextStyle(fontSize: 12.0, color: Color(0xFF9E9E9E)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  // 카드 공통 틀 위젯
  Widget _buildCard({
    required String qNum,
    required String selectType,
    required String title,
    required String subTitle,
    required Widget child,
    String? footerNote,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                qNum,
                style: const TextStyle(
                  color: Color(0xFF8CC63F),
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
              Text(
                selectType,
                style: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF191919),
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            subTitle,
            style: const TextStyle(fontSize: 13.0, color: Color(0xFF757575)),
          ),
          const SizedBox(height: 16.0),
          child,
          if (footerNote != null) ...[
            const SizedBox(height: 10.0),
            Text(
              footerNote,
              style: const TextStyle(fontSize: 12.0, color: Color(0xFF9E9E9E)),
            ),
          ],
        ],
      ),
    );
  }

  // 사각형 체크박스 스타일 칩
  Widget _buildCheckboxChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF2F9E8) : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8CC63F)
                : const Color(0xFFE0E0E0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              size: 20,
              color: isSelected
                  ? const Color(0xFF8CC63F)
                  : const Color(0xFFBDBDBD),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? const Color(0xFF191919)
                      : const Color(0xFF616161),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 가로 전체를 차지하는 라디오 타일 (Q3용)
  Widget _buildRadioTile({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF2F9E8) : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8CC63F)
                : const Color(0xFFE0E0E0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
              color: isSelected
                  ? const Color(0xFF8CC63F)
                  : const Color(0xFFBDBDBD),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? const Color(0xFF191919)
                      : const Color(0xFF616161),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 그리드형 라디오 칩 (Q5용)
  Widget _buildRadioChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF2F9E8) : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8CC63F)
                : const Color(0xFFE0E0E0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
              color: isSelected
                  ? const Color(0xFF8CC63F)
                  : const Color(0xFFBDBDBD),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? const Color(0xFF191919)
                      : const Color(0xFF616161),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
