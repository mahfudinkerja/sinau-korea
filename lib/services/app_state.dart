import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/lessons_data.dart';
import '../data/vocab_data.dart';
import '../models.dart';
import 'haptics.dart';

enum SrsRating { again, hard, good, easy }

enum LessonStatus { notStarted, inProgress, passed, needsReview }

/// Snapshot untuk membatalkan satu rating kartu SRS.
class SrsUndo {
  final bool hadCard;
  final SrsCard? previous;
  final int xpAwarded;

  const SrsUndo({
    required this.hadCard,
    required this.previous,
    required this.xpAwarded,
  });
}

class AppState extends ChangeNotifier {
  AppState({DateTime Function()? clock}) : _now = clock ?? DateTime.now;

  final DateTime Function() _now;
  final Random _random = Random();

  static const int schemaVersion = 2;
  static const int lessonPassThreshold = kLessonPassThreshold;
  static const int dailyGoalXp = 50;
  static const int dailyXpCap = 200;

  SharedPreferences? _prefs;
  Future<void> _writeQueue = Future.value();
  bool ready = false;

  Set<String> completedLessons = {};
  Map<String, SrsCard> cards = {};
  Map<String, List<LessonAttempt>> lessonAttempts = {};
  Map<String, MistakeEntry> mistakes = {};
  Map<String, VocabStat> vocabStats = {};
  Set<String> dramaChecked = {};
  int xp = 0;
  int streak = 0;
  String? lastStudyDay;
  int dailyXp = 0;
  String? dailyXpDay;
  int totalAnswered = 0;
  int totalCorrect = 0;
  int mockBest = 0;
  ThemeMode themeMode = ThemeMode.system;
  bool hapticsEnabled = true;

  int get lessonsDone => completedLessons.length;
  int get totalLessons => koreanLessons.length;
  double get overallProgress =>
      totalLessons == 0 ? 0 : completedLessons.length / totalLessons;
  int get accuracy =>
      totalAnswered == 0 ? 0 : ((totalCorrect / totalAnswered) * 100).round();
  bool get dailyGoalDone => dailyXp >= dailyGoalXp;
  double get dailyGoalProgress => (dailyXp / dailyGoalXp).clamp(0, 1).toDouble();

  Lesson? get nextLesson {
    for (final lesson in koreanLessons) {
      if (!completedLessons.contains(lesson.id)) return lesson;
    }
    return koreanLessons.isEmpty ? null : koreanLessons.last;
  }

  /// Hanya kartu yang sudah diperkenalkan yang bisa jatuh tempo. Kartu yang
  /// belum pernah disentuh tidak boleh membanjiri antrean review.
  List<Vocab> get dueVocab {
    final list = koreanVocab
        .where((v) {
          final card = cards[v.roman];
          return card != null && card.isDueAt(_now());
        })
        .toList();
    list.sort((a, b) {
      final aMistakes = mistakes[a.roman]?.count ?? 0;
      final bMistakes = mistakes[b.roman]?.count ?? 0;
      if (aMistakes != bMistakes) return bMistakes.compareTo(aMistakes);
      final aDue = cards[a.roman]?.due ?? _now();
      final bDue = cards[b.roman]?.due ?? _now();
      return aDue.compareTo(bDue);
    });
    return list;
  }

  int get dueCount => dueVocab.length;

  List<Vocab> get mistakeVocab {
    final list = koreanVocab.where((v) => mistakes.containsKey(v.roman)).toList();
    list.sort(
      (a, b) => (mistakes[b.roman]?.count ?? 0).compareTo(
        mistakes[a.roman]?.count ?? 0,
      ),
    );
    return list;
  }

  List<Vocab> get randomDeck =>
      ([...koreanVocab]..shuffle(_random)).take(10).toList();

  LessonStatus lessonStatus(String lessonId) {
    final attempts = lessonAttempts[lessonId] ?? const <LessonAttempt>[];
    final hasPassed =
        completedLessons.contains(lessonId) || attempts.any((a) => a.passed);
    if (hasPassed) return LessonStatus.passed;
    if (attempts.isNotEmpty) return LessonStatus.needsReview;
    return LessonStatus.notStarted;
  }

  LessonAttempt? lastAttempt(String lessonId) {
    final attempts = lessonAttempts[lessonId];
    if (attempts == null || attempts.isEmpty) return null;
    return attempts.last;
  }

