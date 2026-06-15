import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

/// Service to handle Text-to-Speech operations
class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  TtsService() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  /// Speaks the given text aloud. If speech is already playing,
  /// it will be stopped before starting the new message.
  Future<void> speak(String text) async {
    try {
      await _flutterTts.stop(); // Stop any existing speech
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint("TTS Error: $e");
    }
  }

  /// Stops any currently playing speech.
  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
