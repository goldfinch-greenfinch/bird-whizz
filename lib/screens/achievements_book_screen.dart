import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/stamp.dart';
import '../providers/quiz_provider.dart';

abstract class AchievementItem {}

class TitlePageItem extends AchievementItem {}

class StampItem extends AchievementItem {
  final Stamp stamp;
  StampItem(this.stamp);
}

class SubheadingItem extends AchievementItem {
  final String title;
  SubheadingItem(this.title);
}

class AchievementsBookScreen extends StatefulWidget {
  const AchievementsBookScreen({super.key});

  @override
  State<AchievementsBookScreen> createState() => _AchievementsBookScreenState();
}

class _AchievementsBookScreenState extends State<AchievementsBookScreen> {
  final PageController _pageController = PageController();
  int _currentViewIndex = 0;
  late List<List<AchievementItem>> _pages;
  late int _totalViews;

  @override
  void initState() {
    super.initState();
    _pages = _buildPages();
    // A spread has 2 pages (top and bottom)
    _totalViews = (_pages.length / 2).ceil();
    _pageController.addListener(() {
      int next = _pageController.page?.round() ?? 0;
      if (next != _currentViewIndex) {
        setState(() {
          _currentViewIndex = next;
        });
      }
    });
  }

  List<List<AchievementItem>> _buildPages() {
    List<List<AchievementItem>> pages = [];

    Stamp getStamp(String id) => gameStamps.firstWhere((s) => s.id == id);

    void addSection(String title, List<String> stampIds) {
      List<AchievementItem> currentPage = [];
      currentPage.add(SubheadingItem(title));

      for (String id in stampIds) {
        if (currentPage.length == 4) {
          pages.add(currentPage);
          currentPage = [];
        }
        currentPage.add(StampItem(getStamp(id)));
      }

      if (currentPage.isNotEmpty) {
        pages.add(currentPage);
      }
    }

    // 0. The Cover / Title Page
    pages.add([TitlePageItem()]);

    // 1. General Progress
    addSection('General Progress', [
      'time_flies',
      'frequent_flyer',
      'weekend_warrior',
      'first_flight',
      'star_collector',
      'flock_starter',
      'dedicated_birder',
      'level_100',
      'trivia_master',
      'century_club',
      'smart_cookie',
      'know_it_owl',
      'quiz_guru',
      'quiz_whiz',
      'marathon_flyer',
      'legendary_watcher',
      'avian_apprentice',
      'master_ornithologist',
      'constellation',
      'perfectionist',
      'flawless_flyer',
      'flawless_flock',
      'flawless_master',
      'dedicated_watcher',
    ]);

    // 2. Section Masters (8 stamps)
    addSection('Section Masters', [
      'trivia_complete',
      'biology_complete',
      'habitat_complete',
      'conservation_complete',
      'behaviour_complete',
      'families_complete',
      'migration_complete',
      'colours_complete',
    ]);

    // 3. Category Enthusiasts
    addSection('Topic Fanatics', [
      'trivia_addict',
      'biology_buff',
      'habitat_hero',
      'conservation_champion',
      'behavior_boss',
      'family_fanatic',
      'migration_marvel',
      'colours_champ',
      'trivia_titan',
      'biology_brain',
      'habitat_hound',
    ]);

    // 4. Word Games
    addSection('Word Games', [
      'vocab_virtuoso',
      'wordsmith',
      'anagram_ace',
      'scramble_legend',
      'spelling_bee',
      'spelling_master',
      'scramble_champion',
      'scramble_master',
    ]);

    // 5. Bird ID
    addSection('Eagle Eye Challenges', [
      'id_easy_complete',
      'id_medium_complete',
      'id_hard_complete',
      'identification_expert',
      'id_master',
      'sharp_shooter',
      'hawk_eyed',
      'bird_paparazzi',
      'id_legend',
    ]);

    // Ensure even number of pages so bottom page index is always valid
    if (pages.length % 2 != 0) {
      pages.add([]);
    }

    return pages;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Field Guide',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.brown[800],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: Colors.brown[900],
      body: Stack(
        children: [
          // Background Generated Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/rustic_wood_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  'Spread ${_currentViewIndex + 1} of $_totalViews (Swipe Up/Down)',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: PageView.builder(
                      controller: _pageController,
                      scrollDirection:
                          Axis.vertical, // Calendar flip horizontally
                      itemCount: _totalViews,
                      itemBuilder: (context, index) {
                        return _buildBookSpread(index);
                      },
                    ),
                  ),
                ),
                // Indicator Arrow
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.keyboard_double_arrow_up,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookSpread(int viewIndex) {
    int topPageIndex = viewIndex * 2;
    int bottomPageIndex = topPageIndex + 1;

    List<AchievementItem> topPageItems = topPageIndex < _pages.length
        ? _pages[topPageIndex]
        : [];
    List<AchievementItem> bottomPageItems = bottomPageIndex < _pages.length
        ? _pages[bottomPageIndex]
        : [];

    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(bottom: 25, top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(8, 12),
              blurRadius: 20,
            ),
            BoxShadow(
              color: Colors.black26, // Inner ambient shadow
              offset: Offset(-2, -2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                // Top Page (flips away upwards)
                Expanded(child: _buildPage(topPageItems, isTopPage: true)),
                // Bottom Page (flips in from below)
                Expanded(child: _buildPage(bottomPageItems, isTopPage: false)),
              ],
            ),
            // Middle Spiral seam overlay!
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: CustomPaint(
                  size: const Size(double.infinity, 30),
                  painter: HorizontalSpiralPainter(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(
    List<AchievementItem> pageItems, {
    required bool isTopPage,
  }) {
    if (pageItems.isNotEmpty && pageItems.first is TitlePageItem) {
      return _buildTitlePageDecoration(isTopPage: isTopPage);
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2E2),
        image: const DecorationImage(
          image: AssetImage('assets/images/vintage_paper_texture.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isTopPage ? 10 : 0),
          topRight: Radius.circular(isTopPage ? 10 : 0),
          bottomLeft: Radius.circular(!isTopPage ? 10 : 0),
          bottomRight: Radius.circular(!isTopPage ? 10 : 0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: isTopPage ? 15.0 : 30.0, // push away from the center spiral
          bottom: isTopPage ? 30.0 : 15.0,
          left: 10.0,
          right: 10.0,
        ),
        child: Column(
          children: [
            Expanded(child: _buildRow(pageItems, 0, 1)),
            Expanded(child: _buildRow(pageItems, 2, 3)),
          ],
        ),
      ),
    );
  }

  Widget _buildTitlePageDecoration({required bool isTopPage}) {
    final provider = Provider.of<QuizProvider>(context);
    final totalStamps = gameStamps.length;
    final unlockedStamps = provider.unlockedStamps.length;
    final percent = (unlockedStamps / totalStamps * 100).toStringAsFixed(1);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2E2),
        image: const DecorationImage(
          image: AssetImage('assets/images/vintage_paper_texture.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isTopPage ? 10 : 0),
          topRight: Radius.circular(isTopPage ? 10 : 0),
          bottomLeft: Radius.circular(!isTopPage ? 10 : 0),
          bottomRight: Radius.circular(!isTopPage ? 10 : 0),
        ),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 80,
                  color: Colors.brown[800],
                ),
                const SizedBox(height: 20),
                Text(
                  'FIELD GUIDE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4.0,
                    color: Colors.brown[900],
                    shadows: [
                      Shadow(
                        color: Colors.brown.withOpacity(0.3),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'A Record of Avian Discoveries',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.brown[700],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.brown[800]!, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$percent%',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.brown[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$unlockedStamps / $totalStamps Stamps Found',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.brown[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<AchievementItem> pageItems, int index1, int index2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _buildSlot(pageItems, index1)),
        Expanded(child: _buildSlot(pageItems, index2)),
      ],
    );
  }

  Widget _buildSlot(List<AchievementItem> pageItems, int index) {
    if (index >= pageItems.length) {
      return const SizedBox();
    }
    final item = pageItems[index];
    if (item is SubheadingItem) {
      return _buildSubheading(item);
    } else if (item is StampItem) {
      return _buildStamp(item.stamp);
    }
    return const SizedBox();
  }

  Widget _buildSubheading(SubheadingItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          border: const Border(
            bottom: BorderSide(color: Colors.brown, width: 2),
            top: BorderSide(color: Colors.brown, width: 2),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          item.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.brown[900],
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildStamp(Stamp stamp) {
    final provider = Provider.of<QuizProvider>(context);
    final isUnlocked = provider.unlockedStamps.contains(stamp.id);

    return GestureDetector(
      onTap: () {
        _showStampDialog(stamp, isUnlocked);
      },
      child: Container(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Image
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isUnlocked
                        ? Colors.brown[800]!
                        : Colors.brown[300]!.withOpacity(0.4),
                    width: isUnlocked ? 3 : 2,
                  ),
                  color: isUnlocked ? Colors.white : Colors.transparent,
                ),
                child: ClipOval(
                  child: isUnlocked
                      ? Image.asset(stamp.iconPath, fit: BoxFit.cover)
                      : Opacity(
                          opacity: 0.2, // Faint placeholder
                          child: ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                              Colors.brown,
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              stamp.iconPath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Title
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  stamp.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    height: 1.1,
                    color: isUnlocked ? Colors.brown[900] : Colors.brown[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStampDialog(Stamp stamp, bool isUnlocked) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFF7F2E2),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isUnlocked
                          ? Colors.brown[800]!
                          : Colors.brown[300]!.withOpacity(0.5),
                      width: 4,
                    ),
                    color: isUnlocked ? Colors.white : Colors.transparent,
                    boxShadow: [
                      if (isUnlocked)
                        const BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                    ],
                  ),
                  child: ClipOval(
                    child: isUnlocked
                        ? Image.asset(stamp.iconPath, fit: BoxFit.cover)
                        : Opacity(
                            opacity: 0.2, // Faint placeholder
                            child: ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                Colors.brown,
                                BlendMode.srcIn,
                              ),
                              child: Image.asset(
                                stamp.iconPath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                // Title
                Text(
                  stamp.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[900],
                  ),
                ),
                const SizedBox(height: 12),
                // Subtitle / Description
                Text(
                  isUnlocked
                      ? stamp.description
                      : 'Locked Achievement.\nKeep playing to discover how to earn this stamp!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.brown[800],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HorizontalSpiralPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Middle split groove shadow
    final seamPaint = Paint()
      ..color = Colors.black45
      ..style = PaintingStyle.fill;

    // Draw deep groove horizontally
    canvas.drawRect(
      Rect.fromLTWH(0, size.height / 2 - 2, size.width, 4),
      seamPaint,
    );

    // Draw spiral loops
    final loopPaint = Paint()
      ..color =
          Colors.grey[300]! // Lighter metal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final loopShadowPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    double x = 20.0;
    while (x < size.width - 15) {
      // Small paper hole above and below seam
      canvas.drawCircle(
        Offset(x, size.height / 2 - 10),
        3.5,
        Paint()..color = Colors.black87,
      );
      canvas.drawCircle(
        Offset(x, size.height / 2 + 10),
        3.5,
        Paint()..color = Colors.black87,
      );

      // Loop shadows underneath the metal rings
      canvas.drawOval(
        Rect.fromLTWH(x - 3.5, size.height / 2 - 12, 9, 24),
        loopShadowPaint,
      );

      // Metal loops
      canvas.drawOval(
        Rect.fromLTWH(x - 4, size.height / 2 - 14, 8, 24),
        loopPaint,
      );

      x += 24.0; // Spacing
    }
  }

  @override
  bool shouldRepaint(covariant HorizontalSpiralPainter oldDelegate) => false;
}
