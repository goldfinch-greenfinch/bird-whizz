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
            return normalized.contains('assets/bird_photos/');
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
      print(
        'BirdImageService initialized. Found ${_birdImagePaths.length} images.',
      );
      // print('Sample paths: ${_birdImagePaths.take(3).toList()}');
    } catch (e) {
      print('Error initializing BirdImageService with AssetManifest class: $e');
      // Fallback to manual JSON parsing if class fails (unlikely on new Flutter)
      try {
        final manifestContent = await rootBundle.loadString(
          'AssetManifest.json',
        );
        final Map<String, dynamic> manifestMap = json.decode(manifestContent);
        _birdImagePaths = manifestMap.keys
            .where(
              (String key) =>
                  key.replaceAll(r'\', '/').contains('assets/bird_photos/'),
            )
            .where(
              (String key) =>
                  key.toLowerCase().endsWith('.webp') ||
                  key.toLowerCase().endsWith('.png') ||
                  key.toLowerCase().endsWith('.jpg') ||
                  key.toLowerCase().endsWith('.jpeg'),
            )
            .toList();
        _isInitialized = true;
        print(
          'BirdImageService initialized via JSON fallback. Found ${_birdImagePaths.length} images.',
        );
      } catch (e2) {
        print('Error initializing BirdImageService fallback: $e2');
      }
    }
  }

  List<Question> generateQuestions({int count = 10}) {
    if (_birdImagePaths.isEmpty) {
      return [];
    }

    final random = Random();
    final List<Question> questions = [];

    // Shuffle all available images to pick random ones
    final List<String> shuffledImages = List.from(_birdImagePaths)
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
      final List<String> distractors = _generateDistractors(correctBirdName, 3);

      // Combine options
      final List<String> options = List.from(distractors)..add(correctBirdName);
      options.shuffle(
        random,
      ); // Shuffle options so correct answer isn't always last

      final int correctIndex = options.indexOf(correctBirdName);

      questions.add(
        Question(
          id: 'bird_id_$i', // Temporary ID
          text: 'Who am I?', // Standard text for ID mode
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

  List<String> _generateDistractors(String correctName, int count) {
    if (identificationData.containsKey(correctName)) {
      final List<String> similar = List.from(identificationData[correctName]!);
      similar.shuffle();
      return similar.take(count).toList();
    }

    // Fallback: Pick random birds if not in our curated list
    final random = Random();
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
