import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/question.dart';
import '../data/identification_data.dart';
import '../data/bird_difficulty.dart';
import 'logging_service.dart';

class BirdImageService {
  List<String> _birdImagePaths = [];
  bool _isInitialized = false;

  // Singleton pattern
  static final BirdImageService _instance = BirdImageService._internal();

  factory BirdImageService() {
    return _instance;
  }

  BirdImageService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Use the AssetManifest class which is compatible with both JSON and binary manifests
      // and handles path normalization better.
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final assets = manifest.listAssets();

      _birdImagePaths = assets
          .where((String key) {
            // Normalize separators to forward slashes for comparison
            final normalized = key.replaceAll(r'\', '/');
            return normalized.contains('assets/bird_photos/') ||
                normalized.contains('assets/nuthatch_birds/');
          })
          .where(
            (String key) =>
                key.toLowerCase().endsWith('.webp') ||
                key.toLowerCase().endsWith('.png') ||
                key.toLowerCase().endsWith('.jpg') ||
                key.toLowerCase().endsWith('.jpeg'),
          )
          .toList();

      _isInitialized = true;
    } catch (e) {
      LoggingService.warning('BirdImageService: AssetManifest class failed, trying JSON fallback', e);
      // Fallback to manual JSON parsing if class fails (unlikely on new Flutter)
      try {
        final manifestContent = await rootBundle.loadString(
          'AssetManifest.json',
        );
        final Map<String, dynamic> manifestMap = json.decode(manifestContent);
        _birdImagePaths = manifestMap.keys
            .where((String key) {
              final normalized = key.replaceAll(r'\', '/');
              return normalized.contains('assets/bird_photos/') ||
                  normalized.contains('assets/nuthatch_birds/');
            })
            .where(
              (String key) =>
                  key.toLowerCase().endsWith('.webp') ||
                  key.toLowerCase().endsWith('.png') ||
                  key.toLowerCase().endsWith('.jpg') ||
                  key.toLowerCase().endsWith('.jpeg'),
            )
            .toList();
        _isInitialized = true;
      } catch (e2) {
        LoggingService.error('BirdImageService: JSON fallback also failed', e2);
      }
    }
  }

