import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BannerDetailScreen extends StatelessWidget {
  final String bannerImage;
  final String title;
  final String date;
  final String location;
  final String participants;
  final String shareUrl;
  final List? clubTags;

  const BannerDetailScreen({
    super.key,
    required this.bannerImage,
    required this.title,
    required this.date,
    required this.location,
    required this.participants,
    this.shareUrl = 'shingu.club/banner/20261010/sg',
    this.clubTags,
  });

  void _showShareBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '공유',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF191919),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                      color: Color(0xFF757575),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // 링크 복사 박스
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        shareUrl,
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF757575),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: shareUrl));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('링크가 복사되었습니다.'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const Text(
                        '링크 복사',
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8CC63F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              // SNS 공유 채널 목록
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildShareIcon(
                      Icons.camera_alt,
                      '인스타그램',
                      const Color(0xFFE1306C),
                    ),
                    const SizedBox(width: 16.0),
                    _buildShareIcon(
                      Icons.chat_bubble,
                      '카카오톡',
                      const Color(0xFFFFEB3B),
                    ),
                    const SizedBox(width: 16.0),
                    _buildShareIcon(
                      Icons.link,
                      '링크 복사',
                      const Color(0xFF757575),
                    ),
                    const SizedBox(width: 16.0),
                    _buildShareIcon(
                      Icons.facebook,
                      'Facebook',
                      const Color(0xFF1877F2),
                    ),
                    const SizedBox(width: 16.0),
                    _buildShareIcon(Icons.close, 'X', const Color(0xFF000000)),
                    const SizedBox(width: 16.0),
                    _buildShareIcon(
                      Icons.message,
                      'SMS',
                      const Color(0xFF4CAF50),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 52.0,
          height: 52.0,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24.0),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: const TextStyle(fontSize: 11.0, color: Color(0xFF757575)),
        ),
      ],
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share_outlined,
              color: Colors.black,
              size: 22,
            ),
            onPressed: () => _showShareBottomSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 배너 상세 포스터 이미지 (가로 폭에 맞춰 원본 비율 유지)
            Image.asset(
              bannerImage,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 320.0,
                width: double.infinity,
                color: const Color(0xFFF2F4F7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '이미지 경로 확인: $bannerImage',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // 일정, 장소, 참여 대상 정보
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  _buildInfoRow(Icons.calendar_today_outlined, '일정', date),
                  const SizedBox(height: 16.0),
                  _buildInfoRow(Icons.location_on_outlined, '장소', location),
                  const SizedBox(height: 16.0),
                  _buildInfoRow(Icons.people_outline, '참여', participants),
                ],
              ),
            ),

            // 참여 동아리 태그 (축제 등 해당 배너에 태그가 있을 때만 표시)
            if (clubTags != null && clubTags!.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 16.0),
                child: Text(
                  '참여 동아리',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191919),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: clubTags!.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: const Color(0xFFEEEEEE)),
                      ),
                      child: Text(
                        tag.toString(),
                        style: const TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
            const SizedBox(height: 48.0),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Icon(icon, size: 20.0, color: const Color(0xFF555555)),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Color(0xFF9E9E9E),
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF191919),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
