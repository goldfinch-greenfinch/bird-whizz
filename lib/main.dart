import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'providers/quiz_provider.dart';
import 'services/audio_service.dart';
import 'router/app_router.dart';

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

class _BirdQuizAppState extends State<BirdQuizApp> with WidgetsBindingObserver {
  late final QuizProvider _quizProvider;
  late final AudioService _audioService;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _quizProvider = QuizProvider();
    _audioService = AudioService();
    _appRouter = AppRouter(_quizProvider);
    _quizProvider.init().then((_) {}); // fire and forget — LoadingScreen handles the ready state
    _audioService.playIntroMusic();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      _audioService.pauseAll();
    } else if (state == AppLifecycleState.resumed) {
      _audioService.resumeAll();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
      child: MaterialApp.router(
        title: 'Bird Whizz',
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        routerConfig: _appRouter.router,
      ),
    );
  }
}
