import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/drama_data.dart';
import '../models.dart';
import '../services/app_state.dart';
import '../services/haptics.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/update_banner.dart';
import 'dialog_screens.dart';
import 'drama_screen.dart';
import 'lesson_screen.dart';
import 'mock_test_screen.dart';
import 'question_bank_screen.dart';
import 'reading_screens.dart';

class HomeScreen extends StatelessWidget {
  final AppState state;
  final VoidCallback onOpenReview;
  final VoidCallback onOpenPractice;
  final VoidCallback onOpenProfile;
  const HomeScreen({
    super.key,
    required this.state,
    required this.onOpenReview,
    required this.onOpenPractice,
    required this.onOpenProfile,
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
            bottom: false,
            child: Column(
              children: [
                AppHeader(
                  title: 'Hari Ini',
                  streak: state.streak,
                  onProfile: onOpenProfile,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                    children: [
                      const UpdateBanner(),
                      _Greeting(state: state),
                      const SizedBox(height: 14),
                      _DailyGoalCard(state: state),
                      const SizedBox(height: 14),
                      if (next != null)
                        _HeroLessonCard(
                          state: state,
                          onTap: () {
                            Haptics.selection();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    LessonScreen(lesson: next, state: state),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 14),
                      _DueReviewCard(state: state, onOpenReview: onOpenReview),
                      const SizedBox(height: 14),
                      _DramaPhraseCard(
                        phrase: phrase,
                        onOpen: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DramaScreen(state: state),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      SectionHeader(
                        'Latihan cepat',
                        subtitle: 'Semua alat belajar tetap tersedia offline.',
                        trailing: TextButton(
                          onPressed: onOpenPractice,
                          child: const Text('Semua'),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _QuickTool(
                              icon: Icons.quiz_rounded,
                              color: AppColors.amber,
                              title: 'Bank soal',
                              subtitle: 'Auto nilai',
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      QuestionBankScreen(state: state),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _QuickTool(
                              icon: Icons.forum_rounded,
                              color: AppColors.cyan,
                              title: 'Dialog',
                              subtitle: 'Situasi nyata',
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
                            child: _QuickTool(
                              icon: Icons.article_rounded,
                              color: AppColors.mint,
                              title: 'Bacaan',
                              subtitle: 'Teks bertingkat',
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ReadingListScreen(state: state),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _QuickTool(
                              icon: Icons.timer_rounded,
                              color: AppColors.rose,
                              title: 'Latihan kilat',
                              subtitle: '20 soal',
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => MockTestScreen(state: state),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Mode offline · progres tersimpan di perangkat',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
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

class _Greeting extends StatelessWidget {
  final AppState state;
  const _Greeting({required this.state});

  @override
  Widget build(BuildContext context) {
    final level = state.nextLesson?.level ?? 'A1';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, pembelajar! 👋',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Siap melanjutkan ritme belajarmu hari ini?',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_rounded, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                '$level Dasar',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DailyGoalCard extends StatelessWidget {
  final AppState state;
  const _DailyGoalCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final progress = state.dailyGoalProgress;
    final remaining = math.max(0, AppState.dailyGoalXp - state.dailyXp);
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      size: 18,
                      color: AppColors.amber,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        state.streak == 0
                            ? 'Mulai streak hari ini'
                            : '${state.streak} hari berturut-turut',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${state.dailyXp} / ${AppState.dailyGoalXp} XP harian',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  state.dailyGoalDone
                      ? 'Target hari ini tercapai. Konsistensi > intensitas.'
                      : 'Tinggal $remaining XP lagi untuk mencapai target.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: state.dailyGoalDone
                        ? AppColors.mint
                        : AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 66,
            height: 66,
            child: CustomPaint(
              painter: _GoalRingPainter(
                value: progress,
                color: state.dailyGoalDone ? AppColors.mint : AppColors.primary,
              ),
              child: Center(
                child: Text(
                  '${(progress * 100).round()}%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: state.dailyGoalDone
                        ? AppColors.mint
                        : AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalRingPainter extends CustomPainter {
  final double value;
  final Color color;
  _GoalRingPainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 10) / 2;
    final background = Paint()
      ..color = AppColors.track
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    final foreground = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;
    canvas.drawCircle(center, radius, background);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * value.clamp(0, 1),
      false,
      foreground,
    );
  }

  @override
  bool shouldRepaint(covariant _GoalRingPainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.color != color;
}

class _HeroLessonCard extends StatelessWidget {
  final AppState state;
  final VoidCallback onTap;
  const _HeroLessonCard({required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final next = state.nextLesson!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.heroStart, AppColors.heroEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.22),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              right: -36,
              bottom: -42,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'MODUL ${next.id.toUpperCase()} · ${next.level}',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'FOKUS HARI INI',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7,
                          color: AppColors.onHeroMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    next.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: -0.3,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    next.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Colors.white.withValues(alpha: 0.82),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: state.overallProgress.clamp(0, 1),
                            minHeight: 6,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.22,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF81F9C8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${(state.overallProgress * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lanjutkan modul',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 17,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DueReviewCard extends StatelessWidget {
  final AppState state;
  final VoidCallback onOpenReview;
  const _DueReviewCard({required this.state, required this.onOpenReview});

  @override
  Widget build(BuildContext context) {
    final due = state.dueVocab.take(3).toList();
    final count = state.dueCount;
    final minutes = math.max(1, (count * 0.5).ceil());
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SoftIcon(
                icon: count == 0
                    ? Icons.nights_stay_rounded
                    : Icons.schedule_rounded,
                color: count == 0 ? AppColors.mint : AppColors.rose,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      count == 0
                          ? 'Tidak ada kartu jatuh tempo'
                          : '$count kosakata jatuh tempo',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      count == 0
                          ? 'Semua kartu sudah dijadwalkan ulang.'
                          : '±$minutes menit review santai',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: count == 0
                      ? AppColors.secondaryContainer.withValues(alpha: 0.5)
                      : AppColors.errorContainer.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  count == 0 ? 'Beres' : 'Hari ini',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: count == 0
                        ? AppColors.onSecondaryContainer
                        : AppColors.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
          if (due.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final vocab in due)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          vocab.hangul,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '(${vocab.meaning.split(' / ').first})',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (count > due.length)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      '+${count - due.length} lainnya',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.mint,
                foregroundColor: Colors.white,
              ),
              onPressed: onOpenReview,
              icon: Icon(
                count == 0
                    ? Icons.shuffle_rounded
                    : Icons.play_circle_fill_rounded,
                size: 18,
              ),
              label: Text(
                count == 0 ? 'Mulai sesi acak' : 'Mulai review kilat',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DramaPhraseCard extends StatelessWidget {
  final DramaPhrase phrase;
  final VoidCallback onOpen;
  const _DramaPhraseCard({required this.phrase, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.surfaceLow, AppColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.movie_filter_rounded,
                size: 18,
                color: AppColors.amber,
              ),
              const SizedBox(width: 6),
              Text(
                'LATIHAN FRASA K-DRAMA',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: AppColors.tertiary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '2 MENIT',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onTertiaryFixed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      phrase.ko,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        letterSpacing: -0.3,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      phrase.roman,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              SoftIcon(
                icon: Icons.theater_comedy_rounded,
                color: AppColors.amber,
                size: 46,
                radius: 14,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            phrase.id,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 5),
          Text(phrase.note, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onOpen,
              icon: const Icon(Icons.play_arrow_rounded, size: 18),
              label: const Text('Buka K-Drama pack'),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickTool extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _QuickTool({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(13),
      child: Row(
        children: [
          SoftIcon(icon: icon, color: color, size: 38, radius: 11),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
