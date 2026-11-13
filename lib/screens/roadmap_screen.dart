import 'package:flutter/material.dart';

import '../data/lessons_data.dart';
import '../data/vocab_data.dart';
import '../models.dart';
import '../services/app_state.dart';
import '../services/haptics.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'lesson_screen.dart';

class RoadmapScreen extends StatefulWidget {
  final AppState state;
  final VoidCallback? onProfile;
  const RoadmapScreen({super.key, required this.state, this.onProfile});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  String? _filter;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final levels = roadmapLevels
            .where(
              (level) =>
                  koreanLessons.any((lesson) => lesson.level == level.code),
            )
            .toList();
        final visible = _filter == null
            ? levels
            : levels.where((level) => level.code == _filter).toList();
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                AppHeader(
                  title: 'Kurikulum',
                  streak: state.streak,
                  onProfile: widget.onProfile,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                    children: [
                      _TrackCard(state: state),
                      const SizedBox(height: 14),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _FilterChip(
                              label: 'Semua',
                              selected: _filter == null,
                              onTap: () => setState(() => _filter = null),
                            ),
                            for (final level in levels) ...[
                              const SizedBox(width: 7),
                              _FilterChip(
                                label: level.code,
                                selected: _filter == level.code,
                                onTap: () =>
                                    setState(() => _filter = level.code),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      for (final level in visible) ...[
                        _LevelSection(
                          level: level,
                          state: state,
                          activeLessonId: state.nextLesson?.id,
                        ),
                        const SizedBox(height: 18),
                      ],
                      _MotivationCard(state: state),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TrackCard extends StatelessWidget {
  final AppState state;
  const _TrackCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final percent = (state.overallProgress * 100).round();
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SoftIcon(
                icon: Icons.alt_route_rounded,
                color: AppColors.primary,
                size: 42,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'JALUR BELAJAR',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'TOPIK Standar (A0–C2)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${state.lessonsDone}/${state.totalLessons}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Kemajuan keseluruhan',
                      style: TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                    const Spacer(),
                    Text(
                      '$percent%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ProgressLine(
                  value: state.overallProgress,
                  color: AppColors.mint,
                  height: 7,
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      size: 14,
                      color: AppColors.mint,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Lulus modul minimal ${AppState.lessonPassThreshold}%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.muted,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.bolt_rounded, size: 14, color: AppColors.amber),
                    const SizedBox(width: 2),
                    Text(
                      '${state.dailyXp} XP hari ini',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.tertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.line,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              color: selected ? AppColors.onPrimary : AppColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelSection extends StatelessWidget {
  final LevelMeta level;
  final AppState state;
  final String? activeLessonId;
  const _LevelSection({
    required this.level,
    required this.state,
    required this.activeLessonId,
  });

  @override
  Widget build(BuildContext context) {
    final lessons = koreanLessons
        .where((lesson) => lesson.level == level.code)
        .toList();
    final done = lessons
        .where((lesson) => state.completedLessons.contains(lesson.id))
        .length;
    final allDone = done == lessons.length;
    final color = levelColor(level.code);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              SoftIcon(
                icon: allDone
                    ? Icons.workspace_premium_rounded
                    : done > 0
                    ? Icons.school_rounded
                    : Icons.lock_open_rounded,
                color: color,
                size: 42,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Level ${level.code}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: allDone
                                ? AppColors.secondaryContainer.withValues(
                                    alpha: 0.6,
                                  )
                                : color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            allDone ? 'Selesai' : '$done/${lessons.length}',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: allDone
                                  ? AppColors.onSecondaryContainer
                                  : color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${level.name} · ${level.exam}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      level.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < lessons.length; i++)
          _TimelineNode(
            lesson: lessons[i],
            state: state,
            isLast: i == lessons.length - 1,
            isActive: lessons[i].id == activeLessonId,
          ),
      ],
    );
  }
}

class _TimelineNode extends StatelessWidget {
  final Lesson lesson;
  final AppState state;
  final bool isLast;
  final bool isActive;
  const _TimelineNode({
    required this.lesson,
    required this.state,
    required this.isLast,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final status = state.lessonStatus(lesson.id);
    final passed = status == LessonStatus.passed;
    final needsReview = status == LessonStatus.needsReview;
    final score = state.bestAttemptPercent(lesson.id);
    final color = passed
        ? AppColors.mint
        : needsReview
        ? AppColors.amber
        : isActive
        ? AppColors.primary
        : AppColors.outline;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: passed || needsReview || isActive
                        ? color
                        : AppColors.surfaceHigh,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: passed || needsReview || isActive
                          ? color
                          : AppColors.track,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    passed
                        ? Icons.check_rounded
                        : needsReview
                        ? Icons.replay_rounded
                        : isActive
                        ? Icons.play_arrow_rounded
                        : Icons.menu_book_rounded,
                    size: 13,
                    color: passed || needsReview || isActive
                        ? Colors.white
                        : AppColors.muted,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      color: passed
                          ? AppColors.mint.withValues(alpha: 0.45)
                          : AppColors.track,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _LessonCard(
                lesson: lesson,
                state: state,
                passed: passed,
                needsReview: needsReview,
                active: isActive,
                score: score,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final Lesson lesson;
  final AppState state;
  final bool passed;
  final bool needsReview;
  final bool active;
  final int? score;
  const _LessonCard({
    required this.lesson,
    required this.state,
    required this.passed,
    required this.needsReview,
    required this.active,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final vocabCount = vocabForLesson(lesson.id).length;
    final statusLine = passed
        ? score == null
              ? 'Selesai'
              : 'Lulus · skor $score%'
        : needsReview
        ? score == null
              ? 'Perlu diulang'
              : 'Perlu diulang · skor $score%'
        : active
        ? 'Sedang dipelajari'
        : 'Belum dimulai';
    final statusColor = passed
        ? AppColors.mint
        : needsReview
        ? AppColors.amber
        : active
        ? AppColors.primary
        : AppColors.muted;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Haptics.selection();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => LessonScreen(lesson: lesson, state: state),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: active
                  ? AppColors.primary.withValues(alpha: 0.45)
                  : AppColors.line,
              width: active ? 1.4 : 1,
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: active
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _hangulFor(lesson.id),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MODUL ${lesson.id.toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                lesson.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      lesson.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _MetaPill(
                          icon: Icons.translate_rounded,
                          label: '$vocabCount kata',
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        _MetaPill(
                          icon: Icons.fact_check_rounded,
                          label: 'Lulus 70%',
                          color: AppColors.amber,
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLow,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Text(
                        _hangulFor(lesson.id),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: passed ? AppColors.muted : AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            statusLine,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      passed
                          ? Icons.check_circle_rounded
                          : Icons.chevron_right_rounded,
                      size: 18,
                      color: passed ? AppColors.mint : AppColors.muted,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  String _hangulFor(String id) {
    const map = {
      'a0-1': '안녕',
      'a0-2': '받침',
      'a1-1': '일상',
      'a1-2': '시간',
      'a2-1': '여행',
      'a2-2': '감정',
      'b1-1': '의견',
      'b1-2': '면접',
      'b2-1': '사회',
      'b2-2': '논리',
      'c1-1': '분석',
      'c2-1': '담론',
    };
    return map[id] ?? '한글';
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MetaPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MotivationCard extends StatelessWidget {
  final AppState state;
  const _MotivationCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final next = state.nextLesson;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.surfaceLow, AppColors.primaryFixed],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SoftIcon(
            icon: Icons.emoji_events_rounded,
            color: AppColors.primary,
            size: 40,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  next == null
                      ? 'Semua modul sudah terbuka'
                      : 'Lanjutkan ${next.title}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '10 menit setiap hari membantu retensi memori jangka panjang.',
                  style: TextStyle(fontSize: 10, color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
