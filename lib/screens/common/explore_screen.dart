import 'package:flutter/material.dart';

import '../../models/club_models.dart';
import '../../services/club_repository.dart';
import 'club_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  static const List<String> _categories = [
    '전체',
    '학술',
    '체육/스포츠',
    '문화/예술',
    '사회/봉사',
  ];

  String _selectedCategory = '전체';
  String _searchQuery = '';
  bool _isLoading = true;
  List<ClubModel> _allClubs = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadClubs();
  }

  Future<void> _loadClubs() async {
    final ClubList clubs = await ClubRepository.instance.fetchClubs();
    if (!mounted) return;
    setState(() {
      _allClubs = clubs;
      _isLoading = false;
    });
  }

  List<ClubModel> get _filteredClubs {
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      return _allClubs
          .where((club) => club.clubName.toLowerCase().contains(query))
          .toList();
    }
    if (_selectedCategory == '전체') {
      return _allClubs;
    }
    return _allClubs
        .where((club) => club.category == _selectedCategory)
        .toList();
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
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    }
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => fallback,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredClubs = _filteredClubs;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20.0,
        title: const Text(
          '동아리 탐색',
          style: TextStyle(
            color: Color(0xFF191919),
            fontWeight: FontWeight.w800,
            fontSize: 20.0,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              height: 46.0,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: Color(0xFF9E9E9E),
                    size: 20.0,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        setState(() {
                          _searchQuery = value.trim();
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: '관심 있는 동아리를 검색해보세요',
                        hintStyle: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 14.0,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      child: const Icon(
                        Icons.cancel,
                        color: Color(0xFFBDBDBD),
                        size: 18.0,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8.0),

          if (_searchQuery.isEmpty) ...[
            SizedBox(
              height: 40.0,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 8.0);
                },
                itemBuilder: (BuildContext context, int index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF8CC63F)
                            : const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF757575),
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12.0),
          ],

          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF8CC63F)),
                  )
                : filteredClubs.isEmpty
                ? const Center(
                    child: Text(
                      '검색 결과가 없습니다.',
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 15.0,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    color: const Color(0xFF8CC63F),
                    onRefresh: _loadClubs,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8.0,
                      ),
                      itemCount: filteredClubs.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 20.0);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        final club = filteredClubs[index];
                        final bool isRecruiting = club.isRecruiting;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClubDetailScreen(
                                  clubId: club.clubId,
                                  initialClub: club,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: const Color(0xFFEEEEEE),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20.0),
                                  ),
                                  child: _buildImage(
                                    club.bannerUrl,
                                    height: 140.0,
                                    width: double.infinity,
                                    fallback: Container(
                                      height: 140.0,
                                      color: const Color(0xFFE8F5E9),
                                      child: const Center(
                                        child: Icon(
                                          Icons.image,
                                          color: Color(0xFF8CC63F),
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          12.0,
                                        ),
                                        child: _buildImage(
                                          club.logoUrl,
                                          width: 44.0,
                                          height: 44.0,
                                          fallback: Container(
                                            width: 44.0,
                                            height: 44.0,
                                            color: const Color(0xFFF1F8E9),
                                            child: const Center(
                                              child: Icon(
                                                Icons.group,
                                                color: Color(0xFF8CC63F),
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    club.clubName,
                                                    style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF191919),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 8.0),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6.0,
                                                        vertical: 2.0,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: isRecruiting
                                                        ? const Color(
                                                            0xFFF1F8E9,
                                                          )
                                                        : const Color(
                                                            0xFFF5F5F5,
                                                          ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4.0,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    club.statusLabel,
                                                    style: TextStyle(
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isRecruiting
                                                          ? const Color(
                                                              0xFF8CC63F,
                                                            )
                                                          : const Color(
                                                              0xFF9E9E9E,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              club.category,
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: Color(0xFF9E9E9E),
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(
                                              club.description,
                                              style: const TextStyle(
                                                fontSize: 13.0,
                                                color: Color(0xFF555555),
                                                height: 1.3,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
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
          ),
        ],
      ),
    );
  }
}
