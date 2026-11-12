import 'dart:math';

import '../data/vocab_data.dart';
import '../models.dart';

List<T> _shuffle<T>(Iterable<T> items, Random random) {
  final copy = [...items];
  copy.shuffle(random);
  return copy;
}

QuizQuestion _meaningQuestion(Vocab target, List<Vocab> pool, Random random) {
  final distractors = _shuffle(
    pool.where((v) => v.hangul != target.hangul && v.meaning != target.meaning),
    random,
  ).take(3).map((v) => v.meaning).toList();
  final options = _shuffle([target.meaning, ...distractors], random);
  return QuizQuestion(
    prompt: 'Apa arti "${target.hangul}" (${target.roman})?',
    options: options,
    answerIndex: options.indexOf(target.meaning),
    explanation:
        '"${target.hangul}" berarti ${target.meaning}. Contoh: ${target.example} — ${target.exampleId}',
    hint: target.level,
  );
}

QuizQuestion _hangulQuestion(Vocab target, List<Vocab> pool, Random random) {
  final distractors = _shuffle(
    pool.where((v) => v.hangul != target.hangul),
    random,
  ).take(3).map((v) => v.hangul).toList();
  final options = _shuffle([target.hangul, ...distractors], random);
  return QuizQuestion(
    prompt: 'Hangul dari "${target.roman}"?',
    options: options,
    answerIndex: options.indexOf(target.hangul),
    explanation:
        '${target.roman} ditulis ${target.hangul}, artinya ${target.meaning}.',
    hint: 'Ketik di tool Hangul untuk mencoba sendiri.',
  );
}

QuizQuestion _reverseQuestion(Vocab target, List<Vocab> pool, Random random) {
  final distractors = _shuffle(
    pool.where((v) => v.meaning != target.meaning),
    random,
  ).take(3).map((v) => v.hangul).toList();
  final options = _shuffle([target.hangul, ...distractors], random);
  return QuizQuestion(
    prompt: 'Bahasa Korea dari "${target.meaning}"?',
    options: options,
    answerIndex: options.indexOf(target.hangul),
    explanation:
        '${target.meaning} = ${target.hangul} (${target.roman}). Contoh: ${target.example}',
    hint: target.level,
  );
}

List<QuizQuestion> buildLessonQuiz(Lesson lesson, {Random? random}) {
  final rng = random ?? Random();
  final pool = vocabForLesson(lesson.id);
  if (pool.isEmpty) return [];
  final questions = <QuizQuestion>[];
  for (final vocab in pool.take(4)) {
    questions.add(_meaningQuestion(vocab, koreanVocab, rng));
  }
  if (pool.length >= 2) {
    questions.add(_hangulQuestion(pool[rng.nextInt(pool.length)], koreanVocab, rng));
  }
  return _shuffle(questions, rng);
}

List<QuizQuestion> buildQuestionBank({
  String? level,
  int count = 10,
  Random? random,
}) {
  final rng = random ?? Random();
  var pool = koreanVocab;
  if (level != null && level != 'Semua') {
    final filtered = koreanVocab.where((v) => v.level == level).toList();
    if (filtered.length >= 6) pool = filtered;
  }
  final picks = _shuffle(pool, rng).take(count).toList();
  return picks.map((vocab) {
    final roll = rng.nextInt(3);
    if (roll == 0) return _hangulQuestion(vocab, koreanVocab, rng);
    if (roll == 1) return _reverseQuestion(vocab, koreanVocab, rng);
    return _meaningQuestion(vocab, koreanVocab, rng);
  }).toList();
}

List<QuizQuestion> buildMockTest({int count = 20, Random? random}) {
  final rng = random ?? Random();
  final picks = _shuffle(koreanVocab, rng).take(count).toList();
  return picks.map((vocab) {
    final roll = rng.nextInt(3);
    if (roll == 0) return _hangulQuestion(vocab, koreanVocab, rng);
    if (roll == 1) return _reverseQuestion(vocab, koreanVocab, rng);
    return _meaningQuestion(vocab, koreanVocab, rng);
  }).toList();
}
