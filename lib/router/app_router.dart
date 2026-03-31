import 'package:go_router/go_router.dart';
import '../providers/quiz_provider.dart';
import '../screens/loading_screen.dart';
import '../screens/profile_selection_screen.dart';
import '../screens/bird_selection_screen.dart';
import '../screens/main_selection_screen.dart';
import '../screens/text_quiz_selection_screen.dart';
import '../screens/home_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/bird_id_selection_screen.dart';
import '../screens/word_games_selection_screen.dart';
import '../screens/rescue_bird_screen.dart';
import '../screens/special_quiz_selection_screen.dart';
import '../screens/endless_quiz_screen.dart';
import '../screens/endless_result_screen.dart';
import '../screens/guess_bird_screen.dart';
import '../screens/speed_challenge_screen.dart';
import '../screens/result_screen.dart';
import '../screens/level_up_screen.dart';
import '../screens/character_evolve_screen.dart';
import '../screens/new_stamp_screen.dart';
import '../screens/achievements_book_screen.dart';
import '../screens/stats_screen.dart';
import '../screens/all_stars_screen.dart';
import '../screens/all_badges_screen.dart';

class AppRouter {
  final QuizProvider quizProvider;

  AppRouter(this.quizProvider);

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.loading,
    refreshListenable: quizProvider,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final isProfileRoute =
          loc == AppRoutes.loading ||
          loc == AppRoutes.profiles ||
          loc == AppRoutes.birdSelect;
      if (!quizProvider.hasProfile && !isProfileRoute) {
        return AppRoutes.profiles;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.loading,
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: AppRoutes.profiles,
        builder: (context, state) => const ProfileSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.birdSelect,
        builder: (context, state) => const BirdSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.main,
        builder: (context, state) => const MainSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.textQuiz,
        builder: (context, state) => const TextQuizSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.textQuizLevels,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.quiz,
        builder: (context, state) => const QuizScreen(),
      ),
      GoRoute(
        path: AppRoutes.birdId,
        builder: (context, state) => const BirdIdSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.wordGames,
        builder: (context, state) => const WordGamesSelectionScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.wordGames}/rescue',
        builder: (context, state) => const RescueBirdScreen(),
      ),
      GoRoute(
        path: AppRoutes.special,
        builder: (context, state) => const SpecialQuizSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.endless,
        builder: (context, state) => const EndlessQuizScreen(),
      ),
      GoRoute(
        path: AppRoutes.endlessResult,
        builder: (context, state) => const EndlessResultScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.special}/guess-bird/:levelIndex',
        builder: (context, state) => GuessBirdScreen(
          levelIndex: int.parse(state.pathParameters['levelIndex']!),
        ),
      ),
      GoRoute(
        path: '${AppRoutes.special}/speed-challenge/:levelIndex',
        builder: (context, state) => SpeedChallengeScreen(
          levelIndex: int.parse(state.pathParameters['levelIndex']!),
        ),
      ),
      GoRoute(
        path: AppRoutes.result,
        builder: (context, state) => const ResultScreen(),
      ),
      GoRoute(
        path: AppRoutes.levelUp,
        builder: (context, state) => const LevelUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.evolve,
        builder: (context, state) => const CharacterEvolveScreen(),
      ),
      GoRoute(
        path: AppRoutes.stamp,
        builder: (context, state) => const NewStampScreen(),
      ),
      GoRoute(
        path: AppRoutes.achievements,
        builder: (context, state) => const AchievementsBookScreen(),
      ),
      GoRoute(
        path: AppRoutes.stats,
        builder: (context, state) => const StatsScreen(),
      ),
      GoRoute(
        path: AppRoutes.allStars,
        builder: (context, state) => const AllStarsScreen(),
      ),
      GoRoute(
        path: AppRoutes.allBadges,
        builder: (context, state) => const AllBadgesScreen(),
      ),
    ],
  );
}

abstract final class AppRoutes {
  static const loading      = '/';
  static const profiles     = '/profiles';
  static const birdSelect   = '/bird-select';
  static const main         = '/main';
  static const textQuiz     = '/text-quiz';
  static const textQuizLevels = '/text-quiz/levels';
  static const quiz         = '/quiz';
  static const birdId       = '/bird-id';
  static const wordGames    = '/word-games';
  static const special      = '/special';
  static const endless      = '/special/endless';
  static const endlessResult = '/special/endless-result';
  static const result       = '/result';
  static const levelUp      = '/level-up';
  static const evolve       = '/evolve';
  static const stamp        = '/stamp';
  static const achievements = '/achievements';
  static const stats        = '/stats';
  static const allStars     = '/all-stars';
  static const allBadges    = '/all-badges';
}