  /// Null berarti modul lulus dari riwayat versi lama tanpa skor tersimpan.
  int? bestAttemptPercent(String lessonId) {
    final attempts = lessonAttempts[lessonId] ?? const <LessonAttempt>[];
    if (attempts.isEmpty) return null;
    return attempts.fold<int>(0, (best, a) => max(best, a.percent));
  }

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    completedLessons =
        (_prefs!.getStringList('completed_lessons') ?? const []).toSet();
    dramaChecked =
        (_prefs!.getStringList('drama_checked') ?? const []).toSet();
    cards = SrsCard.decodeMap(_prefs!.getString('srs_cards'));
    lessonAttempts =
        LessonAttempt.decodeMap(_prefs!.getString('lesson_attempts'));
    mistakes = MistakeEntry.decodeMap(_prefs!.getString('mistakes'));
    vocabStats = VocabStat.decodeMap(_prefs!.getString('vocab_stats'));
    xp = _prefs!.getInt('xp') ?? 0;
    streak = _prefs!.getInt('streak') ?? 0;
    lastStudyDay = _prefs!.getString('last_study_day');
    dailyXp = _prefs!.getInt('daily_xp') ?? 0;
    dailyXpDay = _prefs!.getString('daily_xp_day');
    totalAnswered = _prefs!.getInt('total_answered') ?? 0;
    totalCorrect = _prefs!.getInt('total_correct') ?? 0;
    mockBest = _prefs!.getInt('mock_best') ?? 0;
    themeMode = switch (_prefs!.getString('theme_mode')) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    hapticsEnabled = _prefs!.getBool('haptics_enabled') ?? true;
    Haptics.enabled = hapticsEnabled;

