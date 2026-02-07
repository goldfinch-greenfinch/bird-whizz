import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'providers/quiz_provider.dart';
import 'screens/profile_selection_screen.dart';
import 'screens/loading_screen.dart';
import 'services/audio_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Don't await init here anymore, let the UI handle it

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const BirdQuizApp(),
    ),
  );
}

class BirdQuizApp extends StatefulWidget {
  const BirdQuizApp({super.key});

  @override
  State<BirdQuizApp> createState() => _BirdQuizAppState();
}

class _BirdQuizAppState extends State<BirdQuizApp> {
  late final QuizProvider _quizProvider;
  late final AudioService _audioService;
  late final Future<void> _initFuture;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _quizProvider = QuizProvider();
    _audioService = AudioService();
    // Initialize provider and wait at least 3 seconds to show off the animation
    _initFuture = Future.wait([
      _quizProvider.init(),
      _audioService.playIntroMusic(),
      Future.delayed(const Duration(seconds: 3)),
    ]);
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _quizProvider),
        ChangeNotifierProvider.value(value: _audioService),
      ],
      child: MaterialApp(
        title: 'Bird Whizz',
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: FutureBuilder(
          future: _initFuture,
          builder: (context, snapshot) {
            // Check if initialization is complete
            final isLoaded = snapshot.connectionState == ConnectionState.done;
            return _hasStarted
                ? const ProfileSelectionScreen()
                : LoadingScreen(
                    isLoaded: isLoaded,
                    onStart: () {
                      setState(() {
                        _hasStarted = true;
                      });
                    },
                  );
          },
        ),
      ),
    );
  }
}
