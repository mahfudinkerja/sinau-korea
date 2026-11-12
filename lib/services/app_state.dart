import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/lessons_data.dart';
import '../data/vocab_data.dart';
import '../models.dart';

enum SrsRating { again, hard, good, easy }

class AppState extends ChangeNotifier {
  final Random _random = Random();
  SharedPreferences? _prefs;
  bool ready = false;

  Set<String> completedLessons = {};
  Map<String, SrsCard> cards = {};
  Set<String> dramaChecked = {};
  int xp = 0;
  int streak = 0;
  String? lastStudyDay;
  int dailyXp = 0;
  String? dailyXpDay;
  int totalAnswered = 0;
  int totalCorrect = 0;
  int mockBest = 0;

  int get lessonsDone => completedLessons.length;
  int get totalLessons => koreanLessons.length;
  double get overallProgress =>
      totalLessons == 0 ? 0 : completedLessons.length / totalLessons;
  int get accuracy =>
      totalAnswered == 0 ? 0 : ((totalCorrect / totalAnswered) * 100).round();
  int get dueCount =>
      koreanVocab.where((v) => cards[v.roman]?.isDue ?? true).length;
  bool get dailyGoalDone => dailyXp >= 50;
  double get dailyGoalProgress => (dailyXp / 50).clamp(0, 1).toDouble();

  Lesson? get nextLesson {
    for (final lesson in koreanLessons) {
      if (!completedLessons.contains(lesson.id)) return lesson;
    }
    return koreanLessons.isEmpty ? null : koreanLessons.last;
  }

  List<Vocab> get dueVocab {
    final list = koreanVocab
        .where((v) => cards[v.roman]?.isDue ?? true)
        .toList();
    list.sort((a, b) {
      final aDue = cards[a.roman]?.due ?? DateTime.now();
      final bDue = cards[b.roman]?.due ?? DateTime.now();
      return aDue.compareTo(bDue);
    });
    return list;
  }

  List<Vocab> get randomDeck => ([...koreanVocab]..shuffle(_random)).take(10).toList();

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    completedLessons =
        (_prefs!.getStringList('completed_lessons') ?? const []).toSet();
    dramaChecked =
        (_prefs!.getStringList('drama_checked') ?? const []).toSet();
    cards = SrsCard.decodeMap(_prefs!.getString('srs_cards'));
    xp = _prefs!.getInt('xp') ?? 0;
    streak = _prefs!.getInt('streak') ?? 0;
    lastStudyDay = _prefs!.getString('last_study_day');
    dailyXp = _prefs!.getInt('daily_xp') ?? 0;
    dailyXpDay = _prefs!.getString('daily_xp_day');
    totalAnswered = _prefs!.getInt('total_answered') ?? 0;
    totalCorrect = _prefs!.getInt('total_correct') ?? 0;
    mockBest = _prefs!.getInt('mock_best') ?? 0;

    if (cards.isEmpty) {
      _seedDeck();
    }
    _rollDaily();
    ready = true;
    notifyListeners();
    await _persist();
  }

  void _seedDeck() {
    final base = DateTime.now().subtract(const Duration(minutes: 1));
    for (var i = 0; i < koreanVocab.length; i++) {
      final vocab = koreanVocab[i];
      cards[vocab.roman] = SrsCard(
        due: base.add(Duration(days: i ~/ 10)),
      );
    }
  }

  String _dayKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  void _rollDaily() {
    final today = _dayKey(DateTime.now());
    if (dailyXpDay != today) {
      dailyXp = 0;
      dailyXpDay = today;
    }
  }

  void _study({int xpGain = 0}) {
    _rollDaily();
    xp += xpGain;
    dailyXp += xpGain;

    final today = _dayKey(DateTime.now());
    if (lastStudyDay != today) {
      if (lastStudyDay != null) {
        final parsed = DateTime.tryParse(lastStudyDay!);
        final diff = parsed == null
            ? null
            : DateTime.now().difference(parsed).inDays;
        streak = diff == 1 ? streak + 1 : 1;
      } else {
        streak = 1;
      }
      lastStudyDay = today;
    }
    notifyListeners();
    _persist();
  }

  void recordAnswer(bool correct) {
    totalAnswered++;
    if (correct) totalCorrect++;
    _study(xpGain: correct ? 2 : 0);
  }

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
    if (normalized > mockBest) mockBest = normalized;
    _study(xpGain: 20);
  }

  void rateCard(Vocab vocab, SrsRating rating) {
    final card = cards.putIfAbsent(vocab.roman, () => SrsCard());
    final now = DateTime.now();
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
    _study(xpGain: 2);
  }

  Future<void> resetProgress() async {
    completedLessons.clear();
    dramaChecked.clear();
    cards.clear();
    xp = 0;
    streak = 0;
    lastStudyDay = null;
    dailyXp = 0;
    dailyXpDay = _dayKey(DateTime.now());
    totalAnswered = 0;
    totalCorrect = 0;
    mockBest = 0;
    _seedDeck();
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = _prefs;
    if (prefs == null) return;
    await prefs.setStringList('completed_lessons', completedLessons.toList());
    await prefs.setStringList('drama_checked', dramaChecked.toList());
    await prefs.setString(
      'srs_cards',
      jsonEncode(cards.map((key, value) => MapEntry(key, value.toJson()))),
    );
    await prefs.setInt('xp', xp);
    await prefs.setInt('streak', streak);
    if (lastStudyDay != null) await prefs.setString('last_study_day', lastStudyDay!);
    await prefs.setInt('daily_xp', dailyXp);
    if (dailyXpDay != null) await prefs.setString('daily_xp_day', dailyXpDay!);
    await prefs.setInt('total_answered', totalAnswered);
    await prefs.setInt('total_correct', totalCorrect);
    await prefs.setInt('mock_best', mockBest);
  }
}
