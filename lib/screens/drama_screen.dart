import 'package:flutter/material.dart';

import '../data/drama_data.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class DramaScreen extends StatelessWidget {
  final AppState state;
  const DramaScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('K-Drama Pack')),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          final done = dramaPhrases
              .where((p) => state.dramaChecked.contains(p.ko))
              .length;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              GradientPanel(
                colors: const [Color(0xFF3D2030), Color(0xFF1A1420)],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('🇰🇷', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        const Text(
                          'K-DRAMA LEARNING METHOD',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.7,
                            color: AppColors.onHeroMuted,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$done/${dramaPhrases.length}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onHero,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '18 frasa yang\nsering muncul.',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(color: AppColors.onHero),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Centang frasa yang sudah kamu kenali dari drama. Ulangi lewat SRS agar nempel dalam konteks.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.onHeroMuted,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ProgressLine(
                      value: dramaPhrases.isEmpty
                          ? 0
                          : done / dramaPhrases.length,
                      color: const Color(0xFFFF8FA3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const SectionHeader(
                'Roadmap 4 minggu',
                subtitle: 'Nonton dengan tujuan, bukan sekadar binge.',
              ),
              for (var i = 0; i < dramaRoadmap.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: AppCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: AppColors.rose.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.rose,
                            ),
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Text(
                            dramaRoadmap[i],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 18),
              const SectionHeader('Checklist frasa'),
              for (final phrase in dramaPhrases)
                Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: AppCard(
                    onTap: () => state.toggleDrama(phrase.ko),
                    color: state.dramaChecked.contains(phrase.ko)
                        ? AppColors.rose.withValues(alpha: 0.06)
                        : null,
                    border: Border.all(
                      color: state.dramaChecked.contains(phrase.ko)
                          ? AppColors.rose.withValues(alpha: 0.25)
                          : AppColors.line,
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          state.dramaChecked.contains(phrase.ko)
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          size: 21,
                          color: state.dramaChecked.contains(phrase.ko)
                              ? AppColors.rose
                              : AppColors.muted,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Flexible(
                                    child: Text(
                                      phrase.ko,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    phrase.roman,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                phrase.id,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mint,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                phrase.note,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
