import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceInputButton extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onSpeechComplete;

  const VoiceInputButton({
    super.key,
    required this.controller,
    this.onSpeechComplete,
  });

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isAvailable = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    try {
      _isAvailable = await _speechToText.initialize(
        onError: (val) => debugPrint('Speech Error: $val'),
        onStatus: (val) => debugPrint('Speech Status: $val'),
      );
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Speech init failed: $e');
    }
  }

  void _startListening() async {
    if (_isAvailable) {
      setState(() => _isListening = true);

      final currentLocale = Localizations.localeOf(context).languageCode;

      String targetLocaleId = currentLocale == 'ar' ? 'ar_SY' : 'en_US';

      await _speechToText.listen(
        localeId: targetLocaleId, //
        onResult: (result) {
          final cleanedText = result.recognizedWords.trim();

          setState(() {
            widget.controller.text = cleanedText;
          });

          if (result.finalResult && widget.onSpeechComplete != null) {
            _stopListening();
            widget.onSpeechComplete!();
          }
        },
      );
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    if (mounted) {
      setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAvailable) return const SizedBox.shrink();

    return GestureDetector(
      onLongPressStart: (_) => _startListening(),
      onLongPressEnd: (_) => _stopListening(),
      child: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        child: CircleAvatar(
          radius: 22,
          backgroundColor: _isListening ? Colors.red : Theme.of(context).primaryColor,
          child: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class AvatarGlow extends StatelessWidget {
  final Widget child;
  final bool animate;
  final Color glowColor;

  const AvatarGlow({
    super.key,
    required this.child,
    required this.animate,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!animate) return child;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.4),
            blurRadius: 10,
            spreadRadius: 4,
          )
        ],
      ),
      child: child,
    );
  }
}
