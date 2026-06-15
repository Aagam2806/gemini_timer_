import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'tts_service.dart';

class GeminiService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  
  late final GenerativeModel _model;
  final TtsService _ttsService = TtsService();

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
    );
  }

  void _speakFallback(String contextPhrase) {
    String fallbackMessage;
    if (contextPhrase == 'Halfway reached') {
      fallbackMessage = "You're halfway there. Keep going.";
    } else if (contextPhrase == '10 seconds remaining') {
      fallbackMessage = "10 seconds remaining.";
    } else if (contextPhrase == 'Time is up') {
      fallbackMessage = "Time is up. Great job.";
    } else {
      fallbackMessage = "Keep going.";
    }
    debugPrint('Using fallback TTS: $fallbackMessage');
    _ttsService.speak(fallbackMessage);
  }

  /// Generates a short motivational sentence asynchronously.
  Future<void> generateMotivation(String contextPhrase) async {
    if (_apiKey.isEmpty) {
      debugPrint('Gemini Exception: API key is empty or not loaded from .env');
      _speakFallback(contextPhrase);
      return;
    }

    try {
      debugPrint('Calling Gemini ($contextPhrase)...');
      final prompt = 'Generate one motivational sentence for a countdown timer. Maximum 12 words. Return plain text only.';
      
      // Enforce a strict timeout so the timer does not pass the next milestone before speaking
      final response = await _model.generateContent([Content.text(prompt)]).timeout(
        const Duration(seconds: 4),
        onTimeout: () {
          throw Exception("Gemini API timed out");
        },
      );
      
      final text = response.text?.trim();
      if (text != null && text.isNotEmpty) {
        debugPrint('Gemini Response: $text');
        // Asynchronously read the message aloud without blocking
        _ttsService.speak(text);
      } else {
        debugPrint('Gemini Response: Returned empty text.');
        _speakFallback(contextPhrase);
      }
    } catch (e, stackTrace) {
      debugPrint('Gemini Exception: $e');
      debugPrint('Stack Trace:\n$stackTrace');
      _speakFallback(contextPhrase);
    }
  }
}