  static const Map<String, List<String>> birdThemes = {
    'Waterfowl': ['Duck', 'Goose', 'Geese', 'Swan', 'Teal', 'Wigeon', 'Pintail', 'Mallard', 'Eider', 'Scoter', 'Merganser', 'Shoveler', 'Garganey', 'Pochard', 'Shelduck', 'Smew', 'Goldeneye', 'Brant', 'Bufflehead', 'Canvasback', 'Scaup', 'Gadwall'],
    'Coastal & Wading Birds': ['Heron', 'Egret', 'Sandpiper', 'Plover', 'Redshank', 'Godwit', 'Curlew', 'Avocet', 'Oystercatcher', 'Stilt', 'Snipe', 'Phalarope', 'Gull', 'Tern', 'Pelican', 'Puffin', 'Cormorant', 'Booby', 'Frigatebird', 'Albatross', 'Gannet', 'Shag', 'Turnstone', 'Loon', 'Coot', 'Gallinule', 'Flamingo', 'Anhinga', 'Guillemot', 'Skimmer', 'Ibis', 'Spoonbill', 'Grebe', 'Tattler', 'Sanderling', 'Dunlin', 'Limpkin', 'Willet', 'Razorbill', 'Fulmar', 'Moorhen', 'Stork', 'Crane', 'Whimbrel', 'Killdeer'],
    'Birds of Prey': ['Eagle', 'Hawk', 'Falcon', 'Kite', 'Osprey', 'Harrier', 'Buzzard', 'Kestrel', 'Caracara', 'Owl', 'Vulture', 'Merlin', 'Condor', 'Roadrunner'],
    'Forest & Woodland Birds': ['Woodpecker', 'Kingfisher', 'Sapsucker', 'Flicker', 'Crow', 'Raven', 'Jay', 'Magpie', 'Rook', 'Nutcracker', 'Pigeon', 'Dove', 'Grouse', 'Quail', 'Pheasant', 'Partridge', 'Ptarmigan', 'Turkey', 'Drongo', 'Chukar', 'Jackdaw', 'Cuckoo'],
    'Exotic & Colorful': ['Hummingbird', 'Macaw', 'Toucan', 'Roller', 'Bee Eater', 'Parakeet', 'Peacock', 'Peafowl', 'Trogon', 'Motmot', 'Jacamar', 'Puffbird', 'Barbet', 'Honeyguide', 'Aracari', 'Woodcreeper', 'Manakin', 'Cotinga', 'Tityra', 'Becard', 'Antbird', 'Antthrush', 'Antpitta', 'Gnateater', 'Tapaculo', 'Rosy Finch'],
    'Songbirds': ['Warbler', 'Thrush', 'Robin', 'Tit', 'Chickadee', 'Wren', 'Bunting', 'Sparrow', 'Finch', 'Grosbeak', 'Towhee', 'Nuthatch', 'Blackbird', 'Oriole', 'Swallow', 'Meadowlark', 'Starling', 'Vireo', 'Waxwing', 'Bluebird', 'Dickcissel', 'Grackle', 'Lark', 'Catbird', 'Mockingbird', 'Thrasher', 'Goldfinch', 'Siskin', 'Redpoll', 'Crossbill', 'Pipit', 'Tanager', 'Bobolink', 'Flycatcher', 'Phoebe', 'Kingbird', 'Pewee', 'Shrike', 'Creeper', 'Gnatcatcher', 'Kinglet', 'Martin', 'Ovenbird', 'Parula', 'Redstart', 'Yellowthroat', 'Chat', 'Waterthrush', 'Accentor', 'Dipper', 'Cardinal', 'Bluethroat', 'Chiffchaff', 'Stonechat', 'Blackcap', 'Brambling', 'Bullfinch', 'Linnet', 'Yellowhammer', 'Skylark', 'Dunnock', 'Goldcrest', 'Firecrest', 'Pyrrhuloxia', 'Junco', 'Whitethroat', 'Redwing', 'White Eye', 'Swift', 'Bushtit'],
  };

  List<Question> generateQuestions({
    int count = 10,
    String? theme,
    String difficulty = 'level_2',
  }) {
    if (_birdImagePaths.isEmpty) {
      return [];
    }

    final random = Random();
    final List<Question> questions = [];

    // Filter by theme
    List<String> themeImagePaths = _birdImagePaths;
    if (theme != null && birdThemes.containsKey(theme)) {
      final keywords = birdThemes[theme]!;
      themeImagePaths = _birdImagePaths.where((path) {
        final name = _getBirdNameFromPath(path);
        return keywords.any(
          (k) => name.toLowerCase().contains(k.toLowerCase()),
        );
      }).toList();
    }

    if (themeImagePaths.isEmpty) {
      themeImagePaths = _birdImagePaths; // Fallback
    }

    // Filter by difficulty based on bird rareness
    List<String> idealDifficultyPaths = themeImagePaths.where((path) {
      final name = _getBirdNameFromPath(path);
      final birdDiff = birdDifficulty[name] ?? 'level_2';
      return birdDiff == difficulty;
    }).toList();

    // If we don't have enough birds of matching difficulty, fallback by mixing others
    if (idealDifficultyPaths.length < count) {
      final int missingCount = count - idealDifficultyPaths.length;
      final List<String> otherPaths = themeImagePaths
          .where((path) => !idealDifficultyPaths.contains(path))
          .toList();
      otherPaths.shuffle(random);
      idealDifficultyPaths.addAll(otherPaths.take(missingCount));
    }

    // Shuffle all available images to pick random ones
    final List<String> shuffledImages = List.from(idealDifficultyPaths)
      ..shuffle(random);

    // Select the first 'count' images (or all if less than count)
    final int selectionCount = min(count, shuffledImages.length);
    final List<String> selectedImages = shuffledImages.sublist(
      0,
      selectionCount,
    );

    for (int i = 0; i < selectedImages.length; i++) {
      final String imagePath = selectedImages[i];
      final String correctBirdName = _getBirdNameFromPath(imagePath);

      // Generate distractors
      final List<String> distractors = _generateDistractors(
        correctBirdName,
        3,
        difficulty,
        themeImagePaths,
      );

      // Combine options
      final List<String> options = List.from(distractors)..add(correctBirdName);
      options.shuffle(
        random,
      ); // Shuffle options so correct answer isn't always last

      final int correctIndex = options.indexOf(correctBirdName);

      questions.add(
        Question(
          id: 'bird_id_${theme ?? "all"}_${difficulty}_$i',
          text: 'Who am I?',
          imagePath: imagePath,
          options: options,
          correctOptionIndex: correctIndex,
          hasAudio: false,
        ),
      );
    }

    return questions;
  }

