import 'package:flutter/material.dart';

class ApplicationStatusScreen extends StatefulWidget {
  const ApplicationStatusScreen({super.key});

  @override
  State createState() => _ApplicationStatusScreenState();
}

class _ApplicationStatusScreenState extends State {
  int _selectedTabIndex = 0; // 0: 지원중인 동아리, 1: 지난 지원 이력

  final List _activeApplications = [
    {
      'clubName': 'orange',
      'logo': 'assets/images/logo-orange.png',
      'statusText': '면접 대기',
      'steps': ['지원완료', '서류합격', '면접대기', '최종합격'],
      'currentStep': 2,
      'noticeTitle': '면접 안내 일정',
      'noticeDetail': '3월 18일 (화) 15:30 | 산학협력관 4층 대회의실',
    },
    {
      'clubName': '아리아',
      'logo': 'assets/images/logo-aria.png',
      'statusText': '서류심사중',
      'steps': ['지원완료', '서류심사', '최종합격'],
      'currentStep': 1,
      'noticeTitle': '서류 발표 일정',
      'noticeDetail': '3월 21일 (금) 12:30 | 4층 대회의실',
    },
  ];

  final List _pastApplications = [
    {
      'clubName': 'HelloWorld',
      'category': '체육/스포츠',
      'logo': 'assets/images/logo-helloworld.png',
      'result': '최종 합격',
      'appliedDate': '2026.03.10',
    },
    {
      'clubName': '버디',
      'category': '사회/봉사',
      'logo': 'assets/images/logo-buddy.png',
      'result': '불합격',
      'appliedDate': '2026.02.30',
    },
    {
      'clubName': '오프레임 (Off-frame)',
      'category': '문화/예술',
      'logo': 'assets/images/logo-offframe.png',
      'result': '최종 합격',
      'appliedDate': '2025.12.08',
    },
    {
      'clubName': '디포스',
      'category': '문화/예술',
      'logo': 'assets/images/logo-dforce.png',
      'result': '지원 취소',
      'appliedDate': '2025.03.02',
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
          '나의 지원현황',
          style: TextStyle(
            color: Color(0xFF191919),
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: _buildTabButton(
                    index: 0,
                    label: '지원중인 동아리 (${_activeApplications.length})',
                  ),
                ),
                Expanded(
                  child: _buildTabButton(
                    index: 1,
                    label: _selectedTabIndex == 1
                        ? '지난 지원 이력 (${_pastApplications.length})'
                        : '지난 지원 이력',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedTabIndex == 0
                ? _buildActiveList()
                : _buildPastList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({required int index, required String label}) {
    final bool isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: const BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
            bottom: BorderSide(
              color: isSelected
                  ? const Color(0xFF8CC63F)
                  : const Color(0xFFEEEEEE),
              width: isSelected ? 2.5 : 1.0,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? const Color(0xFF8CC63F)
                : const Color(0xFF9E9E9E),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveList() {
    if (_activeApplications.isEmpty) {
      return const Center(
        child: Text(
          '현재 지원중인 동아리가 없습니다.',
          style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14.0),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20.0),
      itemCount: _activeApplications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16.0),
      itemBuilder: (context, index) {
        final item = _activeApplications[index] as Map;
        final List steps = item['steps'] as List;
        final int currentStep = item['currentStep'] as int;

        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      item['logo'].toString(),
                      width: 44.0,
                      height: 44.0,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 44.0,
                        height: 44.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Icon(
                          Icons.groups,
                          color: Color(0xFF9E9E9E),
                          size: 22.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      item['clubName'].toString(),
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF191919),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      item['statusText'].toString(),
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD97706),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22.0),
              _buildStepProgress(steps, currentStep),
              const SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8E9),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['noticeTitle'].toString(),
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7CB342),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      item['noticeDetail'].toString(),
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepProgress(List steps, int currentStep) {
    final List rowChildren = [];

    for (int i = 0; i < steps.length; i++) {
      final bool isCompleted = i < currentStep;
      final bool isCurrent = i == currentStep;

      rowChildren.add(
        Column(
          children: [
            _buildStepCircle(
              stepNumber: i + 1,
              isCompleted: isCompleted,
              isCurrent: isCurrent,
            ),
            const SizedBox(height: 6.0),
            Text(
              steps[i].toString(),
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                color: isCurrent
                    ? const Color(0xFFD97706)
                    : (isCompleted
                          ? const Color(0xFF555555)
                          : const Color(0xFF9E9E9E)),
              ),
            ),
          ],
        ),
      );

      if (i < steps.length - 1) {
        final bool isNextCurrent = (i + 1) == currentStep;
        final bool isLineCompleted = (i + 1) < currentStep;

        rowChildren.add(
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 4.0,
                right: 4.0,
                bottom: 20.0,
              ),
              child: isNextCurrent
                  ? _buildDashedLine(const Color(0xFFF59E0B))
                  : Container(
                      height: 2.0,
                      color: isLineCompleted
                          ? const Color(0xFF6BCB77)
                          : const Color(0xFFE5E7EB),
                    ),
            ),
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rowChildren.cast(),
      ),
    );
  }

  Widget _buildStepCircle({
    required int stepNumber,
    required bool isCompleted,
    required bool isCurrent,
  }) {
    if (isCompleted) {
      return Container(
        width: 26.0,
        height: 26.0,
        decoration: const BoxDecoration(
          color: Color(0xFF6BCB77),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 15.0),
      );
    }

    if (isCurrent) {
      return Container(
        width: 26.0,
        height: 26.0,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFF59E0B), width: 2.0),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 8.0,
          height: 8.0,
          decoration: const BoxDecoration(
            color: Color(0xFFF59E0B),
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return Container(
      width: 26.0,
      height: 26.0,
      decoration: const BoxDecoration(
        color: Color(0xFFE5E7EB),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$stepNumber',
        style: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF9CA3AF),
        ),
      ),
    );
  }

  Widget _buildDashedLine(Color color) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double dashWidth = 4.0;
        const double dashSpace = 3.0;
        final int dashCount =
            (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 2.0,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }

  Widget _buildPastList() {
    if (_pastApplications.isEmpty) {
      return const Center(
        child: Text(
          '지난 지원 이력이 없습니다.',
          style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14.0),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20.0),
      itemCount: _pastApplications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14.0),
      itemBuilder: (context, index) {
        final item = _pastApplications[index] as Map;
        final String result = item['result'].toString();

        Color badgeBgColor;
        Color badgeTextColor;

        if (result == '최종 합격') {
          badgeBgColor = const Color(0xFFE8F5E9);
          badgeTextColor = const Color(0xFF4CAF50);
        } else if (result == '불합격') {
          badgeBgColor = const Color(0xFFFEE2E2);
          badgeTextColor = const Color(0xFFEF4444);
        } else {
          badgeBgColor = const Color(0xFFF3F4F6);
          badgeTextColor = const Color(0xFF6B7280);
        }

        return Container(
          padding: const EdgeInsets.all(18.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44.0,
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: const Color(0xFFF0F0F0)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        item['logo'].toString(),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.shield_outlined,
                              color: Color(0xFF757575),
                              size: 22.0,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['clubName'].toString(),
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF191919),
                          ),
                        ),
                        const SizedBox(height: 3.0),
                        Text(
                          item['category'].toString(),
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBgColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      result,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: badgeTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14.0),
                child: Divider(
                  height: 1.0,
                  thickness: 1.0,
                  color: Color(0xFFF2F2F2),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '지원 일시',
                    style: TextStyle(fontSize: 12.5, color: Color(0xFF757575)),
                  ),
                  Text(
                    item['appliedDate'].toString(),
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
