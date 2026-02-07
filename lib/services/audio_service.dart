import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService extends ChangeNotifier {
  // Separate players for different audio channels
  late AudioPlayer _musicPlayer;
  late AudioPlayer _voicePlayer; // For question reading
  late AudioPlayer _sfxPlayer; // For feedback sounds

  final Random _random = Random();
  bool _isMuted = false;
  bool get isMuted => _isMuted;

  // Track current music to avoid restarts
  String? _currentMusicPath;

  AudioService() {
    _initPlayers();
  }

  void _initPlayers() {
    _musicPlayer = AudioPlayer();
    _voicePlayer = AudioPlayer();
    _sfxPlayer = AudioPlayer();

    // Configure players for best experience
    // Release mode might help with resources, but default is usually fine.
    // We can set release mode to stop to save resources when done.
    _musicPlayer.setReleaseMode(ReleaseMode.loop); // Music loops by default
    _voicePlayer.setReleaseMode(ReleaseMode.stop);
    _sfxPlayer.setReleaseMode(ReleaseMode.stop);
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      _musicPlayer.pause();
      _voicePlayer.stop();
      _sfxPlayer.stop();
    } else {
      _musicPlayer.resume();
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
      await _musicPlayer.stop();
      _currentMusicPath = null;
    } catch (e) {
      if (kDebugMode) print('Error stopping music: $e');
    }
  }

  Future<void> _playMusic(String path, {double volume = 0.3}) async {
    if (_isMuted) return;

    // Don't restart if same track
    if (_currentMusicPath == path &&
        _musicPlayer.state == PlayerState.playing) {
      return;
    }

    try {
      await _musicPlayer.setVolume(volume);
      // audioplayers uses AssetSource which takes path relative to assets/
      // BUT strict check: pubspec defines "assets/audio/...", so AssetSource('audio/...') works if 'assets' is root?
      // Actually AssetSource automatically prepends 'assets/' if not present?
      // No, AssetSource('foo.mp3') looks for 'assets/foo.mp3'.
      // Our paths passed in are like 'audio/background_music/menu.mp3'.
      // So AssetSource('audio/background_music/menu.mp3') should map to 'assets/audio/background_music/menu.mp3'.
      // This matches our pubspec structure.

      await _musicPlayer.play(AssetSource(path));
      _currentMusicPath = path;
    } catch (e) {
      if (kDebugMode) print('Error playing music ($path): $e');
    }
  }

  // --- Voice Over Methods ---

  Future<void> playVoiceOver(String path) async {
    if (_isMuted) return;
    try {
      // Improve responsiveness by stopping previous immediately
      await _voicePlayer.stop();
      await _voicePlayer.play(AssetSource(path));
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
    try {
      // First, stop the voice player! This was the critical requirement to avoid "talking over"
      // and clearly separate interaction.
      await _voicePlayer.stop();

      // Stop any previous SFX to keep it clean (monophonic SFX)
      // or we could let them overlap, but for this quiz, clean is better.
      await _sfxPlayer.stop();

      await _sfxPlayer.play(AssetSource(path));
    } catch (e) {
      if (kDebugMode) print('Error playing SFX ($path): $e');
    }
  }

  // Compatibility method
  Future<void> playSequence(List<String> paths) async {
    // Not used with new combined audio, but safe implementation:
    if (paths.isNotEmpty) {
      playVoiceOver(paths.first);
    }
  }

  @override
  void dispose() {
    _musicPlayer.dispose();
    _voicePlayer.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }
}
