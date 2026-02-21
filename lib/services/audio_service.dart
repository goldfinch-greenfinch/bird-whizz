import 'dart:math';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:flutter/foundation.dart';

class AudioService extends ChangeNotifier {
  final Random _random = Random();
  bool _isMuted = false;
  bool get isMuted => _isMuted;

  // Track current sounds
  SoundHandle? _musicHandle;
  AudioSource? _musicSource;

  SoundHandle? _voiceHandle;
  AudioSource? _voiceSource;

  SoundHandle? _sfxHandle;
  AudioSource? _sfxSource;

  String? _currentMusicPath;

  Future<void>? _initFuture;
  int _sequenceId = 0;

  AudioService() {
    _initFuture = _initSoLoud();
  }

  Future<void> _initSoLoud() async {
    try {
      await SoLoud.instance.init();
    } catch (e) {
      if (kDebugMode) print('Error initializing SoLoud: $e');
    }
  }

  Future<void> _ensureInitialized() async {
    if (_initFuture != null) {
      await _initFuture;
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    final soloud = SoLoud.instance;

    if (_isMuted) {
      if (_musicHandle != null) soloud.setPause(_musicHandle!, true);
      if (_voiceHandle != null) soloud.stop(_voiceHandle!);
      if (_sfxHandle != null) soloud.stop(_sfxHandle!);
    } else {
      if (_musicHandle != null) soloud.setPause(_musicHandle!, false);
    }
    notifyListeners();
  }

  // --- Music Methods ---

  Future<void> playIntroMusic() async {
    await _playMusic('audio/sound_effects/intro.mp3', volume: 0.5);
  }

  Future<void> playMenuMusic() async {
    await _playMusic('audio/background_music/menu.mp3', volume: 0.3);
  }

  Future<void> playQuizMusic() async {
    final tracks = [
      'audio/background_music/forest_spring.mp3',
      'audio/background_music/forest_pond.mp3',
      'audio/background_music/forest_birds.mp3',
    ];
    final randomTrack = tracks[_random.nextInt(tracks.length)];
    await _playMusic(randomTrack, volume: 0.2);
  }

  Future<void> stopMusic() async {
    try {
      if (_musicHandle != null) {
        SoLoud.instance.stop(_musicHandle!);
        _musicHandle = null;
      }
      if (_musicSource != null) {
        SoLoud.instance.disposeSource(_musicSource!);
        _musicSource = null;
      }
      _currentMusicPath = null;
    } catch (e) {
      if (kDebugMode) print('Error stopping music: $e');
    }
  }

  Future<void> _playMusic(String path, {double volume = 0.3}) async {
    if (_isMuted) return;
    await _ensureInitialized();

    if (_currentMusicPath == path &&
        _musicHandle != null &&
        SoLoud.instance.getIsValidVoiceHandle(_musicHandle!)) {
      return;
    }

    try {
      await stopMusic(); // Stop any existing music

      _musicSource = await SoLoud.instance.loadAsset('assets/$path');
      _musicHandle = await SoLoud.instance.play(
        _musicSource!,
        volume: volume,
        looping: true,
      );
      _currentMusicPath = path;
    } catch (e) {
      if (kDebugMode) print('Error playing music ($path): $e');
    }
  }

  // --- Voice Over Methods ---

  Future<void> playVoiceOver(String path) async {
    if (_isMuted) return;
    await _ensureInitialized();
    _sequenceId++; // Cancel any playing sequence
    try {
      if (_voiceHandle != null &&
          SoLoud.instance.getIsValidVoiceHandle(_voiceHandle!)) {
        SoLoud.instance.stop(_voiceHandle!);
      }
      if (_voiceSource != null) {
        SoLoud.instance.disposeSource(_voiceSource!);
        _voiceSource = null;
      }

      _voiceSource = await SoLoud.instance.loadAsset('assets/$path');
      _voiceHandle = await SoLoud.instance.play(_voiceSource!);
    } catch (e) {
      if (kDebugMode) print('Error playing voiceover ($path): $e');
    }
  }

  // --- SFX Methods ---

  Future<void> playCorrectSound() async {
    await _playSfx('audio/sound_effects/correct.mp3');
  }

  Future<void> playWrongSound() async {
    await _playSfx('audio/sound_effects/wrong.mp3');
  }

  Future<void> playLevelUpSound() async {
    await _playSfx('audio/sound_effects/level_up.mp3');
  }

  Future<void> playQuizCompleteSound() async {
    await _playSfx('audio/sound_effects/end_quiz.mp3');
  }

  Future<void> _playSfx(String path) async {
    if (_isMuted) return;
    await _ensureInitialized();
    try {
      if (_voiceHandle != null &&
          SoLoud.instance.getIsValidVoiceHandle(_voiceHandle!)) {
        SoLoud.instance.stop(_voiceHandle!);
      }
      if (_sfxHandle != null &&
          SoLoud.instance.getIsValidVoiceHandle(_sfxHandle!)) {
        SoLoud.instance.stop(_sfxHandle!);
      }
      if (_sfxSource != null) {
        SoLoud.instance.disposeSource(_sfxSource!);
        _sfxSource = null;
      }

      _sfxSource = await SoLoud.instance.loadAsset('assets/$path');
      _sfxHandle = await SoLoud.instance.play(_sfxSource!);
    } catch (e) {
      if (kDebugMode) print('Error playing SFX ($path): $e');
    }
  }

  Future<void> playSequence(List<String> paths) async {
    if (_isMuted) return;
    await _ensureInitialized();

    final currentSequenceId = ++_sequenceId;

    try {
      if (_voiceHandle != null &&
          SoLoud.instance.getIsValidVoiceHandle(_voiceHandle!)) {
        SoLoud.instance.stop(_voiceHandle!);
      }

      for (int i = 0; i < paths.length; i++) {
        if (_isMuted || currentSequenceId != _sequenceId) break;

        if (_voiceSource != null) {
          SoLoud.instance.disposeSource(_voiceSource!);
          _voiceSource = null;
        }

        _voiceSource = await SoLoud.instance.loadAsset('assets/${paths[i]}');
        if (currentSequenceId != _sequenceId) return;

        _voiceHandle = await SoLoud.instance.play(_voiceSource!);

        // Wait for the audio to finish playing
        while (_voiceHandle != null &&
            SoLoud.instance.getIsValidVoiceHandle(_voiceHandle!)) {
          if (_isMuted || currentSequenceId != _sequenceId) {
            SoLoud.instance.stop(_voiceHandle!);
            break;
          }
          await Future.delayed(const Duration(milliseconds: 50));
        }

        // Add a small pause between files, 700ms for question->options, 300ms for option->option
        if (i < paths.length - 1 &&
            !_isMuted &&
            currentSequenceId == _sequenceId) {
          await Future.delayed(Duration(milliseconds: i == 0 ? 700 : 300));
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error playing sequence: $e');
    }
  }

  @override
  void dispose() {
    try {
      SoLoud.instance.deinit();
    } catch (e) {
      if (kDebugMode) print('Error deinit SoLoud: $e');
    }
    super.dispose();
  }
}
