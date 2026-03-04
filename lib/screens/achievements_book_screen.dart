import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/stamp.dart';
import '../providers/quiz_provider.dart';

class AchievementsBookScreen extends StatefulWidget {
  const AchievementsBookScreen({super.key});

  @override
  State<AchievementsBookScreen> createState() => _AchievementsBookScreenState();
}

class _AchievementsBookScreenState extends State<AchievementsBookScreen> {
  final PageController _pageController = PageController();
  int _currentViewIndex = 0; // 0 for first 4 stamps, 1 for next 4, etc.

  // Total stamps = gameStamps.length
  // 6 stamps per view (2 pages side by side, 3 stamps per page top/mid/bottom)
  late int _totalViews;

  @override
  void initState() {
    super.initState();
    _totalViews = (gameStamps.length / 6).ceil();
    _pageController.addListener(() {
      int next = _pageController.page?.round() ?? 0;
      if (next != _currentViewIndex) {
        setState(() {
          _currentViewIndex = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50], // Book cover color behind
      appBar: AppBar(
        title: const Text(
          'Achievements Book',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal[800],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Pages color
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(5, 5),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                // Left arrow
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.teal),
                  onPressed: _currentViewIndex > 0
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
                // Book Pages
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _totalViews,
                    itemBuilder: (context, viewIndex) {
                      return _buildBookSpread(viewIndex);
                    },
                  ),
                ),
                // Right arrow
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.teal),
                  onPressed: _currentViewIndex < _totalViews - 1
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookSpread(int viewIndex) {
    int startIndex = viewIndex * 6;
    return CustomPaint(
      painter: DashedCrossPainter(color: Colors.teal.withValues(alpha: 0.3)),
      child: Column(
        children: [
          // Top Row
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCardWrapper(startIndex, context), // Top-Left
                _buildCardWrapper(startIndex + 1, context), // Top-Right
              ],
            ),
          ),
          // Middle Row
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCardWrapper(startIndex + 2, context), // Mid-Left
                _buildCardWrapper(startIndex + 3, context), // Mid-Right
              ],
            ),
          ),
          // Bottom Row
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCardWrapper(startIndex + 4, context), // Bot-Left
                _buildCardWrapper(startIndex + 5, context), // Bot-Right
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardWrapper(int stampIndex, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _buildStampSlot(stampIndex),
      ),
    );
  }

  Widget _buildStampSlot(int stampIndex) {
    if (stampIndex >= gameStamps.length) {
      // Empty slot if we ran out of stamps
      return const SizedBox();
    }

    final stamp = gameStamps[stampIndex];
    final provider = Provider.of<QuizProvider>(context);
    final isUnlocked = provider.unlockedStamps.contains(stamp.id);

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Stamp Icon Image
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isUnlocked ? Colors.teal : Colors.grey,
                width: 3,
              ),
              color: isUnlocked ? Colors.white : Colors.grey[200],
            ),
            child: ClipOval(
              child: isUnlocked
                  ? Image.asset(stamp.iconPath, fit: BoxFit.cover)
                  : ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcATop,
                      ),
                      child: Image.asset(stamp.iconPath, fit: BoxFit.cover),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          // Title
          Text(
            stamp.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.teal, // Title is always visible
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          // Description
          Expanded(
            child: Text(
              isUnlocked ? stamp.description : '???',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: isUnlocked ? Colors.black87 : Colors.black54,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class DashedCrossPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedCrossPainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.dashWidth = 8.0,
    this.dashSpace = 6.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw Vertical Dashed Line
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Draw Horizontal Dashed Lines (at 1/3 and 2/3)
    for (int i = 1; i <= 2; i++) {
      double startX = 0;
      double y = size.height * i / 3;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, y),
          Offset(startX + dashWidth, y),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedCrossPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
  }
}
