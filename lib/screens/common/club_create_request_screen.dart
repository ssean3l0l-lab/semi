import 'package:flutter/material.dart';

import 'submission_complete_screen.dart';

class ClubCreateRequestScreen extends StatefulWidget {
  const ClubCreateRequestScreen({super.key});

  @override
  State<ClubCreateRequestScreen> createState() =>
      _ClubCreateRequestScreenState();
}

class _ClubCreateRequestScreenState extends State<ClubCreateRequestScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _advisorController = TextEditingController();
  final TextEditingController _leaderController = TextEditingController();
  final TextEditingController _etcCategoryController = TextEditingController();

  String _selectedCategory = '학술';
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _purposeController.addListener(_validateForm);
    _advisorController.addListener(_validateForm);
    _leaderController.addListener(_validateForm);
    _etcCategoryController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _purposeController.dispose();
    _advisorController.dispose();
    _leaderController.dispose();
    _etcCategoryController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      bool isBasicInfoFilled =
          _nameController.text.trim().isNotEmpty &&
          _purposeController.text.trim().isNotEmpty &&
          _advisorController.text.trim().isNotEmpty &&
          _leaderController.text.trim().isNotEmpty;

      if (_selectedCategory == '기타') {
        _isFormValid =
            isBasicInfoFilled && _etcCategoryController.text.trim().isNotEmpty;
      } else {
        _isFormValid = isBasicInfoFilled;
      }
    });
  }

  Widget _buildSectionTitle(String title, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF191919),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4.0),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12.0, color: Color(0xFF757575)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    int maxLines = 1,
    double height = 48.0,
    String hintText = '',
  }) {
    return Container(
      height: maxLines > 1 ? null : height,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 13.0),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '동아리 개설 요청',
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 안내 문구(빨간색 표시 부분)를 완전히 삭제했습니다.

                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F8E9),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline,
                            color: Color(0xFF8CC63F),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '받는 사람',
                                style: TextStyle(
                                  fontSize: 11.0,
                                  color: Color(0xFF9E9E9E),
                                ),
                              ),
                              SizedBox(height: 2.0),
                              Text(
                                '앱 관리자',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF191919),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F8E9),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: const Text(
                            'ADMIN',
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8CC63F),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  _buildSectionTitle('1. 동아리 명칭'),
                  _buildTextField(_nameController),

                  _buildSectionTitle('2. 동아리 성격/분야'),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: Column(
                      children: [
                        ...['학술', '예술/문화', '체육/스포츠', '사회/봉사', '기타'].map((
                          category,
                        ) {
                          return RadioListTile<String>(
                            title: Text(
                              category,
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            value: category,
                            groupValue: _selectedCategory,
                            activeColor: const Color(0xFF8CC63F),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            visualDensity: VisualDensity.compact,
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value!;
                              });
                              _validateForm();
                            },
                          );
                        }),

                        if (_selectedCategory == '기타') ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              16.0,
                              0,
                              16.0,
                              16.0,
                            ),
                            child: _buildTextField(
                              _etcCategoryController,
                              hintText: '기타 분야를 입력해주세요',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  _buildSectionTitle('3. 동아리 설립 취지 및 목적'),
                  _buildTextField(_purposeController, maxLines: 5),

                  _buildSectionTitle(
                    '4. 동아리 지도 교수',
                    subtitle: '아래 형식에 맞춰 기입해 주세요.\n• 소속 학과(부) / 성함',
                  ),
                  _buildTextField(_advisorController),

                  _buildSectionTitle(
                    '5. 동아리 대표자(회장) 정보',
                    subtitle:
                        '아래 형식에 맞춰 기입해 주세요.\n• 이름:\n• 학과(부):\n• 학번:\n• 연락처:',
                  ),
                  _buildTextField(_leaderController, maxLines: 5),
                  const SizedBox(height: 24.0),

                  // ★ 초록색 표시 부분(안내 텍스트)을 스크롤 영역 맨 아래(질문 목록 하단)에 배치
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Color(0xFF8CC63F),
                      ),
                      SizedBox(width: 6.0),
                      Expanded(
                        child: Text(
                          '요청을 보내도 바로 개설되지는 않아요.\n관리자가 내용을 확인한 후 안내해 드려요.',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Color(0xFF9E9E9E),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32.0),
                ],
              ),
            ),
          ),

          // 하단에는 버튼만 스티커 고정
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubmissionCompleteScreen(
                              clubName: _nameController.text.trim(),
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
                  '관리자에게 개설 요청 보내기',
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
        ],
      ),
    );
  }
}
