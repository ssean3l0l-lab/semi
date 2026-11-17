import 'package:flutter/material.dart';

import '../../config/app_role.dart';
import '../../models/board_post_models.dart';
import '../../services/board_repository.dart';

class ClubPostWriteScreen extends StatefulWidget {
  final int clubId;
  final String clubName;
  final bool? isPresident;

  const ClubPostWriteScreen({
    super.key,
    required this.clubId,
    required this.clubName,
    this.isPresident,
  });

  @override
  State<ClubPostWriteScreen> createState() => _ClubPostWriteScreenState();
}

class _ClubPostWriteScreenState extends State<ClubPostWriteScreen> {
  static const List<String> _memberBoards = ['자유게시판', '질문게시판', '정보공유'];

  static const List<String> _presidentBoards = [
    '공지사항',
    '자유게시판',
    '질문게시판',
    '정보공유',
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  String? _selectedBoard;
  bool _isPinned = false;
  bool _isSubmitting = false;

  final List<BoardAttachmentModel> _selectedPhotos = [];
  final List<BoardAttachmentModel> _selectedFiles = [];
  final List<String> _tags = [];

  bool get _effectiveIsPresident {
    return widget.isPresident ?? AppRole.isPresident;
  }

  List<String> get _availableBoards {
    return _effectiveIsPresident ? _presidentBoards : _memberBoards;
  }

  bool get _canSubmit {
    return _selectedBoard != null &&
        _titleController.text.trim().isNotEmpty &&
        _contentController.text.trim().isNotEmpty &&
        !_isSubmitting;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  // 게시판 선택 바텀시트
  void _showBoardSelector() {
    final boards = _availableBoards;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36.0,
                  height: 4.0,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '게시판 선택',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF191919),
                    ),
                  ),
                ),
                ...boards.map((board) {
                  final isSelected = _selectedBoard == board;
                  return ListTile(
                    title: Text(
                      board,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF8CC63F)
                            : const Color(0xFF191919),
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Color(0xFF8CC63F))
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedBoard = board;
                      });
                      Navigator.pop(sheetContext);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // 사진 선택 (실서비스 연동 시 image_picker + MultipartFile 업로드로 교체)
  void _showPhotoPickerSheet() {
    final List<BoardAttachmentModel> samplePhotos = [
      const BoardAttachmentModel(
        fileName: '활동_단체사진_01.jpg',
        fileUrl: 'assets/images/helloworld.png',
        fileSizeBytes: 1843200,
        mimeType: 'image/jpeg',
        type: BoardAttachmentType.image,
      ),
      const BoardAttachmentModel(
        fileName: '해커톤_발표장면.jpg',
        fileUrl: 'assets/images/banner2.png',
        fileSizeBytes: 2201600,
        mimeType: 'image/jpeg',
        type: BoardAttachmentType.image,
      ),
      const BoardAttachmentModel(
        fileName: '동아리_홍보포스터.png',
        fileUrl: 'assets/images/banner1.png',
        fileSizeBytes: 1536000,
        mimeType: 'image/png',
        type: BoardAttachmentType.image,
      ),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '사진 첨부 선택',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191919),
                  ),
                ),
                const SizedBox(height: 12.0),
                ...samplePhotos.map((photo) {
                  final alreadyAdded = _selectedPhotos.any(
                    (item) => item.fileName == photo.fileName,
                  );
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        photo.fileUrl,
                        width: 44.0,
                        height: 44.0,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 44.0,
                          height: 44.0,
                          color: const Color(0xFFF1F8E9),
                          child: const Icon(
                            Icons.image,
                            color: Color(0xFF8CC63F),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      photo.fileName,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    subtitle: Text(
                      photo.formattedSize,
                      style: const TextStyle(fontSize: 12.0),
                    ),
                    trailing: alreadyAdded
                        ? const Text(
                            '첨부됨',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF8CC63F),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Icon(Icons.add_circle_outline),
                    onTap: () {
                      if (!alreadyAdded) {
                        setState(() {
                          _selectedPhotos.add(photo);
                        });
                      }
                      Navigator.pop(sheetContext);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // 파일 선택 (실서비스 연동 시 file_picker + MultipartFile 업로드로 교체)
  void _showFilePickerSheet() {
    final List<BoardAttachmentModel> sampleFiles = [
      const BoardAttachmentModel(
        fileName: '2026_활동보고서.pdf',
        fileUrl: 'https://shingu.club/files/2026_활동보고서.pdf',
        fileSizeBytes: 2516582,
        mimeType: 'application/pdf',
        type: BoardAttachmentType.file,
      ),
      const BoardAttachmentModel(
        fileName: '스터디_커리큘럼_안내.docx',
        fileUrl: 'https://shingu.club/files/스터디_커리큘럼_안내.docx',
        fileSizeBytes: 842000,
        mimeType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        type: BoardAttachmentType.file,
      ),
      const BoardAttachmentModel(
        fileName: '예산_사용내역서.xlsx',
        fileUrl: 'https://shingu.club/files/예산_사용내역서.xlsx',
        fileSizeBytes: 512000,
        mimeType:
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        type: BoardAttachmentType.file,
      ),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '첨부 파일 선택',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191919),
                  ),
                ),
                const SizedBox(height: 12.0),
                ...sampleFiles.map((file) {
                  final alreadyAdded = _selectedFiles.any(
                    (item) => item.fileName == file.fileName,
                  );
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 42.0,
                      height: 42.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Icon(
                        Icons.description_outlined,
                        color: Color(0xFF555555),
                      ),
                    ),
                    title: Text(
                      file.fileName,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    subtitle: Text(
                      file.formattedSize,
                      style: const TextStyle(fontSize: 12.0),
                    ),
                    trailing: alreadyAdded
                        ? const Text(
                            '첨부됨',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF8CC63F),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Icon(Icons.add_circle_outline),
                    onTap: () {
                      if (!alreadyAdded) {
                        setState(() {
                          _selectedFiles.add(file);
                        });
                      }
                      Navigator.pop(sheetContext);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // 태그 추가 다이얼로그
  void _showAddTagDialog() {
    _tagController.clear();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text(
            '태그 추가',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF191919),
            ),
          ),
          content: TextField(
            controller: _tagController,
            autofocus: true,
            maxLength: 15,
            decoration: const InputDecoration(
              hintText: '태그 입력 (예: 공모전, 스터디)',
              prefixText: '# ',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) {
              _addTagFromController();
              Navigator.pop(dialogContext);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                '취소',
                style: TextStyle(color: Color(0xFF9E9E9E)),
              ),
            ),
            TextButton(
              onPressed: () {
                _addTagFromController();
                Navigator.pop(dialogContext);
              },
              child: const Text(
                '추가',
                style: TextStyle(
                  color: Color(0xFF8CC63F),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addTagFromController() {
    final cleaned = _tagController.text.replaceAll('#', '').trim();
    if (cleaned.isEmpty) return;
    if (_tags.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('태그는 최대 5개까지 추가할 수 있습니다.'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    if (!_tags.contains(cleaned)) {
      setState(() {
        _tags.add(cleaned);
      });
    }
  }

  // 임시저장 목록 모달
  void _showDraftsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final currentDrafts = BoardRepository.instance.getDrafts(
              widget.clubId,
            );

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '임시저장 글 (${currentDrafts.length})',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF191919),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    if (currentDrafts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                          child: Text(
                            '임시저장된 게시글이 없습니다.',
                            style: TextStyle(color: Color(0xFF9E9E9E)),
                          ),
                        ),
                      )
                    else
                      ...currentDrafts.map((draft) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            draft.title,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '${draft.boardCategory ?? '게시판 미선택'} · ${draft.savedAt}',
                            style: const TextStyle(fontSize: 12.0),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20.0,
                              color: Color(0xFF9E9E9E),
                            ),
                            onPressed: () {
                              BoardRepository.instance.deleteDraft(
                                widget.clubId,
                                draft.draftId,
                              );
                              setSheetState(() {});
                              setState(() {});
                            },
                          ),
                          onTap: () {
                            setState(() {
                              _selectedBoard = draft.boardCategory;
                              _titleController.text = draft.title == '(제목 없음)'
                                  ? ''
                                  : draft.title;
                              _contentController.text = draft.content;
                              _tags
                                ..clear()
                                ..addAll(draft.tags);
                              _isPinned =
                                  _effectiveIsPresident && draft.isPinned;
                            });
                            Navigator.pop(sheetContext);
                          },
                        );
                      }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _saveCurrentAsDraft() {
    if (_titleController.text.trim().isEmpty &&
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('제목이나 내용을 입력한 후 임시저장해 주세요.'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    BoardRepository.instance.saveDraft(
      clubId: widget.clubId,
      boardCategory: _selectedBoard,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      tags: _tags,
      attachments: [..._selectedPhotos, ..._selectedFiles],
      isPinned: _isPinned,
    );

    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('게시글이 임시저장되었습니다.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _submitPost() async {
    if (_selectedBoard == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('게시판을 선택해 주세요.'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('제목과 내용을 모두 입력해 주세요.'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final dto = CreatePostRequestDto(
      clubId: widget.clubId,
      boardCategory: _selectedBoard!,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      tags: _tags,
      attachments: [..._selectedPhotos, ..._selectedFiles],
      isPinned: _effectiveIsPresident && _isPinned,
    );

    final String authorName = _effectiveIsPresident ? '회장 김신구' : '박시현';

    final createdPost = await BoardRepository.instance.createPost(
      dto,
      authorName: authorName,
    );

    if (!mounted) return;
    Navigator.pop(context, createdPost);
  }

  @override
  Widget build(BuildContext context) {
    final isPresident = _effectiveIsPresident;
    final draftCount = BoardRepository.instance.getDrafts(widget.clubId).length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF191919), size: 24.0),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _showDraftsSheet,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF555555),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
            ),
            child: Text(
              '임시 $draftCount',
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: _saveCurrentAsDraft,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF555555),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
            ),
            child: const Text(
              '임시저장',
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 6.0),
            child: Center(
              child: GestureDetector(
                onTap: _submitPost,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 7.0,
                  ),
                  decoration: BoxDecoration(
                    color: _canSubmit
                        ? const Color(0xFF8CC63F)
                        : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    '등록',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: _canSubmit
                          ? Colors.white
                          : const Color(0xFF8CC63F),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 게시판 선택 드롭다운 영역
          InkWell(
            onTap: _showBoardSelector,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15.0,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedBoard ?? '게시판을 선택하세요',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: _selectedBoard != null
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: const Color(0xFF191919),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF555555),
                    size: 22.0,
                  ),
                ],
              ),
            ),
          ),

          // 회장 UI 전용: 게시물 상단 고정 옵션
          if (isPresident)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 6.0,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFFAFAFA),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.push_pin_outlined,
                    size: 18.0,
                    color: Color(0xFF8CC63F),
                  ),
                  const SizedBox(width: 8.0),
                  const Expanded(
                    child: Text(
                      '게시판 상단 필독 공지로 고정',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  Switch(
                    value: _isPinned,
                    activeThumbColor: Colors.white,
                    activeTrackColor: const Color(0xFF8CC63F),
                    onChanged: (val) {
                      setState(() {
                        _isPinned = val;
                      });
                    },
                  ),
                ],
              ),
            ),

          // 제목 입력
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _titleController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF191919),
              ),
              decoration: const InputDecoration(
                hintText: '제목',
                hintStyle: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9E9E9E),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ),
          const Divider(
            height: 1.0,
            thickness: 1.0,
            indent: 20.0,
            endIndent: 20.0,
            color: Color(0xFFEEEEEE),
          ),

          // 본문 입력
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _contentController,
                onChanged: (_) => setState(() {}),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Color(0xFF191919),
                  height: 1.55,
                ),
                decoration: const InputDecoration(
                  hintText: '내용을 입력하세요.',
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Color(0xFF9E9E9E),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ),
          ),

          // 첨부 사진 / 첨부 파일 / 태그 미리보기 영역
          if (_selectedPhotos.isNotEmpty ||
              _selectedFiles.isNotEmpty ||
              _tags.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              decoration: const BoxDecoration(
                color: Color(0xFFFAFAFA),
                border: Border(
                  top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 선택된 사진 썸네일 리스트
                  if (_selectedPhotos.isNotEmpty) ...[
                    SizedBox(
                      height: 68.0,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedPhotos.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8.0),
                        itemBuilder: (context, index) {
                          final photo = _selectedPhotos[index];
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  photo.fileUrl,
                                  width: 68.0,
                                  height: 68.0,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 68.0,
                                        height: 68.0,
                                        color: const Color(0xFFE8F5E9),
                                        child: const Icon(
                                          Icons.image,
                                          color: Color(0xFF8CC63F),
                                        ),
                                      ),
                                ),
                              ),
                              Positioned(
                                top: 3.0,
                                right: 3.0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedPhotos.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    width: 18.0,
                                    height: 18.0,
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 12.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8.0),
                  ],

                  // 선택된 파일 리스트
                  if (_selectedFiles.isNotEmpty) ...[
                    ...List.generate(_selectedFiles.length, (index) {
                      final file = _selectedFiles[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 7.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.insert_drive_file_outlined,
                              size: 16.0,
                              color: Color(0xFF555555),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                '${file.fileName} (${file.formattedSize})',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Color(0xFF333333),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedFiles.removeAt(index);
                                });
                              },
                              child: const Icon(
                                Icons.close,
                                size: 16.0,
                                color: Color(0xFF9E9E9E),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  // 추가된 태그 칩
                  if (_tags.isNotEmpty)
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: List.generate(_tags.length, (index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F8E9),
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '#${_tags[index]}',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF8CC63F),
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _tags.removeAt(index);
                                  });
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 13.0,
                                  color: Color(0xFF8CC63F),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                ],
              ),
            ),

          // 하단 기능 툴바 (사진 선택 / 파일 선택 / 태그 추가)
          SafeArea(
            top: false,
            child: Container(
              height: 50.0,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  _buildToolbarButton(
                    icon: Icons.image_outlined,
                    label: '사진',
                    onTap: _showPhotoPickerSheet,
                  ),
                  const SizedBox(width: 8.0),
                  _buildToolbarButton(
                    icon: Icons.attach_file,
                    label: '파일',
                    onTap: _showFilePickerSheet,
                  ),
                  const SizedBox(width: 8.0),
                  _buildToolbarButton(
                    icon: Icons.tag,
                    label: '태그',
                    onTap: _showAddTagDialog,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 20.0, color: const Color(0xFF555555)),
            const SizedBox(width: 5.0),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF555555),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
