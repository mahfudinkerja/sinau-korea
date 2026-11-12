import 'package:flutter/material.dart';

import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'dialog_screens.dart';
import 'drama_screen.dart';
import 'grammar_screen.dart';
import 'hangul_tool_screen.dart';
import 'mock_test_screen.dart';
import 'question_bank_screen.dart';
import 'reading_screens.dart';

class PracticeScreen extends StatelessWidget {
  final AppState state;
  const PracticeScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    void open(Widget screen) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    }

    final tools = [
      _Tool(
        'Bank Soal',
        '20.000+ gaya soal · auto nilai',
        Icons.quiz_rounded,
        AppColors.amber,
        () => open(QuestionBankScreen(state: state)),
      ),
      _Tool(
        'Dialog',
        '8 skrip situasi nyata + role-play',
        Icons.forum_rounded,
        AppColors.cyan,
        () => open(const DialogListScreen()),
      ),
      _Tool(
        'Bacaan',
        'Teks bertingkat + terjemahan',
        Icons.article_rounded,
        AppColors.primary,
        () => open(ReadingListScreen(state: state)),
      ),
      _Tool(
        'Tata Bahasa',
        '20 pola, rumus, dan jebakan',
        Icons.account_tree_rounded,
        AppColors.mint,
        () => open(const GrammarScreen()),
      ),
      _Tool(
        'Simulasi TOPIK',
        '20 soal · 20 menit · skor',
        Icons.timer_rounded,
        AppColors.rose,
        () => open(MockTestScreen(state: state)),
      ),
      _Tool(
        'K-Drama Pack',
        '18 frasa + roadmap 4 minggu',
        Icons.movie_rounded,
        AppColors.indigo,
        () => open(DramaScreen(state: state)),
      ),
      _Tool(
        'Ketik Hangul',
        'isseoyo → 있어요',
        Icons.keyboard_rounded,
        AppColors.cyan,
        () => open(const HangulToolScreen()),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Latihan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          GradientPanel(
            colors: const [Color(0xFF243462), Color(0xFF151D35)],
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '7 TOOLS INTI',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Latihan yang langsung dinilai.',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Setiap jawaban masuk ke statistik dan XP harianmu.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.muted,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${state.accuracy}%',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const Text(
                        'akurasi',
                        style: TextStyle(
                          fontSize: 9,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(
            'Pilih latihan',
            subtitle: 'Semua tersedia offline, tanpa login.',
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.02,
            children: [
              for (final tool in tools)
                ToolTile(
                  title: tool.title,
                  subtitle: tool.subtitle,
                  icon: tool.icon,
                  color: tool.color,
                  onTap: tool.onTap,
                ),
            ],
          ),
          const SizedBox(height: 20),
          AppCard(
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: AppColors.muted,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Bank soal, mock test, dan kuis modul memakai kosakata yang sama dengan dek SRS. Latihan di sini otomatis memperkuat review-mu.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tool {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _Tool(this.title, this.subtitle, this.icon, this.color, this.onTap);
}
