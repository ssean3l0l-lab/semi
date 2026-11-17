import 'package:flutter/material.dart';

import 'club_apply_complete_screen.dart';

class ClubApplyScreen extends StatefulWidget {
  final String clubName;
  final String clubLogo;

  const ClubApplyScreen({
    super.key,
    required this.clubName,
    required this.clubLogo,
  });

  @override
  State createState() => _ClubApplyScreenState();
}

class _ClubApplyScreenState extends State {
  final TextEditingController _motiveController = TextEditingController();
  final TextEditingController _toolsController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _preparationController = TextEditingController();

  // 관심 분야 다중 선택을 위한 상태 관리
  final List _interestOptions = [
    '프론트엔드',
    '백엔드',
    '모바일 앱',
    'AI · 데이터',
    '게임 개발',
    'UI / UX',
    '아직 탐색 중',
  ];
  final Set _selectedInterests = {}; // 체크된 항목들을 담는 Set

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _motiveController.addListener(_validateForm);
    _toolsController.addListener(_validateForm);
    _experienceController.addListener(_validateForm);
    _preparationController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _motiveController.dispose();
    _toolsController.dispose();
    _experienceController.dispose();
    _preparationController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid =
          _motiveController.text.trim().isNotEmpty &&
          _selectedInterests.isNotEmpty && // 하나 이상 체크되어야 함
          _toolsController.text.trim().isNotEmpty &&
          _experienceController.text.trim().isNotEmpty &&
          _preparationController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidget = widget as ClubApplyScreen;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                screenWidget.clubLogo,
                width: 28.0,
                height: 28.0,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 28.0,
                  height: 28.0,
                  color: const Color(0xFF263238),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              screenWidget.clubName,
              style: const TextStyle(
                color: Color(0xFF191919),
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQuestionTitle('1. 지원 동기'),
                const SizedBox(height: 8.0),
                _buildTextField(_motiveController), // 힌트 텍스트 삭제
                const SizedBox(height: 24.0),

                // 2. 관심 분야 (중복 선택 가능한 체크박스 묶음)
                _buildQuestionTitle('2. 관심 분야 (중복 선택 가능)'),
                const SizedBox(height: 8.0),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                  ),
                  child: Column(
                    children: _interestOptions.map((item) {
                      final option = item.toString();
                      return CheckboxListTile(
                        title: Text(
                          option,
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        value: _selectedInterests.contains(option),
                        activeColor: const Color(0xFF8CC63F),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        onChanged: (bool? isChecked) {
                          setState(() {
                            if (isChecked == true) {
                              _selectedInterests.add(option);
                            } else {
                              _selectedInterests.remove(option);
                            }
                          });
                          _validateForm();
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24.0),

                _buildQuestionTitle('3. 사용해 본 언어 및 도구'),
                const SizedBox(height: 4.0),
                const Text(
                  "예: Python, JavaScript, Git — 처음이라면 '없음'이라고 적어도 괜찮아요.",
                  style: TextStyle(fontSize: 12.0, color: Color(0xFF757575)),
                ),
                const SizedBox(height: 8.0),
                _buildTextField(_toolsController, maxLines: 3), // 힌트 텍스트 삭제
                const SizedBox(height: 24.0),

                _buildQuestionTitle('4. 기술 경험'),
                const SizedBox(height: 4.0),
                const Text(
                  '수업, 개인 공부, 프로젝트 등 개발과 관련된 경험을 자유롭게 작성해주세요. 어떤 문제를 만났고 어떻게 해결했는지도 궁금합니다.',
                  style: TextStyle(fontSize: 12.0, color: Color(0xFF757575)),
                ),
                const SizedBox(height: 8.0),
                _buildTextField(
                  _experienceController,
                  maxLines: 4,
                ), // 힌트 텍스트 삭제
                const SizedBox(height: 24.0),

                _buildQuestionTitle('5. 동아리 활동을 위해 준비된 점'),
                const SizedBox(height: 4.0),
                const Text(
                  '예를 들어 협업 스킬, 문제 해결 능력, 프로젝트 경험, 시간 관리 경험 등이 있나요?',
                  style: TextStyle(fontSize: 12.0, color: Color(0xFF757575)),
                ),
                const SizedBox(height: 8.0),
                _buildTextField(
                  _preparationController,
                  maxLines: 4,
                ), // 힌트 텍스트 삭제
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52.0,
                child: ElevatedButton(
                  onPressed: _isFormValid
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClubApplyCompleteScreen(
                                clubName: screenWidget.clubName,
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8CC63F),
                    disabledBackgroundColor: const Color(0xFFE0E0E0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    '지원서 제출하기',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: _isFormValid
                          ? Colors.white
                          : const Color(0xFF9E9E9E),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
        color: Color(0xFF191919),
      ),
    );
  }

  // 힌트 텍스트 매개변수 제거
  Widget _buildTextField(TextEditingController controller, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 14.0, color: Color(0xFF191919)),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16.0),
        ),
      ),
    );
  }
}
