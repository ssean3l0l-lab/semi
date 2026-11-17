import 'package:flutter/material.dart';

import '../../models/club_models.dart';
import '../../services/club_repository.dart';
import 'club_apply_screen.dart';
import 'club_news_screen.dart';

typedef GridItemMap = Map<String, dynamic>;

class ClubDetailScreen extends StatefulWidget {
  final int clubId;
  final ClubModel? initialClub;
  final bool? isPresident;

  const ClubDetailScreen({
    super.key,
    required this.clubId,
    this.initialClub,
    this.isPresident,
  });

  @override
  State<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends State<ClubDetailScreen> {
  ClubModel? _club;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _club = widget.initialClub;
    if (_club != null) {
      ClubNewsScreen.ensureClubInitialized(_club!.clubName, _club!.newsImages);
    }
    _loadClubDetail();
  }

  Future<void> _loadClubDetail() async {
    final detail = await ClubRepository.instance.fetchClubDetail(widget.clubId);
    if (!mounted) return;
    ClubNewsScreen.ensureClubInitialized(detail.clubName, detail.newsImages);
    setState(() {
      _club = detail;
      _isLoading = false;
    });
  }

  List<GridItemMap> _getSyncedGridItems(String clubName) {
    final orderedPosts = ClubNewsScreen.getPostsForClub(clubName);
    final List<GridItemMap> gridItems = [];

    for (var item in orderedPosts) {
      final post = item as Map<dynamic, dynamic>;
      final imgInfo = post['image'];
      final bool isPinned = post['isPinned'] == true;
      String? thumbPath;

      if (imgInfo is List && imgInfo.isNotEmpty) {
        thumbPath = imgInfo[0].toString();
      } else if (imgInfo != null) {
        thumbPath = imgInfo.toString();
      }

      if (thumbPath != null) {
        gridItems.add({'image': thumbPath, 'isPinned': isPinned});
      }
    }

    return gridItems.take(9).toList();
  }

  Widget _buildImage(
    String path, {
    double? width,
    double? height,
    required Widget fallback,
  }) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      );
    }
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => fallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    final club = _club;

    if (club == null && _isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            '동아리 상세 정보',
            style: TextStyle(
              color: Color(0xFF191919),
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          centerTitle: false,
          titleSpacing: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF8CC63F)),
        ),
      );
    }

    final currentClub = club!;
    final displayItems = _getSyncedGridItems(currentClub.clubName);
    final bool isRecruiting = currentClub.isRecruiting;
    final bool isJoined = ClubRepository.instance.isClubJoined(
      currentClub.clubId,
    );
    final bool canApply = isRecruiting && !isJoined;

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
          '동아리 상세 정보',
          style: TextStyle(
            color: Color(0xFF191919),
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(
                  currentClub.logoUrl,
                  height: 200.0,
                  width: double.infinity,
                  fallback: Container(
                    height: 200.0,
                    color: const Color(0xFF263238),
                    child: Center(
                      child: Text(
                        currentClub.clubName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F8E9),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Text(
                              currentClub.category,
                              style: const TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8CC63F),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: isRecruiting
                                  ? const Color(0xFFE0F2F1)
                                  : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Text(
                              currentClub.statusLabel,
                              style: TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.bold,
                                color: isRecruiting
                                    ? const Color(0xFF00897B)
                                    : const Color(0xFF9E9E9E),
                              ),
                            ),
                          ),
                          if (isRecruiting) ...[
                            const SizedBox(width: 8.0),
                            Text(
                              currentClub.formattedDeadline,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Color(0xFF9E9E9E),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        currentClub.clubName,
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF191919),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        currentClub.description,
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF757575),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: const Color(0xFFEEEEEE)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 70,
                                  child: Text(
                                    '활동 내용',
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF555555),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: currentClub.activities.isEmpty
                                      ? const Text(
                                          '등록된 활동 내용이 없습니다.',
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: Color(0xFF9E9E9E),
                                          ),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: currentClub.activities
                                              .map(
                                                (act) => Text(
                                                  '• $act',
                                                  style: const TextStyle(
                                                    fontSize: 13.0,
                                                    color: Color(0xFF757575),
                                                    height: 1.5,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Divider(
                                height: 1.0,
                                color: Color(0xFFEEEEEE),
                              ),
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 70,
                                  child: Text(
                                    '정기 모임',
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF555555),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    currentClub.meetingTime.isEmpty
                                        ? '추후 공지'
                                        : '${currentClub.meetingTime} (${currentClub.location})',
                                    style: const TextStyle(
                                      fontSize: 13.0,
                                      color: Color(0xFF757575),
                                    ),
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
                const SizedBox(height: 32.0),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    '동아리 소식',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF191919),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: displayItems.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F9F9),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Center(
                            child: Text(
                              '등록된 동아리 소식이 없습니다.',
                              style: TextStyle(
                                color: Color(0xFF9E9E9E),
                                fontSize: 13.0,
                              ),
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                childAspectRatio: 1.0,
                              ),
                          itemCount: displayItems.length,
                          itemBuilder: (context, index) {
                            final gridItem = displayItems[index];
                            final String imgPath = gridItem['image'].toString();
                            final bool isPinned = gridItem['isPinned'] == true;

                            return GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClubNewsScreen(
                                      clubName: currentClub.clubName,
                                      clubLogo: currentClub.logoUrl,
                                      isPresident: widget.isPresident,
                                    ),
                                  ),
                                );
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    _buildImage(
                                      imgPath,
                                      fallback: Container(
                                        color: const Color(0xFFF0F0F0),
                                      ),
                                    ),
                                    if (isPinned)
                                      Positioned(
                                        top: 8.0,
                                        right: 8.0,
                                        child: Icon(
                                          Icons.push_pin,
                                          color: Colors.white,
                                          size: 18.0,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.5,
                                              ),
                                              blurRadius: 4.0,
                                              offset: const Offset(0, 1),
                                            ),
                                            Shadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.25,
                                              ),
                                              blurRadius: 8.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 32.0),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    '자주 묻는 질문',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF191919),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                if (currentClub.faqs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      '등록된 자주 묻는 질문이 없습니다.',
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: currentClub.faqs.length,
                    itemBuilder: (context, index) {
                      final faq = currentClub.faqs[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: const Color(0xFFEEEEEE)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Q. ${faq.question}',
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF191919),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'A. ${faq.answer}',
                              style: const TextStyle(
                                fontSize: 13.0,
                                color: Color(0xFF757575),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
                  onPressed: canApply
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClubApplyScreen(
                                clubName: currentClub.clubName,
                                clubLogo: currentClub.logoUrl,
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
                    isJoined
                        ? '이미 가입한 동아리입니다'
                        : (isRecruiting ? '지원서 작성하기' : '모집이 마감되었습니다'),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: canApply ? Colors.white : const Color(0xFF9E9E9E),
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
}
