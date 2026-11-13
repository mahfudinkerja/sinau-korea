import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sinau_korea/models.dart';
import 'package:sinau_korea/screens/quiz_screen.dart';
import 'package:sinau_korea/services/app_state.dart';
import 'package:sinau_korea/theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('kuis gagal menampilkan status belum lulus dan jawaban salah',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState(clock: () => DateTime(2026, 1, 1, 10));
    await state.load();
    QuizResult? finished;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: QuizScreen(
          title: 'Kuis modul',
          questions: const [
            QuizQuestion(
              prompt: 'Apa arti 안녕하세요?',
              options: ['terima kasih', 'halo'],
              answerIndex: 1,
              explanation: '안녕하세요 berarti halo.',
              vocabId: 'annyeonghaseyo',
            ),
          ],
          state: state,
          passingScore: AppState.lessonPassThreshold,
          onFinished: (result) => finished = result,
        ),
      ),
    );

    await tester.tap(find.text('terima kasih'));
    await tester.pump();
    await tester.tap(find.text('Lihat hasil'));
    await tester.pump();

    expect(finished, isNotNull);
    expect(finished!.percent, 0);
    expect(find.textContaining('BELUM LULUS'), findsOneWidget);
    expect(find.text('Jawabanmu: terima kasih'), findsOneWidget);
    expect(find.textContaining('antrean review SRS'), findsOneWidget);
  });

  testWidgets('kuis lulus menampilkan status lulus', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState(clock: () => DateTime(2026, 1, 1, 10));
    await state.load();

    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: QuizScreen(
          title: 'Kuis modul',
          questions: const [
            QuizQuestion(
              prompt: 'Apa arti 감사합니다?',
              options: ['halo', 'terima kasih'],
              answerIndex: 1,
              explanation: '감사합니다 berarti terima kasih.',
              vocabId: 'gamsahamnida',
            ),
          ],
          state: state,
          passingScore: AppState.lessonPassThreshold,
        ),
      ),
    );

    await tester.tap(find.text('terima kasih'));
    await tester.pump();
    await tester.tap(find.text('Lihat hasil'));
    await tester.pump();

    expect(find.textContaining('LULUS'), findsOneWidget);
    expect(find.textContaining('BELUM LULUS'), findsNothing);
  });
}
