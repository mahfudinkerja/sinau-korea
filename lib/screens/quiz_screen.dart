import 'dart:async';

import 'package:flutter/material.dart';

import '../models.dart';
import '../services/app_state.dart';
import '../services/haptics.dart';
import '../theme.dart';
import '../widgets/common.dart';

class QuizScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<QuizQuestion> questions;
  final AppState state;
  final int? timeLimitSeconds;
  final void Function(QuizResult)? onFinished;

  const QuizScreen({
    super.key,
    required this.title,
    required this.questions,
    required this.state,
    this.subtitle = 'Latihan',
    this.timeLimitSeconds,
    this.onFinished,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int index = 0;
  int? selected;
  int correct = 0;
  bool finished = false;
  Timer? timer;
  int secondsLeft = 0;

  QuizQuestion get current => widget.questions[index];

  @override
  void initState() {
    super.initState();
    if (widget.timeLimitSeconds != null) {
      secondsLeft = widget.timeLimitSeconds!;
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) return;
        if (secondsLeft <= 1) {
          setState(() => secondsLeft = 0);
          _finish(timedOut: true);
        } else {
          setState(() => secondsLeft--);
        }
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _answer(int option) {
    if (selected != null) return;
    final isCorrect = option == current.answerIndex;
    setState(() {
      selected = option;
      if (isCorrect) correct++;
    });
    widget.state.recordAnswer(isCorrect);
    if (isCorrect) {
      Haptics.success();
    } else {
      Haptics.error();
    }
  }

  void _next() {
    if (selected == null) return;
    if (index == widget.questions.length - 1) {
      _finish();
    } else {
      setState(() {
        index++;
        selected = null;
      });
    }
  }

  void _finish({bool timedOut = false}) {
    if (finished) return;
    timer?.cancel();
    setState(() => finished = true);
    final result = QuizResult(
      correct,
      widget.questions.length,
      timedOut: timedOut,
    );
    widget.onFinished?.call(result);
  }

  void _restart() {
    timer?.cancel();
    setState(() {
      index = 0;
      selected = null;
      correct = 0;
      finished = false;
      if (widget.timeLimitSeconds != null) {
        secondsLeft = widget.timeLimitSeconds!;
        timer = Timer.periodic(const Duration(seconds: 1), (t) {
          if (!mounted) return;
          if (secondsLeft <= 1) {
            setState(() => secondsLeft = 0);
            _finish(timedOut: true);
          } else {
            setState(() => secondsLeft--);
          }
        });
      }
    });
  }

  String get _timerLabel {
    final minutes = secondsLeft ~/ 60;
    final seconds = secondsLeft % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: const EmptyState(
          icon: Icons.inbox_rounded,
          title: 'Belum ada soal',
          message: 'Materi untuk latihan ini belum tersedia.',
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (widget.timeLimitSeconds != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: secondsLeft < 60
                      ? AppColors.rose.withValues(alpha: 0.18)
                      : AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 15,
                      color: secondsLeft < 60 ? AppColors.rose : AppColors.amber,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _timerLabel,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: secondsLeft < 60
                            ? AppColors.rose
                            : AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: finished ? _resultView() : _questionView(),
    );
  }

  Widget _questionView() {
    final answered = selected != null;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        Row(
          children: [
            Text(
              'Soal ${index + 1}',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            ),
            Text(
              ' / ${widget.questions.length}',
              style: TextStyle(color: AppColors.muted, fontSize: 14),
            ),
            const Spacer(),
            Text(
              widget.subtitle,
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ProgressLine(
          value: (index + (answered ? 1 : 0)) / widget.questions.length,
          color: AppColors.primary,
          height: 6,
        ),
        const SizedBox(height: 24),
        AppCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.quiz_outlined,
                    size: 17,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'PILIH SATU JAWABAN',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const Spacer(),
                  if (current.hint != null) LevelChip(current.hint!, compact: true),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                current.prompt,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(current.options.length, (i) {
          final option = current.options[i];
          final isCorrect = i == current.answerIndex;
          final isPicked = i == selected;
          Color borderColor = AppColors.line;
          Color iconColor = AppColors.muted;
          IconData icon = Icons.radio_button_unchecked_rounded;
          if (answered) {
            if (isCorrect) {
              borderColor = AppColors.mint;
              iconColor = AppColors.mint;
              icon = Icons.check_circle_rounded;
            } else if (isPicked) {
              borderColor = AppColors.rose;
              iconColor = AppColors.rose;
              icon = Icons.cancel_rounded;
            }
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _answer(i),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isPicked && !isCorrect
                        ? AppColors.rose.withValues(alpha: 0.08)
                        : isCorrect && answered
                            ? AppColors.mint.withValues(alpha: 0.08)
                            : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, size: 20, color: iconColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        if (answered) ...[
          const SizedBox(height: 8),
          AppCard(
            color: AppColors.surfaceAlt,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      selected == current.answerIndex
                          ? Icons.lightbulb_rounded
                          : Icons.info_outline_rounded,
                      size: 17,
                      color: AppColors.amber,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      selected == current.answerIndex
                          ? 'Tepat!'
                          : 'Belum tepat',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  current.explanation,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _next,
            child: Text(
              index == widget.questions.length - 1
                  ? 'Lihat hasil'
                  : 'Soal berikutnya',
            ),
          ),
        ],
      ],
    );
  }

  Widget _resultView() {
    final total = widget.questions.length;
    final result = QuizResult(correct, total);
    final percent = result.percent;
    final emoji = percent >= 85
        ? '훌륭해요!'
        : percent >= 60
            ? '잘했어요!'
            : '다시 해 봐요';
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        Center(
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(
                color: percent >= 60 ? AppColors.mint : AppColors.amber,
                width: 3,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$percent%',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  '$correct / $total benar',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: Text(
            emoji,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.mint,
                ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            result.timedOut
                ? 'Waktu habis. Soal yang belum dijawab dihitung salah.'
                : 'Setiap jawaban sudah disimpan ke progresmu.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 24),
        SectionHeader('Pembahasan'),
        ...List.generate(widget.questions.length, (i) {
          final q = widget.questions[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${i + 1}. ${q.prompt}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: AppColors.mint,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          q.options[q.answerIndex],
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.mint,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    q.explanation,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _restart,
                child: const Text('Ulangi'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(result),
                child: const Text('Selesai'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
