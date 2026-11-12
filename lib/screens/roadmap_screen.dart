import 'package:flutter/material.dart';

import '../data/lessons_data.dart';
import '../data/vocab_data.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'lesson_screen.dart';

class RoadmapScreen extends StatelessWidget {
  final AppState state;
  const RoadmapScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roadmap Korea'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: LevelChip('TOPIK 1–6'),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              GradientPanel(
                colors: const [Color(0xFF243462), Color(0xFF151D35)],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '한',
                          style: TextStyle(
                            fontSize: 34,
                            color: AppColors.onHero,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${state.lessonsDone}/${state.totalLessons} modul',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onHeroMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Hangul → C2',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(color: AppColors.onHero),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Jalur bertingkat mengikuti TOPIK. Selesaikan modul, lalu kunci dengan kuis dan SRS.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.onHeroMuted,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ProgressLine(value: state.overallProgress),
                    const SizedBox(height: 8),
                    Text(
                      '${(state.overallProgress * 100).round()}% perjalanan selesai',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.onHeroMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              for (final level in roadmapLevels) ...[
                _LevelSection(level: level, state: state),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _LevelSection extends StatelessWidget {
  final LevelMeta level;
  final AppState state;
  const _LevelSection({required this.level, required this.state});

  @override
  Widget build(BuildContext context) {
    final lessons = koreanLessons.where((l) => l.level == level.code).toList();
    if (lessons.isEmpty) return const SizedBox.shrink();
    final done = lessons.where((l) => state.completedLessons.contains(l.id)).length;
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LevelChip(level.code),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${level.exam} · ${level.description}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                '$done/${lessons.length}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...lessons.map(
            (lesson) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: AppCard(
                padding: const EdgeInsets.all(14),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        LessonScreen(lesson: lesson, state: state),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: state.completedLessons.contains(lesson.id)
                            ? AppColors.mint.withValues(alpha: 0.14)
                            : AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        state.completedLessons.contains(lesson.id)
                            ? Icons.check_rounded
                            : Icons.menu_book_rounded,
                        size: 19,
                        color: state.completedLessons.contains(lesson.id)
                            ? AppColors.mint
                            : AppColors.muted,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${vocabForLesson(lesson.id).length} kosakata · ${lesson.description}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.muted,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
