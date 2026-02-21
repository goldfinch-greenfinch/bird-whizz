# Audio Implementation Guide

The Bird Quiz application uses the `flutter_soloud` package to manage audio playback. It replaces the previous `just_audio` implementation to resolve crashes related to native platform threading on Windows when playing concatenated audio sequences.

## 1. Overview of `AudioService`

All audio logic is centralized within the `AudioService` class situated at `lib/services/audio_service.dart`. This service extends `ChangeNotifier`, making it easy to access and observe from anywhere in the app using the `Provider` package.

The service manages three conceptual audio channels concurrently, each keeping track of its own Source (the audio asset loaded into memory) and Handle (the currently playing instance):

  1. **Music (`_musicSource`, `_musicHandle`)**: Plays loopable background tracks (e.g., intro, menu, quiz background).
  2. **Voice Over (`_voiceSource`, `_voiceHandle`)**: Used for reading out question text and reading sequences of answers.
  3. **Sound Effects (SFX) (`_sfxSource`, `_sfxHandle`)**: Rapidly triggered effects for correct/wrong answers, level-up events, and completing quizzes.

By separating these, user interaction sounds (like SFX) can interrupt Voice Overs without stopping the background Music.

## 2. Initialization and Safety

`SoLoud` requires initialization before any audio can be played. To prevent race conditions where a screen attempts to play audio before initialization is complete (resulting in a "Temporary directory hasn't been initialized" error), `AudioService` stores the initialization within a `Future`:

```dart
  Future<void>? _initFuture;

  AudioService() {
    _initFuture = _initSoLoud();
  }
```

Before attempting to play *any* audio, the service calls `_ensureInitialized()`:

```dart
  Future<void> _ensureInitialized() async {
    if (_initFuture != null) {
      await _initFuture;
    }
  }
```
This forces the playback functions to securely wait for the engine to initialize before proceeding.

## 3. Interruptions and Overlap

A primary issue with audio queues is button-spamming, where a user can rapidly trigger multiple sounds creating cacophonies or crashing the audio engine.

To solve this, `AudioService` features strict interruption handling for Voice Overs and SFX. Whenever an SFX or Voice Over action is requested, the current playing track for that channel is immediately halted using `SoLoud.instance.stop(handle)`. 

For example, when a sound effect is triggered:
1. It stops any currently running Voice Over.
2. It stops any currently running SFX.
3. Disposes of the previous asset source from memory.
4. Loads and plays the new requested sound effect.

## 4. Volume and Muting

A global `_isMuted` variable is managed within the service. 
- Calling `toggleMute()` will pause the background music and permanently halt the active Voice Over and SFX. 
- If `_isMuted` is true, all the internal `_playMusic`, `playVoiceOver`, and `_playSfx` methods will immediately return early, ignoring subsequent audio playback commands.

## 5. Playback Usage

Triggering audio from the UI is done via Provider:

**To Play Music/SFX:**
```dart
// Example: Trigger the correct answer sound
context.read<AudioService>().playCorrectSound();

// Example: Play background music
context.read<AudioService>().playQuizMusic();
```

**Toggle Mute:**
```dart
context.read<AudioService>().toggleMute();
```

## 6. Resource Management

Since `flutter_soloud` is a C++ native audio engine underneath, proper disposal of source variants is important to prevent memory leaks over time. `AudioService` disposes of sources whenever they are replaced:

```dart
if (_sfxSource != null) {
  SoLoud.instance.disposeSource(_sfxSource!);
  _sfxSource = null;
}
```

Furthermore, overriding the `dispose()` method ensures the entire engine elegantly tears down if the app service exits:
```dart
  @override
  void dispose() {
    try {
      SoLoud.instance.deinit();
    } catch (e) {
      if (kDebugMode) print('Error deinit SoLoud: $e');
    }
    super.dispose();
  }
```
