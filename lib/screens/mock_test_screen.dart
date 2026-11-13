import 'package:flutter/material.dart';

import '../services/app_state.dart';
import '../services/quiz_factory.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'quiz_screen.dart';

class MockTestScreen extends StatefulWidget {
  final AppState state;
  const MockTestScreen({super.key, required this.state});

  @override
  State<MockTestScreen> createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen> {
  bool starting = false;

  Future<void> _start() async {
    setState(() => starting = true);
    final questions = buildMockTest(count: 20);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          title: 'Latihan Kilat Kosakata',
          subtitle: '20 menit',
          questions: questions,
          state: widget.state,
          timeLimitSeconds: 20 * 60,
          onFinished: (result) =>
              widget.state.recordMockScore(result.correct, result.total),
        ),
      ),
    );
    if (mounted) setState(() => starting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Latihan Kilat Kosakata')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          GradientPanel(
            colors: const [Color(0xFF3B2B54), Color(0xFF1A1730)],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LATIHAN KILAT · 20 SOAL',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: AppColors.onHeroMuted,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '20 soal.\n20 menit.',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: AppColors.onHero),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Uji ingatan kosakata A0–C2 dengan timer. Ini latihan cepat, bukan simulasi struktur ujian TOPIK.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.onHeroMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: StatBox(
                  value: '20',
                  label: 'soal',
                  icon: Icons.quiz_rounded,
                  color: AppColors.amber,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatBox(
                  value: '20:00',
                  label: 'timer',
                  icon: Icons.timer_rounded,
                  color: AppColors.rose,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatBox(
                  value: '${widget.state.mockBest}%',
                  label: 'skor terbaik',
                  icon: Icons.emoji_events_rounded,
                  color: AppColors.mint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SectionHeader('Aturan simulasi'),
          AppCard(
            child: Column(
              children: const [
                _Rule(
                  icon: Icons.lock_clock_rounded,
                  text: 'Timer berjalan otomatis. Soal yang belum dijawab saat waktu habis dihitung salah.',
                ),
                SizedBox(height: 14),
                _Rule(
                  icon: Icons.visibility_off_rounded,
                  text: 'Penjelasan baru muncul setelah kamu memilih jawaban.',
                ),
                SizedBox(height: 14),
                _Rule(
                  icon: Icons.workspace_premium_rounded,
                  text:
                      'Skor terbaik disimpan di perangkat. XP hanya diberikan saat skor terbaikmu meningkat.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: starting ? null : _start,
            icon: Icon(Icons.play_arrow_rounded),
            label: const Text('Mulai latihan'),
          ),
          const SizedBox(height: 10),
          Text(
            'Untuk persiapan TOPIK yang sebenarnya, tunggu modul TOPIK I/II terpisah.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Rule({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
