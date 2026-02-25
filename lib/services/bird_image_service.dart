import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/question.dart';
import '../data/identification_data.dart';

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
      // print(
      //   'BirdImageService initialized. Found ${_birdImagePaths.length} images.',
      // );
      // print('Sample paths: ${_birdImagePaths.take(3).toList()}');
    } catch (e) {
      // print('Error initializing BirdImageService with AssetManifest class: $e');
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
        // print(
        //   'BirdImageService initialized via JSON fallback. Found ${_birdImagePaths.length} images.',
        // );
      } catch (e2) {
        // print('Error initializing BirdImageService fallback: $e2');
      }
    }
  }

  static const Map<String, List<String>> birdThemes = {
    'Waterfowl': [
      'Duck',
      'Goose',
      'Swan',
      'Teal',
      'Wigeon',
      'Pintail',
      'Mallard',
      'Eider',
      'Scoter',
      'Merganser',
      'Shoveler',
      'Garganey',
    ],
    'Birds of Prey': [
      'Eagle',
      'Hawk',
      'Falcon',
      'Kite',
      'Osprey',
      'Harrier',
      'Buzzard',
      'Kestrel',
      'Caracara',
    ],
    'Owls': ['Owl'],
    'Waders & Shorebirds': [
      'Heron',
      'Egret',
      'Sandpiper',
      'Plover',
      'Redshank',
      'Godwit',
      'Curlew',
      'Avocet',
      'Oystercatcher',
      'Stilt',
      'Snipe',
      'Phalarope',
    ],
    'Woodpeckers & Kingfishers': [
      'Woodpecker',
      'Kingfisher',
      'Sapsucker',
      'Flicker',
    ],
    'Corvids': ['Crow', 'Raven', 'Jay', 'Magpie', 'Rook', 'Nutcracker'],
    'Songbirds': [
      'Warbler',
      'Thrush',
      'Robin',
      'Tit',
      'Chickadee',
      'Wren',
      'Bunting',
      'Sparrow',
      'Finch',
      'Grosbeak',
      'Towhee',
      'Nuthatch',
    ],
    'Seabirds': [
      'Gull',
      'Tern',
      'Pelican',
      'Puffin',
      'Cormorant',
      'Booby',
      'Frigatebird',
      'Albatross',
      'Gannet',
    ],
    'Pigeons & Doves': ['Pigeon', 'Dove'],
    'Exotic & Colorful': [
      'Hummingbird',
      'Macaw',
      'Toucan',
      'Roller',
      'Bee Eater',
      'Flamingo',
      'Parakeet',
      'Peacock',
      'Peafowl',
    ],
  };

  List<Question> generateQuestions({
    int count = 10,
    String? theme,
    String difficulty = 'medium',
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

    // Shuffle all available images to pick random ones
    final List<String> shuffledImages = List.from(themeImagePaths)
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

    if (difficulty == 'hard') {
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
        'medium',
        themeImagePaths,
      );
    }

    if (difficulty == 'medium') {
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
      return _generateDistractors(correctName, count, 'easy', themeImagePaths);
    }

    // Easy (or fallback)
    final List<String> allBirdNames = _birdImagePaths
        .map((path) => _getBirdNameFromPath(path))
        .toSet()
        .toList();
    final List<String> randomDistractors = allBirdNames
        .where((name) => name != correctName)
        .toList();
    randomDistractors.shuffle(random);
    return randomDistractors.take(count).toList();
  }
}
