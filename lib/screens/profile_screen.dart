import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../data/vocab_data.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'update_screen.dart';

class ProfileScreen extends StatefulWidget {
  final AppState state;
  const ProfileScreen({super.key, required this.state});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Future<PackageInfo> _version = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final level = state.nextLesson?.level ?? 'C2';
        final introduced = state.cards.length;
        final mature = state.cards.values.where((card) => card.isMature).length;
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                AppHeader(
                  title: 'Profil',
                  streak: state.streak,
                  showOffline: false,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                    children: [
                      _IdentityCard(state: state, level: level),
                      const SizedBox(height: 12),
                      _ProgressCard(
                        state: state,
                        introduced: introduced,
                        mature: mature,
                      ),
                      const SizedBox(height: 12),
                      _ConsistencyCard(state: state),
                      const SizedBox(height: 20),
                      Text(
                        'Preferensi belajar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 9),
                      AppCard(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SoftIcon(
                                  icon: Icons.timer_rounded,
                                  color: AppColors.primary,
                                  size: 38,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Target harian',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.text,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${AppState.dailyGoalXp} XP dari kuis, review, dan latihan',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${state.dailyXp}/${AppState.dailyGoalXp}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: state.dailyGoalDone
                                        ? AppColors.mint
                                        : AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Divider(color: AppColors.line, height: 1),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                SoftIcon(
                                  icon: Icons.vibration_rounded,
                                  color: AppColors.primary,
                                  size: 38,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Umpan balik haptik',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.text,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Getaran saat kuis dan rating kartu',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: state.hapticsEnabled,
                                  activeThumbColor: AppColors.primary,
                                  onChanged: state.setHapticsEnabled,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _ThemeSelector(state: state),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Offline & keamanan data',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 9),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SoftIcon(
                                  icon: Icons.verified_user_rounded,
                                  color: AppColors.mint,
                                  size: 38,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Penyimpanan lokal',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.text,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Riwayat kuis, XP, streak, dan $introduced kartu SRS tersimpan di penyimpanan internal aplikasi. Tidak ada akun atau server.',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Divider(color: AppColors.line, height: 1),
                            const SizedBox(height: 6),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.rose,
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 44),
                                alignment: Alignment.centerLeft,
                              ),
                              onPressed: () => _confirmReset(context),
                              icon: const Icon(
                                Icons.delete_forever_rounded,
                                size: 18,
                              ),
                              label: const Text(
                                'Reset semua progres belajar',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Tentang aplikasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 9),
                      AppCard(
                        child: FutureBuilder<PackageInfo>(
                          future: _version,
                          builder: (context, snapshot) {
                            final package = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SoftIcon(
                                      icon: Icons.system_update_rounded,
                                      color: AppColors.primary,
                                      size: 38,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Sinau Korea',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.text,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            package == null
                                                ? 'Versi terpasang ...'
                                                : 'Versi ${package.version} (${package.buildNumber})',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.check_circle_rounded,
                                      size: 18,
                                      color: AppColors.mint,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Pembaruan APK diverifikasi ukuran dan SHA-256 sebelum installer Android dibuka.',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const UpdateScreen(),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.security_update_good_rounded,
                                      size: 18,
                                    ),
                                    label: const Text('Periksa pembaruan'),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: Text(
                          'Dibuat untuk belajar Korea dengan tenang, offline.',
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

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset semua progres?'),
        content: const Text(
          'Modul selesai, riwayat kuis, kartu SRS, XP, dan streak akan dihapus. Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.rose),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hapus permanen'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await widget.state.resetProgress();
    if (!mounted || !context.mounted) return;
    showSnack(context, 'Progres belajar berhasil direset.');
  }
}

class _IdentityCard extends StatelessWidget {
  final AppState state;
  final String level;
  const _IdentityCard({required this.state, required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.heroStart, AppColors.heroEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 62,
                height: 62,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                child: const Text(
                  '한',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Flexible(
                          child: Text(
                            'Pembelajar Mandiri',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            level,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Belajar offline · TOPIK $level',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.78),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department_rounded,
                          size: 15,
                          color: const Color(0xFFFFC45C),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${state.streak} hari streak',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.cloud_done_rounded,
                          size: 14,
                          color: Colors.white.withValues(alpha: 0.72),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Offline',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.72),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _HeroStat(value: '${state.xp}', label: 'Total XP'),
                _divider(),
                _HeroStat(
                  value: '${state.lessonsDone}',
                  label: 'Modul selesai',
                ),
                _divider(),
                _HeroStat(value: '${state.accuracy}%', label: 'Akurasi kuis'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 30,
    color: Colors.white.withValues(alpha: 0.18),
  );
}

class _HeroStat extends StatelessWidget {
  final String value;
  final String label;
  const _HeroStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final AppState state;
  final int introduced;
  final int mature;
  const _ProgressCard({
    required this.state,
    required this.introduced,
    required this.mature,
  });

  @override
  Widget build(BuildContext context) {
    final totalVocab = koreanVocab.length;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Ringkasan progres',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'REAL DATA',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: AppColors.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          _ProgressRow(
            label: 'Modul selesai',
            value: '${state.lessonsDone}/${state.totalLessons}',
            progress: state.overallProgress,
            color: AppColors.primary,
            icon: Icons.menu_book_rounded,
          ),
          const SizedBox(height: 12),
          _ProgressRow(
            label: 'Kosakata diperkenalkan',
            value: '$introduced/$totalVocab',
            progress: totalVocab == 0 ? 0 : introduced / totalVocab,
            color: AppColors.mint,
            icon: Icons.translate_rounded,
          ),
          const SizedBox(height: 12),
          _ProgressRow(
            label: 'Kartu SRS matang',
            value: '$mature/$introduced',
            progress: introduced == 0 ? 0 : mature / introduced,
            color: AppColors.amber,
            icon: Icons.verified_rounded,
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final Color color;
  final IconData icon;
  const _ProgressRow({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ProgressLine(
          value: progress.clamp(0, 1).toDouble(),
          color: color,
          height: 6,
        ),
      ],
    );
  }
}

class _ConsistencyCard extends StatelessWidget {
  final AppState state;
  const _ConsistencyCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final activeDays = <String>{};
    final last = DateTime.tryParse(state.lastStudyDay ?? '');
    if (last != null && state.streak > 0) {
      for (var i = 0; i < math.min(state.streak, 28); i++) {
        final day = last.subtract(Duration(days: i));
        activeDays.add(_key(day));
      }
    }
    final today = DateTime.now();
    final start = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(const Duration(days: 27));
    return AppCard(
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
              Text(
                'Konsistensi 28 hari',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const Spacer(),
              Text(
                '${state.streak} hari',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: state.streak > 0 ? AppColors.amber : AppColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            state.streak == 0
                ? 'Belum ada streak. Satu sesi hari ini sudah cukup untuk memulai.'
                : 'Streak aktif. Hari ini ikut dihitung setelah kamu belajar.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            children: [
              for (var i = 0; i < 28; i++)
                _HeatCell(
                  date: start.add(Duration(days: i)),
                  active: activeDays.contains(
                    _key(start.add(Duration(days: i))),
                  ),
                  today: _key(start.add(Duration(days: i))) == _key(today),
                ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mulai',
                style: TextStyle(fontSize: 9, color: AppColors.muted),
              ),
              Row(
                children: [
                  _legend(AppColors.surfaceHigh, 'Kosong'),
                  const SizedBox(width: 8),
                  _legend(AppColors.primary, 'Aktif'),
                  const SizedBox(width: 8),
                  _legend(AppColors.mint, 'Hari ini'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 3),
        Text(label, style: TextStyle(fontSize: 8, color: AppColors.muted)),
      ],
    );
  }

  String _key(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

class _HeatCell extends StatelessWidget {
  final DateTime date;
  final bool active;
  final bool today;
  const _HeatCell({
    required this.date,
    required this.active,
    required this.today,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message:
          '${date.day}/${date.month} · ${active ? 'ada sesi belajar' : 'tidak ada sesi'}',
      child: Container(
        decoration: BoxDecoration(
          color: today
              ? AppColors.mint
              : active
              ? AppColors.primary
              : AppColors.surfaceHigh,
          borderRadius: BorderRadius.circular(4),
          border: today
              ? Border.all(
                  color: AppColors.mint.withValues(alpha: 0.4),
                  width: 2,
                )
              : null,
        ),
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final AppState state;
  const _ThemeSelector({required this.state});

  @override
  Widget build(BuildContext context) {
    const modes = [
      (ThemeMode.system, 'Sistem', Icons.brightness_auto_rounded),
      (ThemeMode.light, 'Terang', Icons.light_mode_rounded),
      (ThemeMode.dark, 'Gelap', Icons.dark_mode_rounded),
    ];
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          for (final mode in modes)
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => state.setThemeMode(mode.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: state.themeMode == mode.$1
                        ? AppColors.surface
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: state.themeMode == mode.$1
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        mode.$3,
                        size: 13,
                        color: state.themeMode == mode.$1
                            ? AppColors.primary
                            : AppColors.muted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        mode.$2,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: state.themeMode == mode.$1
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: state.themeMode == mode.$1
                              ? AppColors.primary
                              : AppColors.muted,
                        ),
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
