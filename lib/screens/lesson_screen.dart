import 'package:flutter/material.dart';

import '../data/vocab_data.dart';
import '../models.dart';
import '../services/app_state.dart';
import '../services/haptics.dart';
import '../services/quiz_factory.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'quiz_screen.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  final AppState state;
  const LessonScreen({super.key, required this.lesson, required this.state});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  Future<void> _startQuiz() async {
    Haptics.light();
    final questions = buildLessonQuiz(widget.lesson);
    if (questions.isEmpty) {
      showSnack(context, 'Kuis untuk modul ini belum tersedia.');
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          title: 'Kuis modul',
          subtitle: widget.lesson.level,
          questions: questions,
          state: widget.state,
          passingScore: AppState.lessonPassThreshold,
          onFinished: (result) => widget.state.recordLessonAttempt(
            widget.lesson.id,
            result,
          ),
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final vocab = vocabForLesson(widget.lesson.id);
    final status = widget.state.lessonStatus(widget.lesson.id);
    final passed = status == LessonStatus.passed;
    final last = widget.state.lastAttempt(widget.lesson.id);
    final best = widget.state.bestAttemptPercent(widget.lesson.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modul belajar'),
        actions: [
          if (passed)
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Icon(Icons.verified_rounded, color: AppColors.mint),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Row(
            children: [
              LevelChip(widget.lesson.level),
              const SizedBox(width: 8),
              Text(
                '${vocab.length} kosakata inti',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.lesson.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            widget.lesson.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Kelulusan modul: minimal ${AppState.lessonPassThreshold}% pada kuis.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (status != LessonStatus.notStarted) ...[
            const SizedBox(height: 16),
            AppCard(
              color: (passed ? AppColors.mint : AppColors.amber)
                  .withValues(alpha: 0.08),
              border: Border.all(
                color: (passed ? AppColors.mint : AppColors.amber)
                    .withValues(alpha: 0.3),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        passed
                            ? Icons.check_circle_rounded
                            : Icons.replay_circle_filled_rounded,
                        color: passed ? AppColors.mint : AppColors.amber,
                        size: 19,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          passed
                              ? 'Modul lulus. Ulangi kuis kapan saja untuk menguatkan ingatan.'
                              : 'Belum lulus. Pelajari kembali materinya, lalu coba kuis lagi.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.text,
                              ),
                        ),
                      ),
                    ],
                  ),
                  if (last != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Percobaan terakhir: ${last.correct}/${last.total} benar · ${last.percent}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if (best != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      'Skor terbaik: $best% · riwayat tersimpan: ${widget.state.lessonAttempts[widget.lesson.id]?.length ?? 0} percobaan',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    'Buka kuis untuk melihat pembahasan dan jawaban yang salah.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          ...widget.lesson.sections.map(
            (section) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      section.body,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (section.examples.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      ...section.examples.map(
                        (example) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceAlt,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  example.ko,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  example.id,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (vocab.isNotEmpty) ...[
            const SizedBox(height: 8),
            const SectionHeader(
              'Kosakata modul',
              subtitle:
                  'Kosakata yang salah di kuis otomatis masuk antrean review.',
            ),
            ...vocab.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Flexible(
                                  child: Text(
                                    item.hangul,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 9),
                                Text(
                                  item.roman,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            item.meaning,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.mint,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${item.example}  ·  ${item.exampleId}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton.icon(
            onPressed: _startQuiz,
            icon: Icon(Icons.play_arrow_rounded),
            label: Text(
              passed
                  ? 'Ulangi kuis modul'
                  : status == LessonStatus.needsReview
                      ? 'Coba lagi kuis modul'
                      : 'Mulai kuis modul',
            ),
          ),
        ),
      ),
    );
  }
}
