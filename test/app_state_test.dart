import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sinau_korea/data/vocab_data.dart';
import 'package:sinau_korea/models.dart';
import 'package:sinau_korea/services/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('mastery modul', () {
    test('skor di bawah 70% tidak menyelesaikan modul', () async {
      final state = AppState(clock: () => DateTime(2026, 1, 1, 10));
      await state.load();

      final attempt = state.recordLessonAttempt(
        'a0-1',
        const QuizResult(0, 5),
      );

      expect(attempt.percent, 0);
      expect(attempt.passed, isFalse);
      expect(state.completedLessons, isEmpty);
      expect(state.lessonStatus('a0-1'), LessonStatus.needsReview);
      expect(state.xp, 0);
    });

    test('skor 70% ke atas lulus dan tidak memberi XP ganda saat diulang',
        () async {
      final state = AppState(clock: () => DateTime(2026, 1, 1, 10));
      await state.load();

      state.recordLessonAttempt('a0-1', const QuizResult(3, 5));
      expect(state.completedLessons.contains('a0-1'), isFalse);

      state.recordLessonAttempt('a0-1', const QuizResult(4, 5));
      expect(state.completedLessons.contains('a0-1'), isTrue);
      expect(state.lessonStatus('a0-1'), LessonStatus.passed);
      expect(state.xp, 25);

      state.recordLessonAttempt('a0-1', const QuizResult(5, 5));
      expect(state.xp, 25, reason: 'percobaan ulang tidak menambah XP modul');
      expect(state.lessonAttempts['a0-1']!.length, 3);
    });

    test('riwayat kelulusan lama tetap dipertahankan saat migrasi', () async {
      SharedPreferences.setMockInitialValues({
        'completed_lessons': ['a0-1'],
        'srs_cards': '{}',
        'schema_version': 1,
      });
      final state = AppState(clock: () => DateTime(2026, 1, 1, 10));
      await state.load();

      expect(state.lessonStatus('a0-1'), LessonStatus.passed);
      expect(state.bestAttemptPercent('a0-1'), isNull);
    });
  });

  group('integrasi kuis dan SRS', () {
    test('jawaban kosakata salah membuat kartu jatuh tempo dan kesalahan',
        () async {
      final vocab = koreanVocab.first;
      final state = AppState(clock: () => DateTime(2026, 1, 1, 10));
      await state.load();
      final before = state.cards.length;

      state.recordQuizAnswer(
        correct: false,
        vocabId: vocab.roman,
        prompt: 'Apa arti ${vocab.hangul}?',
        correctAnswer: vocab.meaning,
      );

      expect(state.cards.length, before, reason: 'tidak boleh membuat duplikat');
      expect(state.cards[vocab.roman]!.isDueAt(DateTime(2026, 1, 1, 10)), isTrue);
      expect(state.mistakes.containsKey(vocab.roman), isTrue);
      expect(state.dueVocab.first.roman, vocab.roman);
      expect(state.vocabStats[vocab.roman]!.wrong, 1);
    });

    test('jawaban benar dicatat tanpa menggandakan kartu', () async {
      final vocab = koreanVocab.first;
      final state = AppState(clock: () => DateTime(2026, 1, 1, 10));
      await state.load();
      final before = state.cards.length;

      state.recordQuizAnswer(
        correct: true,
        vocabId: vocab.roman,
        prompt: 'Apa arti ${vocab.hangul}?',
        correctAnswer: vocab.meaning,
      );

      expect(state.cards.length, before);
      expect(state.vocabStats[vocab.roman]!.correct, 1);
      expect(state.totalCorrect, 1);
    });

    test('kesalahan non-kosakata masuk bank kesalahan tanpa kartu SRS',
        () async {
      final state = AppState(clock: () => DateTime(2026, 1, 1, 10));
      await state.load();
      final before = state.cards.length;

      state.recordQuizAnswer(
        correct: false,
        prompt: 'Partikel subjek yang tepat?',
        correctAnswer: '이/가',
        explanation: '이 dipakai setelah batchim.',
      );

      expect(state.cards.length, before);
      expect(
        state.mistakes.keys.any((key) => key.startsWith('q:')),
        isTrue,
      );
    });

    test('rating kartu bisa diurungkan', () async {
      final vocab = koreanVocab.first;
      final state = AppState(clock: () => DateTime(2026, 1, 1, 10));
      await state.load();
      final beforeDue = state.cards[vocab.roman]!.due;

      final undo = state.rateCard(vocab, SrsRating.good);
      expect(state.cards[vocab.roman]!.due.isAfter(beforeDue), isTrue);

      state.undoRating(vocab, undo);
      expect(state.cards[vocab.roman]!.due, beforeDue);
      expect(state.xp, 0);
    });
  });

  group('XP dan streak', () {
    test('XP harian dibatasi agar tidak bisa farming', () async {
      final state = AppState(clock: () => DateTime(2026, 1, 1, 10));
      await state.load();

      for (var i = 0; i < 120; i++) {
        state.recordQuizAnswer(correct: true);
      }

      expect(state.dailyXp, AppState.dailyXpCap);
      expect(state.xp, AppState.dailyXpCap);
      expect(state.totalAnswered, 120);
    });

    test('streak memakai tanggal kalender dan reset setelah bolong', () async {
      var now = DateTime(2026, 1, 1, 10);
      final state = AppState(clock: () => now);
      await state.load();

      state.recordQuizAnswer(correct: true);
      expect(state.streak, 1);

      now = DateTime(2026, 1, 2, 23, 30);
      state.recordQuizAnswer(correct: true);
      expect(state.streak, 2);

      now = DateTime(2026, 1, 4, 0, 30);
      state.refreshTimeSensitive();
      expect(state.streak, 0);
      expect(state.dailyXp, 0);

      state.recordQuizAnswer(correct: true);
      expect(state.streak, 1);
    });

    test('skor latihan hanya memberi XP saat rekor meningkat', () async {
      final state = AppState(clock: () => DateTime(2026, 1, 1, 10));
      await state.load();

      state.recordMockScore(10, 20);
      expect(state.xp, 20);

      state.recordMockScore(5, 20);
      expect(state.xp, 20);

      state.recordMockScore(15, 20);
      expect(state.xp, 40);
    });
  });

  test('riwayat percobaan bertahan setelah reload', () async {
    final state = AppState(clock: () => DateTime(2026, 1, 1, 10));
    await state.load();
    state.recordLessonAttempt('a0-2', const QuizResult(2, 5));
    await state.flush();

    final restored = AppState(clock: () => DateTime(2026, 1, 1, 11));
    await restored.load();

    expect(restored.lessonAttempts['a0-2']!.length, 1);
    expect(restored.lastAttempt('a0-2')!.percent, 40);
    expect(restored.lessonStatus('a0-2'), LessonStatus.needsReview);
  });
}
