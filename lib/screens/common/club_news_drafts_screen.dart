import 'package:flutter/material.dart';

import 'club_news_write_screen.dart';

class ClubNewsDraftsScreen extends StatefulWidget {
  final String clubName;

  const ClubNewsDraftsScreen({super.key, required this.clubName});

  @override
  State createState() => _ClubNewsDraftsScreenState();
}

class _ClubNewsDraftsScreenState extends State {
  bool _isEditMode = false;
  final List _selectedIndices = [];

  @override
  Widget build(BuildContext context) {
    final screenWidget = widget as ClubNewsDraftsScreen;

    // 현재 동아리의 임시저장 글만 필터링
    final clubDrafts = ClubNewsWriteScreen.draftPosts
        .where((draft) => (draft as Map)['clubName'] == screenWidget.clubName)
        .toList();

    final bool isAllSelected =
        clubDrafts.isNotEmpty && _selectedIndices.length == clubDrafts.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF191919),
            size: 22,
          ),
          onPressed: () {
            if (_isEditMode) {
              setState(() {
                _isEditMode = false;
                _selectedIndices.clear();
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          '임시 보관함',
          style: TextStyle(
            color: Color(0xFF191919),
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          if (clubDrafts.isNotEmpty && !_isEditMode)
            TextButton(
              onPressed: () {
                setState(() {
                  _isEditMode = true;
                  _selectedIndices.clear();
                });
              },
              child: const Text(
                '수정',
                style: TextStyle(
                  color: Color(0xFF8CC63F),
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
            ),
          if (_isEditMode) ...[
            TextButton(
              onPressed: () {
                setState(() {
                  if (isAllSelected) {
                    _selectedIndices.clear();
                  } else {
                    _selectedIndices.clear();
                    for (int i = 0; i < clubDrafts.length; i++) {
                      _selectedIndices.add(i);
                    }
                  }
                });
              },
              child: Text(
                isAllSelected ? '선택 해제' : '모두 선택',
                style: const TextStyle(
                  color: Color(0xFF8CC63F),
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
            ),
            TextButton(
              onPressed: _selectedIndices.isEmpty
                  ? null
                  : () {
                      setState(() {
                        // 선택된 항목들을 원본 리스트에서 삭제
                        final itemsToRemove = _selectedIndices
                            .map((idx) => clubDrafts[idx as int])
                            .toList();
                        for (var item in itemsToRemove) {
                          ClubNewsWriteScreen.draftPosts.remove(item);
                        }
                        _selectedIndices.clear();
                        if (ClubNewsWriteScreen.draftPosts
                            .where(
                              (d) =>
                                  (d as Map)['clubName'] ==
                                  screenWidget.clubName,
                            )
                            .isEmpty) {
                          _isEditMode = false;
                        }
                      });
                    },
              child: Text(
                '삭제',
                style: TextStyle(
                  color: _selectedIndices.isEmpty
                      ? const Color(0xFFBDBDBD)
                      : const Color(0xFF8CC63F),
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
          const SizedBox(width: 8.0),
        ],
      ),
      body: clubDrafts.isEmpty
          ? const Center(
              child: Text(
                '임시 저장된 게시물이 없습니다.',
                style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 15.0),
              ),
            )
          : ListView.separated(
              itemCount: clubDrafts.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1.0,
                thickness: 1.0,
                color: Color(0xFFF2F2F2),
              ),
              itemBuilder: (context, index) {
                final draft = clubDrafts[index] as Map;
                final List draftImages = draft['images'] as List;
                final String contentText = draft['content'].toString();
                final String dateText = draft['date']?.toString() ?? '26/11/14';
                final bool isChecked = _selectedIndices.contains(index);

                return InkWell(
                  onTap: () {
                    if (_isEditMode) {
                      setState(() {
                        isChecked
                            ? _selectedIndices.remove(index)
                            : _selectedIndices.add(index);
                      });
                    } else {
                      // 일반 모드에서 클릭 시 선택된 임시저장 글을 작성 화면으로 전달하며 복귀
                      Navigator.pop(context, draft);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 수정 모드일 때 좌측 체크박스 노출
                        if (_isEditMode)
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 16.0,
                              top: 2.0,
                            ),
                            child: Container(
                              width: 22.0,
                              height: 22.0,
                              decoration: BoxDecoration(
                                color: isChecked
                                    ? const Color(0xFF8CC63F)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(
                                  color: isChecked
                                      ? const Color(0xFF8CC63F)
                                      : const Color(0xFF757575),
                                  width: 1.8,
                                ),
                              ),
                              child: isChecked
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16.0,
                                    )
                                  : null,
                            ),
                          ),
                        // 중앙 본문 텍스트 및 날짜
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contentText.trim().isNotEmpty
                                    ? contentText.trim()
                                    : '(사진만 있는 게시물)',
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Color(0xFF191919),
                                  height: 1.45,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                dateText,
                                style: const TextStyle(
                                  fontSize: 13.0,
                                  color: Color(0xFF757575),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 우측 이미지 썸네일 (첨부된 사진이 있을 때만 표시)
                        if (draftImages.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                draftImages[0].toString(),
                                width: 64.0,
                                height: 64.0,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Container(
                                  width: 64.0,
                                  height: 64.0,
                                  color: const Color(0xFFEEEEEE),
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
