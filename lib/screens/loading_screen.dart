import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_service.dart';

class LoadingScreen extends StatefulWidget {
  final bool isLoaded;
  final VoidCallback? onStart;

  const LoadingScreen({super.key, this.isLoaded = false, this.onStart});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  static const bool _useAlphaBlending = false;
  late AnimationController _controller;
  late AnimationController _bgController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _bgController = AnimationController(
      // Slower animation, now 70 seconds
      duration: const Duration(seconds: 70),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _rotationAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  void _handleStart() {
    if (widget.onStart != null) {
      widget.onStart!();
      // Transition music
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<AudioService>().playMenuMusic();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Moving Background
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              final size = MediaQuery.of(context).size;
              final screenWidth = size.width;
              final screenHeight = size.height;

              // The image natively has a 640x316 resolution (~2.025 aspect ratio).
              // If we fit to height to ensure no empty space vertically,
              // we calculate the actual width it wants to take.
              final imageWidth = screenHeight * (640.0 / 316.0);
              // Pick the larger width to guarantee no letterboxing/pillboxing
              final bgWidth = imageWidth > screenWidth
                  ? imageWidth
                  : screenWidth;

              if (_useAlphaBlending) {
                return Positioned(
                  left: -(screenWidth * 2.4) * _bgController.value,
                  top: 0,
                  bottom: 0,
                  width: screenWidth * 3.4, // Holds all 4 overlapping images
                  child: Stack(
                    children: [
                      _buildBlendedImage(
                        'assets/images/bg_1.png',
                        0,
                        screenWidth,
                      ),
                      _buildBlendedImage(
                        'assets/images/bg_2.png',
                        screenWidth * 0.8,
                        screenWidth,
                      ),
                      _buildBlendedImage(
                        'assets/images/bg_3.png',
                        screenWidth * 1.6,
                        screenWidth,
                      ),
                      _buildBlendedImage(
                        'assets/images/bg_1.png',
                        screenWidth * 2.4,
                        screenWidth,
                      ),
                    ],
                  ),
                );
              }

              return Positioned(
                left: -(bgWidth * 2) * _bgController.value,
                top: 0,
                bottom: 0,
                width: bgWidth * 3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/bird_forest_background.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Transform.scale(
                        scaleX: -1,
                        child: Image.asset(
                          'assets/images/bird_forest_background.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        'assets/images/bird_forest_background.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          Container(
            color: Colors.white.withValues(alpha: 0.1),
            child: GestureDetector(
              onTap: widget.isLoaded ? _handleStart : null,
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated bird logo
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.teal.withValues(alpha: 0.2),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Image.asset(
                                'assets/images/bird_whizz_logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 60),
                    // Loading text and indicator
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: widget.isLoaded
                          ? Column(
                              key: const ValueKey('loaded'),
                              children: [
                                Text(
                                  'Tap to Start',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.5,
                                        ),
                                        offset: const Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Press Enter or Tap',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              key: const ValueKey('loading'),
                              children: [
                                Text(
                                  'Loading...',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.5,
                                        ),
                                        offset: const Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: 220,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      backgroundColor: Colors.black.withValues(
                                        alpha: 0.3,
                                      ),
                                      color: Colors.white,
                                      minHeight: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlendedImage(String asset, double leftPos, double width) {
    return Positioned(
      left: leftPos,
      top: 0,
      bottom: 0,
      width: width,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.transparent,
              Colors.black,
              Colors.black,
              Colors.transparent,
            ],
            stops: [0.0, 0.2, 0.8, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: Image.asset(asset, fit: BoxFit.cover),
      ),
    );
  }
}
