import 'package:flutter/material.dart';

import '../data/vocab_data.dart';
import '../services/app_state.dart';
import '../services/haptics.dart';
import '../services/quiz_factory.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'quiz_screen.dart';

class QuestionBankScreen extends StatefulWidget {
  final AppState state;
  const QuestionBankScreen({super.key, required this.state});

  @override
  State<QuestionBankScreen> createState() => _QuestionBankScreenState();
}

class _QuestionBankScreenState extends State<QuestionBankScreen> {
  String selected = 'Semua';
  static const levels = ['Semua', 'A0', 'A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

  Future<void> _start() async {
    final questions = buildQuestionBank(
      level: selected == 'Semua' ? null : selected,
      count: 10,
    );
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          title: 'Bank soal',
          subtitle: selected == 'Semua' ? 'Campuran' : selected,
          questions: questions,
          state: widget.state,
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pool = selected == 'Semua'
        ? koreanVocab
        : koreanVocab.where((v) => v.level == selected).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Bank Soal')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          GradientPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SOAL & QUIZ',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD7DFFF),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '10 soal per set',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: AppColors.onHero),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tiga tipe soal: arti kosakata, romanisasi → Hangul, dan arti → Hangul. Langsung dinilai dengan penjelasan.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFD7DFFF),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const SectionHeader('Filter level'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final level in levels)
                ChoiceChip(
                  label: Text(level),
                  selected: selected == level,
                  onSelected: (_) {
                    Haptics.selection();
                    setState(() => selected = level);
                  },
                ),
            ],
          ),
          const SizedBox(height: 20),
          AppCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kosakata tersedia',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${pool.length} kata',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Akurasi sejauh ini',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${widget.state.accuracy}%',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.mint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total jawaban',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${widget.state.totalAnswered}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _start,
            icon: Icon(Icons.play_arrow_rounded),
            label: const Text('Mulai 10 soal'),
          ),
          const SizedBox(height: 12),
          Text(
            'Tips: jawab tanpa melihat catatan. Kesalahan justru membuat jadwal review SRS lebih cepat muncul.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
