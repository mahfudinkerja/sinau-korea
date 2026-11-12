import 'package:flutter/material.dart';

import '../data/drama_data.dart';
import '../data/lessons_data.dart';
import '../services/app_state.dart';
import '../services/haptics.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/update_banner.dart';
import 'dialog_screens.dart';
import 'drama_screen.dart';
import 'hangul_tool_screen.dart';
import 'lesson_screen.dart';
import 'question_bank_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  final AppState state;
  final VoidCallback onOpenRoadmap;
  final VoidCallback onOpenReview;
  final VoidCallback onOpenPractice;
  const HomeScreen({
    super.key,
    required this.state,
    required this.onOpenRoadmap,
    required this.onOpenReview,
    required this.onOpenPractice,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final next = state.nextLesson;
        final today = DateTime.now();
        final dayIndex = today.difference(DateTime(today.year, 1, 1)).inDays;
        final phrase = dramaPhrases[dayIndex % dramaPhrases.length];
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.indigo],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '한',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sinau Korea',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'KOREAN · TOPIK 1–6',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Pengaturan',
                      visualDensity: VisualDensity.compact,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SettingsScreen(state: state),
                        ),
                      ),
                      icon: Icon(
                        Icons.settings_rounded,
                        size: 20,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Row(
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 13)),
                          const SizedBox(width: 5),
                          Text(
                            '${state.streak}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'hari',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const UpdateBanner(),
                const SizedBox(height: 22),
                if (next != null)
                  GestureDetector(
                    onTap: () {
                      Haptics.selection();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              LessonScreen(lesson: next, state: state),
                        ),
                      );
                    },
                    child: GradientPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Text(
                                  'LANJUT BELAJAR',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.7,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              LevelChip(next.level, compact: true),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            next.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: AppColors.onHero),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            next.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFFD7DFFF),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: ProgressLine(
                                  value: state.overallProgress,
                                  color: Colors.white,
                                  height: 6,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 19,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${(state.overallProgress * 100).round()}% roadmap selesai · ${state.lessonsDone}/${state.totalLessons} modul',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFC9D4FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: StatBox(
                        value: '${state.xp}',
                        label: 'XP total',
                        icon: Icons.bolt_rounded,
                        color: AppColors.amber,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatBox(
                        value: '${state.dueCount}',
                        label: 'kartu jatuh tempo',
                        icon: Icons.style_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: StatBox(
                        value: '${state.accuracy}%',
                        label: 'akurasi jawaban',
                        icon: Icons.track_changes_rounded,
                        color: AppColors.mint,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatBox(
                        value: '${state.lessonsDone}/${state.totalLessons}',
                        label: 'modul selesai',
                        icon: Icons.menu_book_rounded,
                        color: AppColors.cyan,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            size: 18,
                            color: AppColors.rose,
                          ),
                          const SizedBox(width: 7),
                          const Text(
                            'Target harian',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${state.dailyXp} / 50 XP',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.mint,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ProgressLine(
                        value: state.dailyGoalProgress,
                        color: state.dailyGoalDone
                            ? AppColors.mint
                            : AppColors.amber,
                        height: 7,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.dailyGoalDone
                            ? 'Target hari ini tercapai. Konsistensi > intensitas.'
                            : 'Selesaikan 1 kuis atau 10 kartu SRS untuk mencapainya.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                AppCard(
                  onTap: onOpenReview,
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.style_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Review SRS',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              state.dueCount == 0
                                  ? 'Semua kartu sudah dijadwalkan ulang.'
                                  : '${state.dueCount} kartu siap diulang dengan SM-2.',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.mint.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${state.dueCount}',
                          style: TextStyle(
                            color: AppColors.mint,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  'Jalur TOPIK',
                  subtitle: 'Dari Hangul sampai tingkat native.',
                  trailing: TextButton(
                    onPressed: onOpenRoadmap,
                    child: const Text('Lihat semua'),
                  ),
                ),
                SizedBox(
                  height: 76,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: roadmapLevels.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 9),
                    itemBuilder: (context, i) {
                      final level = roadmapLevels[i];
                      final lessons = koreanLessons
                          .where((l) => l.level == level.code)
                          .toList();
                      final done = lessons
                          .where((l) => state.completedLessons.contains(l.id))
                          .length;
                      return AppCard(
                        onTap: onOpenRoadmap,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LevelChip(level.code, compact: true),
                            const SizedBox(height: 7),
                            Text(
                              lessons.isEmpty
                                  ? level.exam
                                  : '$done/${lessons.length} modul',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const SectionHeader(
                  'Frasa hari ini',
                  subtitle: 'Kosakata dari drakor, langsung kepakai.',
                ),
                AppCard(
                  gradient: LinearGradient(
                    colors: [AppColors.panelStart, AppColors.panelEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const LevelChip('K-DRAMA'),
                          const Spacer(),
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 17,
                            color: AppColors.amber.withValues(alpha: 0.9),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        phrase.ko,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        phrase.roman,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        phrase.id,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        phrase.note,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  'Akses cepat',
                  trailing: TextButton(
                    onPressed: onOpenPractice,
                    child: const Text('Semua latihan'),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ToolTile(
                        title: 'Bank soal',
                        subtitle: 'TOPIK-style, auto nilai',
                        icon: Icons.quiz_rounded,
                        color: AppColors.amber,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => QuestionBankScreen(state: state),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ToolTile(
                        title: 'Dialog nyata',
                        subtitle: 'Kafe, klinik, interview',
                        icon: Icons.forum_rounded,
                        color: AppColors.cyan,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const DialogListScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ToolTile(
                        title: 'K-Drama pack',
                        subtitle: '18 frasa + roadmap 4 minggu',
                        icon: Icons.movie_rounded,
                        color: AppColors.rose,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DramaScreen(state: state),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ToolTile(
                        title: 'Ketik Hangul',
                        subtitle: 'Latin langsung jadi 한글',
                        icon: Icons.keyboard_rounded,
                        color: AppColors.mint,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const HangulToolScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Latihan offline · progres tersimpan di perangkat',
                    style: Theme.of(context).textTheme.bodySmall,
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