  String _getBirdNameFromPath(String path) {
    // Expected format: assets/bird_photos/bird_name.webp
    final String filename = path.split('/').last;
    String nameWithExtension = filename.split('.').first;

    // Typo fix
    if (nameWithExtension == 'male_common_eide') {
      nameWithExtension = 'male_common_eider';
    }

    // Remove suffix numbers like _2, _3
    nameWithExtension = nameWithExtension.replaceAll(RegExp(r'_\d+$'), '');

    // Convert underscores to spaces and Capitalize
    // e.g., "american_goldfinch" -> "American Goldfinch"
    return nameWithExtension
        .split('_')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');
  }

  List<String> _generateDistractors(
    String correctName,
    int count,
    String difficulty,
    List<String> themeImagePaths,
  ) {
    final random = Random();

    if (difficulty == 'level_3') {
      if (identificationData.containsKey(correctName)) {
        final List<String> similar = List.from(
          identificationData[correctName]!,
        );
        if (similar.length >= count) {
          similar.shuffle();
          return similar.take(count).toList();
        }
      }
      // If not enough hard distractors, fallback to medium
      return _generateDistractors(
        correctName,
        count,
        'level_2',
        themeImagePaths,
      );
    }

    if (difficulty == 'level_2') {
      // Pick random from the SAME theme
      final List<String> themeBirdNames = themeImagePaths
          .map((path) => _getBirdNameFromPath(path))
          .toSet()
          .toList();
      final List<String> randomDistractors = themeBirdNames
          .where((name) => name != correctName)
          .toList();

      if (randomDistractors.length >= count) {
        randomDistractors.shuffle(random);
        return randomDistractors.take(count).toList();
      }
      // If not enough theme distractors, fallback to easy
      return _generateDistractors(correctName, count, 'level_1', themeImagePaths);
    }

    // Level 1 (or fallback): prefer same-theme birds; only supplement with
    // off-theme birds when the theme pool is too small to fill all slots.
    final List<String> themeBirdNames = themeImagePaths
        .map((path) => _getBirdNameFromPath(path))
        .toSet()
        .toList();
    final List<String> themeDistractors = themeBirdNames
        .where((name) => name != correctName)
        .toList()
      ..shuffle(random);

    if (themeDistractors.length >= count) {
      return themeDistractors.take(count).toList();
    }

    // Not enough theme birds: supplement with non-theme birds
    final List<String> allBirdNames = _birdImagePaths
        .map((path) => _getBirdNameFromPath(path))
        .toSet()
        .toList();
    final List<String> offThemeDistractors = allBirdNames
        .where((name) => name != correctName && !themeBirdNames.contains(name))
        .toList()
      ..shuffle(random);

    final List<String> combined = List.from(themeDistractors);
    combined.addAll(
      offThemeDistractors.take(count - themeDistractors.length),
    );
    combined.shuffle(random);
    return combined.take(count).toList();
  }
}
