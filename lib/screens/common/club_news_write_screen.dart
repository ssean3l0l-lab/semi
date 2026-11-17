import 'package:flutter/material.dart';

import 'club_news_drafts_screen.dart'; // ★ 새로 만든 임시 보관함 화면 임포트

class ClubNewsWriteScreen extends StatefulWidget {
  final String clubName;
  final String clubLogo;
  final List selectedImages;

  const ClubNewsWriteScreen({
    super.key,
    required this.clubName,
    required this.clubLogo,
    required this.selectedImages,
  });

  static final List draftPosts = [];

  @override
  State createState() => _ClubNewsWriteScreenState();
}

class _ClubNewsWriteScreenState extends State {
  late List _images;
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final screenWidget = widget as ClubNewsWriteScreen;
    _images = List.from(screenWidget.selectedImages);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  // 트위터 날짜 포맷(YY/MM/DD) 생성 헬퍼
  String _getFormattedDate() {
    final now = DateTime.now();
    final yy = now.year.toString().substring(2);
    final mm = now.month.toString().padLeft(2, '0');
    final dd = now.day.toString().padLeft(2, '0');
    return '$yy/$mm/$dd';
  }

  Future _handleExitConfirm() async {
    if (_contentController.text.trim().isEmpty && _images.isEmpty) {
      return 'discard';
    }

    final screenWidget = widget as ClubNewsWriteScreen;

    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          '임시저장',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        content: const Text('작성 중인 게시물을 임시저장하시겠습니까?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'discard'),
            child: const Text(
              '저장 안 함',
              style: TextStyle(color: Color(0xFF9E9E9E)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'saved'),
            child: const Text(
              '임시저장',
              style: TextStyle(
                color: Color(0xFF8CC63F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (result == 'saved') {
      // 동아리 이름을 함께 저장하여 다른 동아리와 섞이지 않도록 처리
      ClubNewsWriteScreen.draftPosts.insert(0, {
        'clubName': screenWidget.clubName,
        'date': _getFormattedDate(),
        'images': List.from(_images),
        'content': _contentController.text,
      });
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('게시물이 임시저장되었습니다.')));
      }
      return 'saved';
    } else if (result == 'discard') {
      return 'discard';
    }
    return null;
  }

  void _navigateAfterExit(String action) {
    if (!mounted) return;
    final navigator = Navigator.of(context);
    if (action == 'saved') {
      navigator.pop();
      navigator.pop();
    } else if (action == 'discard') {
      navigator.pop();
    }
  }

  // ★ 상단 '임시저장' 클릭 시 전용 임시 보관함 화면으로 이동
  Future _openDraftsScreen() async {
    final screenWidget = widget as ClubNewsWriteScreen;

    final selectedDraft = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ClubNewsDraftsScreen(clubName: screenWidget.clubName),
      ),
    );

    if (selectedDraft != null && selectedDraft is Map) {
      setState(() {
        _images = List.from(selectedDraft['images'] as List);
        _contentController.text = selectedDraft['content'].toString();
      });
    }
  }

  void _submitNewPost() {
    if (_contentController.text.trim().isEmpty && _images.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('사진이나 내용을 입력해 주세요.')));
      return;
    }

    final screenWidget = widget as ClubNewsWriteScreen;

    final newPost = {
      'clubName': screenWidget.clubName,
      'timeAgo': '방금',
      'image': _images.isNotEmpty
          ? List.from(_images)
          : ['assets/images/news1.png'],
      'content': _contentController.text,
      'likes': 0,
      'isLiked': false,
      'shareUrl': 'shingu.club/feed/new-post',
      'comments': [],
    };

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('게시물이 성공적으로 등록되었습니다.')));

    final navigator = Navigator.of(context);
    navigator.pop(newPost);
    navigator.pop(newPost);
  }

  Future _onCloseButtonPressed() async {
    final action = await _handleExitConfirm();
    if (action != null) {
      _navigateAfterExit(action.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidget = widget as ClubNewsWriteScreen;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final action = await _handleExitConfirm();
        if (action != null) {
          _navigateAfterExit(action.toString());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF191919)),
            onPressed: _onCloseButtonPressed,
          ),
          title: const Text(''),
          centerTitle: false,
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: TextButton(
                  onPressed: _openDraftsScreen,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    '임시저장',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF555555),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Container(
                  height: 32.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextButton(
                    onPressed: _submitNewPost,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      '등록',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8CC63F),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      screenWidget.clubLogo,
                      width: 36.0,
                      height: 36.0,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) =>
                          Container(width: 36, height: 36, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    screenWidget.clubName,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF191919),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: 160.0,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(canvasColor: Colors.transparent),
                  child: ReorderableListView.builder(
                    scrollDirection: Axis.horizontal,
                    buildDefaultDragHandles: false,
                    proxyDecorator:
                        (Widget child, int index, Animation animation) {
                          return Material(
                            color: Colors.transparent,
                            elevation: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: child,
                            ),
                          );
                        },
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex -= 1;
                        final item = _images.removeAt(oldIndex);
                        _images.insert(newIndex, item);
                      });
                    },
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return ReorderableDragStartListener(
                        key: ValueKey(_images[index]),
                        index: index,
                        child: Container(
                          width: 160.0,
                          margin: const EdgeInsets.only(right: 12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.asset(
                                  _images[index].toString(),
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) =>
                                      Container(color: Colors.grey),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _images.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    width: 28.0,
                                    height: 28.0,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
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
                ),
              ),
              const SizedBox(height: 24.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _contentController,
                      maxLines: 10,
                      maxLength: 2000,
                      decoration: const InputDecoration(
                        hintText: '동아리 소식을 공유해 주세요.',
                        hintStyle: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 14.0,
                        ),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      style: const TextStyle(
                        fontSize: 14.0,
                        height: 1.5,
                        color: Color(0xFF191919),
                      ),
                      onChanged: (val) => setState(() {}),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '${_contentController.text.length} / 2,000',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
