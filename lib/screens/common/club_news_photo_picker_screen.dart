import 'package:flutter/material.dart';

import 'club_news_write_screen.dart';

class ClubNewsPhotoPickerScreen extends StatefulWidget {
  final String clubName;
  final String clubLogo;

  const ClubNewsPhotoPickerScreen({
    super.key,
    required this.clubName,
    required this.clubLogo,
  });

  @override
  State createState() => _ClubNewsPhotoPickerScreenState();
}

class _ClubNewsPhotoPickerScreenState extends State {
  final List _dummyGallery = [
    'assets/images/news1.png',
    'assets/images/news2.png',
    'assets/images/banner_helloworld.png',
    'assets/images/cube.png',
    'assets/images/oleum.png',
  ];

  final List _selectedImages = [];

  @override
  Widget build(BuildContext context) {
    final screenWidget = widget as ClubNewsPhotoPickerScreen;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF191919)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Text(
              '전체보기',
              style: TextStyle(
                color: Color(0xFF191919),
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(width: 4.0),
            Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF191919),
              size: 20.0,
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: _selectedImages.isNotEmpty
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClubNewsWriteScreen(
                              clubName: screenWidget.clubName,
                              clubLogo: screenWidget.clubLogo,
                              selectedImages: List.from(_selectedImages),
                            ),
                          ),
                        );
                      }
                    : null,
                child: Text(
                  '${_selectedImages.length} 선택',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: _selectedImages.isNotEmpty
                        ? const Color(0xFF8CC63F)
                        : const Color(0xFFBDBDBD),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_selectedImages.isNotEmpty)
            Container(
              height: 90.0,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              color: const Color(0xFFFAFAFA),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 12.0),
                itemBuilder: (context, index) {
                  final imgPath = _selectedImages[index].toString();
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          imgPath,
                          width: 74.0,
                          height: 74.0,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            width: 74,
                            height: 74,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedImages.remove(imgPath)),
                          child: Container(
                            width: 22.0,
                            height: 22.0,
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(2.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
                childAspectRatio: 1.0,
              ),
              itemCount: _dummyGallery.length,
              itemBuilder: (context, index) {
                final imgPath = _dummyGallery[index].toString();
                final isSelected = _selectedImages.contains(imgPath);
                final selectedIndex = _selectedImages.indexOf(imgPath) + 1;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedImages.remove(imgPath);
                      } else {
                        // 요구사항 1: 최대 5개까지만 선택 가능 제한
                        if (_selectedImages.length >= 5) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('사진은 최대 5개까지만 선택할 수 있습니다.'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                          return;
                        }
                        _selectedImages.add(imgPath);
                      }
                    });
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        imgPath,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) =>
                            Container(color: Colors.grey),
                      ),
                      if (isSelected)
                        Container(
                          color: Colors.black.withValues(alpha: 0.3),
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 26.0,
                            height: 26.0,
                            decoration: const BoxDecoration(
                              color: Color(0xFF8CC63F),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$selectedIndex',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
