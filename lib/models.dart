import 'dart:convert';

class Example {
  final String ko;
  final String id;
  const Example(this.ko, this.id);
}

class Vocab {
  final String hangul;
  final String roman;
  final String meaning;
  final String example;
  final String exampleId;
  final String level;
  final String lessonId;
  const Vocab({
    required this.hangul,
    required this.roman,
    required this.meaning,
    required this.example,
    required this.exampleId,
    required this.level,
    required this.lessonId,
  });
}

class LessonSection {
  final String title;
  final String body;
  final List<Example> examples;
  const LessonSection(this.title, this.body, [this.examples = const []]);
}

class Lesson {
  final String id;
  final String level;
  final String title;
  final String description;
  final List<LessonSection> sections;
  const Lesson({
    required this.id,
    required this.level,
    required this.title,
    required this.description,
    required this.sections,
  });
}

class QuizQuestion {
  final String prompt;
  final List<String> options;
  final int answerIndex;
  final String explanation;
  final String? hint;
  const QuizQuestion({
    required this.prompt,
    required this.options,
    required this.answerIndex,
    required this.explanation,
    this.hint,
  });
}

class GrammarPoint {
  final String pattern;
  final String level;
  final String formula;
  final String explanation;
  final List<Example> examples;
  final String pitfall;
  const GrammarPoint({
    required this.pattern,
    required this.level,
    required this.formula,
    required this.explanation,
    required this.examples,
    required this.pitfall,
  });
}

class DialogLine {
  final String speaker;
  final String ko;
  final String roman;
  final String id;
  const DialogLine(this.speaker, this.ko, this.roman, this.id);
}

class DialogScript {
  final String title;
  final String level;
  final String setting;
  final List<DialogLine> lines;
  const DialogScript({
    required this.title,
    required this.level,
    required this.setting,
    required this.lines,
  });
}

class ReadingSentence {
  final String ko;
  final String id;
  const ReadingSentence(this.ko, this.id);
}

class ReadingPassage {
  final String title;
  final String level;
  final String topic;
  final List<ReadingSentence> sentences;
  final List<QuizQuestion> questions;
  const ReadingPassage({
    required this.title,
    required this.level,
    required this.topic,
    required this.sentences,
    required this.questions,
  });
}

class DramaPhrase {
  final String ko;
  final String roman;
  final String id;
  final String note;
  const DramaPhrase(this.ko, this.roman, this.id, this.note);
}

class SrsCard {
  double ease;
  int intervalDays;
  int reps;
  int lapses;
  DateTime due;

  SrsCard({
    this.ease = 2.5,
    this.intervalDays = 0,
    this.reps = 0,
    this.lapses = 0,
    DateTime? due,
  }) : due = due ?? DateTime.now();

  bool get isDue => !due.isAfter(DateTime.now());

  Map<String, dynamic> toJson() => {
    'ease': ease,
    'intervalDays': intervalDays,
    'reps': reps,
    'lapses': lapses,
    'due': due.toIso8601String(),
  };

  factory SrsCard.fromJson(Map<String, dynamic> json) => SrsCard(
    ease: (json['ease'] as num?)?.toDouble() ?? 2.5,
    intervalDays: (json['intervalDays'] as num?)?.toInt() ?? 0,
    reps: (json['reps'] as num?)?.toInt() ?? 0,
    lapses: (json['lapses'] as num?)?.toInt() ?? 0,
    due: DateTime.tryParse(json['due'] as String? ?? '') ?? DateTime.now(),
  );

  static Map<String, SrsCard> decodeMap(String? raw) {
    if (raw == null || raw.isEmpty) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((key, value) => MapEntry(key, SrsCard.fromJson(value as Map<String, dynamic>)));
    } catch (_) {
      return {};
    }
  }
}

class QuizResult {
  final int correct;
  final int total;
  final bool timedOut;
  const QuizResult(this.correct, this.total, {this.timedOut = false});

  int get percent => total == 0 ? 0 : ((correct / total) * 100).round();
}
