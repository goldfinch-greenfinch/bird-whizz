class Question {
  final String id;
  final String text;
  final String? imagePath;
  final List<String> options;
  final int correctOptionIndex;

  Question({
    required this.id,
    required this.text,
    this.imagePath,
    required this.options,
    required this.correctOptionIndex,
  });

  String get questionAudioPath {
    final filename = _sanitizeFilename(text);
    return 'audio/questions/$filename.mp3';
  }

  String getAnswerAudioPath(int index) {
    final filename = _sanitizeFilename(options[index]);
    return 'audio/answers/$filename.mp3';
  }

  String _sanitizeFilename(String text) {
    // Remove invalid chars, lower case, replace spaces with underscores, limit length
    // Matching Python: re.sub(r'[^\w\s-]', '', text).strip().lower()
    var safeText = text
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .trim()
        .toLowerCase();

    // Matching Python: re.sub(r'[\s-]+', '_', safe_text)
    safeText = safeText.replaceAll(RegExp(r'[\s-]+'), '_');

    if (safeText.length > 50) {
      safeText = safeText.substring(0, 50);
    }
    return safeText;
  }
}