    final storedSchema = _prefs!.getInt('schema_version') ?? 1;
    if (storedSchema < schemaVersion) _migrateSrsSeed();
    if (cards.isEmpty) _seedDeck();
    _refreshStreak();
    _rollDaily();
    ready = true;
    notifyListeners();
    await _persistNow();
  }

  /// Sensus v1 mengisi kartu untuk seluruh kosakata, sehingga kartu yang belum
  /// pernah dipelajari ikut jatuh tempo. Hapus hanya kartu yang jelas belum
  /// pernah disentuh (belum pernah dinilai dan jadwalnya masih di masa depan).
  void _migrateSrsSeed() {
    final now = _now();
    cards.removeWhere(
      (_, card) =>
          card.reps == 0 &&
          card.lapses == 0 &&
          card.intervalDays == 0 &&
          card.due.isAfter(now),
    );
  }

  void _seedDeck() {
    final base = _now().subtract(const Duration(minutes: 1));
    for (final vocab in koreanVocab.take(10)) {
      cards.putIfAbsent(vocab.roman, () => SrsCard(due: base));
    }
  }

  String _dayKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  int _dayDiff(String fromKey, String toKey) {
    final from = DateTime.tryParse(fromKey);
    final to = DateTime.tryParse(toKey);
    if (from == null || to == null) return 1;
    return DateTime(to.year, to.month, to.day)
        .difference(DateTime(from.year, from.month, from.day))
        .inDays;
  }

  void _rollDaily() {
    final today = _dayKey(_now());
    if (dailyXpDay != today) {
      dailyXp = 0;
      dailyXpDay = today;
    }
  }

  void _refreshStreak() {
    if (lastStudyDay == null) return;
    if (_dayDiff(lastStudyDay!, _dayKey(_now())) > 1) streak = 0;
  }

  /// Dipanggil saat app kembali ke foreground agar tanggal dan streak akurat.
  void refreshTimeSensitive() {
    final today = _dayKey(_now());
    var changed = false;
    if (dailyXpDay != today) {
      dailyXp = 0;
      dailyXpDay = today;
      changed = true;
    }
    if (lastStudyDay != null && streak != 0) {
      if (_dayDiff(lastStudyDay!, today) > 1) {
        streak = 0;
        changed = true;
      }
    }
    if (changed) {
      notifyListeners();
      _persist();
    }
  }

  /// XP dibatasi per hari agar jawaban berulang tidak bisa dipakai farming.
  void _study({int xpGain = 0}) {
    _rollDaily();
    final allowed = max(0, min(xpGain, dailyXpCap - dailyXp));
    xp += allowed;
    dailyXp += allowed;

    final today = _dayKey(_now());
    if (lastStudyDay != today) {
      if (lastStudyDay != null) {
        streak = _dayDiff(lastStudyDay!, today) == 1 ? streak + 1 : 1;
      } else {
        streak = 1;
      }
      lastStudyDay = today;
    }
    notifyListeners();
    _persist();
  }

  @Deprecated('Gunakan recordQuizAnswer agar kesalahan terhubung ke SRS.')
  void recordAnswer(bool correct) => recordQuizAnswer(correct: correct);

  void recordQuizAnswer({
    required bool correct,
    String? vocabId,
    String? prompt,
    String? correctAnswer,
    String? explanation,
  }) {
    totalAnswered++;
    if (correct) totalCorrect++;
    final at = _now();

    if (vocabId != null && vocabId.isNotEmpty) {
      final stat = vocabStats.putIfAbsent(vocabId, () => VocabStat());
      if (correct) {
        stat.correct++;
        final mistake = mistakes[vocabId];
        if (mistake != null) {
          mistake.correctStreak++;
          mistake.lastAt = at;
          if (mistake.correctStreak >= 2) mistakes.remove(vocabId);
        }
      } else {
        stat.wrong++;
        final card = cards.putIfAbsent(vocabId, () => SrsCard(due: at));
        card.lapses++;
        card.reps = 0;
        card.intervalDays = 0;
        card.ease = max(1.3, card.ease - 0.2);
        card.due = at;
        final mistake = mistakes.putIfAbsent(
          vocabId,
          () => MistakeEntry(id: vocabId, vocabId: vocabId, lastAt: at),
        );
        mistake
          ..prompt = prompt ?? mistake.prompt
          ..correctAnswer = correctAnswer ?? mistake.correctAnswer
          ..explanation = explanation ?? mistake.explanation
          ..count = mistake.count + 1
          ..correctStreak = 0
          ..lastAt = at;
      }
    } else if (!correct) {
      // Soal non-kosakata tetap punya bank kesalahan sendiri, tidak dipaksa
      // menjadi kartu SRS.
      final key = 'q:${prompt ?? 'tanpa-prompt'}';
      final mistake = mistakes.putIfAbsent(
        key,
        () => MistakeEntry(id: key, lastAt: at),
      );
      mistake
        ..prompt = prompt ?? mistake.prompt
        ..correctAnswer = correctAnswer ?? mistake.correctAnswer
        ..explanation = explanation ?? mistake.explanation
        ..count = mistake.count + 1
        ..correctStreak = 0
        ..lastAt = at;
    }

    _study(xpGain: correct ? 2 : 0);
  }

  LessonAttempt recordLessonAttempt(String lessonId, QuizResult result) {
    final attempt = LessonAttempt(
      correct: result.correct,
      total: result.total,
      at: _now(),
    );
    final attempts = lessonAttempts.putIfAbsent(
      lessonId,
      () => <LessonAttempt>[],
    );
    attempts.add(attempt);
    if (attempts.length > 20) {
      attempts.removeRange(0, attempts.length - 20);
    }

    var xpGain = 0;
    if (attempt.passed && completedLessons.add(lessonId)) {
      xpGain = 25;
    }
    _study(xpGain: xpGain);
    return attempt;
  }

  @Deprecated('Gunakan recordLessonAttempt agar ambang kelulusan diterapkan.')
  void completeLesson(String lessonId) {
    if (completedLessons.add(lessonId)) {
      _study(xpGain: 25);
    } else {
      _study();
    }
  }

  void toggleDrama(String phrase) {
    if (!dramaChecked.remove(phrase)) {
      dramaChecked.add(phrase);
      _study(xpGain: 3);
    } else {
      _study();
    }
  }

  void recordMockScore(int score, int total) {
    final normalized = total == 0 ? 0 : ((score / total) * 100).round();
    final improved = normalized > mockBest;
    if (improved) mockBest = normalized;
    _study(xpGain: improved ? 20 : 0);
  }

  void setThemeMode(ThemeMode mode) {
    if (themeMode == mode) return;
    themeMode = mode;
    Haptics.selection();
    notifyListeners();
    _persist();
  }

  void setHapticsEnabled(bool enabled) {
    hapticsEnabled = enabled;
    Haptics.enabled = enabled;
    if (enabled) Haptics.selection();
    notifyListeners();
    _persist();
  }

  SrsUndo rateCard(Vocab vocab, SrsRating rating) {
    final existing = cards[vocab.roman];
    final snapshot = existing?.copy();
    final now = _now();
    final wasDue = existing == null || existing.isDueAt(now);
    final card = cards.putIfAbsent(vocab.roman, () => SrsCard(due: now));
    switch (rating) {
      case SrsRating.again:
        card.lapses += 1;
        card.reps = 0;
        card.intervalDays = 0;
        card.ease = max(1.3, card.ease - 0.2);
        card.due = now.add(const Duration(minutes: 10));
      case SrsRating.hard:
        card.reps += 1;
        card.intervalDays = max(1, (card.intervalDays * 1.2).round());
        card.ease = max(1.3, card.ease - 0.15);
        card.due = now.add(Duration(days: card.intervalDays));
      case SrsRating.good:
        card.reps += 1;
        card.intervalDays = card.reps <= 1
            ? 1
            : card.reps == 2
                ? 3
                : max(1, (card.intervalDays * card.ease).round());
        card.due = now.add(Duration(days: card.intervalDays));
      case SrsRating.easy:
        card.ease = min(3.2, card.ease + 0.15);
        card.reps += 1;
        final base = max(1, card.intervalDays);
        card.intervalDays = max(1, (base * card.ease * 1.3).round());
        card.due = now.add(Duration(days: card.intervalDays));
    }
    final xpAwarded = wasDue ? 2 : 0;
    _study(xpGain: xpAwarded);
    return SrsUndo(
      hadCard: existing != null,
      previous: snapshot,
      xpAwarded: xpAwarded,
    );
  }

  void undoRating(Vocab vocab, SrsUndo undo) {
    if (undo.hadCard && undo.previous != null) {
      cards[vocab.roman] = undo.previous!;
    } else {
      cards.remove(vocab.roman);
    }
    xp = max(0, xp - undo.xpAwarded);
    dailyXp = max(0, dailyXp - undo.xpAwarded);
    notifyListeners();
    _persist();
  }

  Future<void> resetProgress() async {
    completedLessons.clear();
    lessonAttempts.clear();
    mistakes.clear();
    vocabStats.clear();
    dramaChecked.clear();
    cards.clear();
    xp = 0;
    streak = 0;
    lastStudyDay = null;
    dailyXp = 0;
    dailyXpDay = _dayKey(_now());
    totalAnswered = 0;
    totalCorrect = 0;
    mockBest = 0;
    _seedDeck();
    notifyListeners();
    _persist();
    await flush();
  }

  Future<void> flush() => _writeQueue;

  void _persist() {
    _writeQueue = _writeQueue
        .then((_) => _persistNow())
        .catchError((Object error, StackTrace stack) {
          debugPrint('Gagal menyimpan progres: $error');
        });
  }

  Future<void> _persistNow() async {
    final prefs = _prefs;
    if (prefs == null) return;
    await prefs.setStringList('completed_lessons', completedLessons.toList());
    await prefs.setStringList('drama_checked', dramaChecked.toList());
    await prefs.setString(
      'srs_cards',
      jsonEncode(cards.map((key, value) => MapEntry(key, value.toJson()))),
    );
    await prefs.setString(
      'lesson_attempts',
      jsonEncode(
        lessonAttempts.map(
          (key, value) =>
              MapEntry(key, value.map((a) => a.toJson()).toList()),
        ),
      ),
    );
    await prefs.setString(
      'mistakes',
      jsonEncode(mistakes.map((key, value) => MapEntry(key, value.toJson()))),
    );
    await prefs.setString(
      'vocab_stats',
      jsonEncode(
        vocabStats.map((key, value) => MapEntry(key, value.toJson())),
      ),
    );
    await prefs.setInt('xp', xp);
    await prefs.setInt('streak', streak);
    if (lastStudyDay != null) {
      await prefs.setString('last_study_day', lastStudyDay!);
    }
    await prefs.setInt('daily_xp', dailyXp);
    if (dailyXpDay != null) {
      await prefs.setString('daily_xp_day', dailyXpDay!);
    }
    await prefs.setInt('total_answered', totalAnswered);
    await prefs.setInt('total_correct', totalCorrect);
    await prefs.setInt('mock_best', mockBest);
    await prefs.setInt('schema_version', schemaVersion);
    await prefs.setString('theme_mode', switch (themeMode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    });
    await prefs.setBool('haptics_enabled', hapticsEnabled);
  }
}
