// lib/models/correction_result.dart

class CorrectionResult {
  final String original;
  final String corrected;
  final bool hasErrors;
  final List<String> errors;
  final String? suggestions;

  CorrectionResult({
    required this.original,
    required this.corrected,
    required this.hasErrors,
    required this.errors,
    this.suggestions,
  });

  factory CorrectionResult.fromJson(Map<String, dynamic> json) {
    return CorrectionResult(
      original: json['original'] as String? ?? '',
      corrected: json['corrected'] as String? ?? '',
      hasErrors: json['hasErrors'] as bool? ?? false,
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      suggestions: json['suggestions'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original': original,
      'corrected': corrected,
      'hasErrors': hasErrors,
      'errors': errors,
      'suggestions': suggestions,
    };
  }
}

// lib/models/practice_record.dart

class PracticeRecord {
  final int? id;
  final String audioPath;
  final String transcription;
  final String corrected;
  final bool hasErrors;
  final List<String> errors;
  final String? suggestions;
  final DateTime createdAt;

  PracticeRecord({
    this.id,
    required this.audioPath,
    required this.transcription,
    required this.corrected,
    required this.hasErrors,
    required this.errors,
    this.suggestions,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'audioPath': audioPath,
      'transcription': transcription,
      'corrected': corrected,
      'hasErrors': hasErrors ? 1 : 0,
      'errors': errors.join('|||'), // Use delimiter to store list
      'suggestions': suggestions,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PracticeRecord.fromMap(Map<String, dynamic> map) {
    return PracticeRecord(
      id: map['id'] as int?,
      audioPath: map['audioPath'] as String,
      transcription: map['transcription'] as String,
      corrected: map['corrected'] as String,
      hasErrors: (map['hasErrors'] as int) == 1,
      errors: (map['errors'] as String).split('|||'),
      suggestions: map['suggestions'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  factory PracticeRecord.fromCorrectionResult({
    required String audioPath,
    required String transcription,
    required CorrectionResult correction,
  }) {
    return PracticeRecord(
      audioPath: audioPath,
      transcription: transcription,
      corrected: correction.corrected,
      hasErrors: correction.hasErrors,
      errors: correction.errors,
      suggestions: correction.suggestions,
      createdAt: DateTime.now(),
    );
  }
}
