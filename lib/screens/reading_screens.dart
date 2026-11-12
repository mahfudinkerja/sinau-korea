import 'package:flutter/material.dart';

import '../data/reading_data.dart';
import '../models.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'quiz_screen.dart';

class ReadingListScreen extends StatelessWidget {
  final AppState state;
  const ReadingListScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bacaan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const SectionHeader(
            'Bacaan terkurasi',
            subtitle: 'Teks pendek per level, terjemahan per kalimat.',
          ),
          for (final reading in koreanReadings)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ReadingScreen(reading: reading, state: state),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        LevelChip(reading.level),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            reading.topic,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.muted,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      reading.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${reading.sentences.length} kalimat · ${reading.questions.length} soal pemahaman',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ReadingScreen extends StatefulWidget {
  final ReadingPassage reading;
  final AppState state;
  const ReadingScreen({super.key, required this.reading, required this.state});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  bool showTranslation = true;

  @override
  Widget build(BuildContext context) {
    final reading = widget.reading;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bacaan'),
        actions: [
          IconButton(
            tooltip: showTranslation ? 'Sembunyikan terjemahan' : 'Tampilkan terjemahan',
            onPressed: () => setState(() => showTranslation = !showTranslation),
            icon: Icon(
              showTranslation
                  ? Icons.translate_rounded
                  : Icons.translate_rounded,
              color: showTranslation ? AppColors.primary : AppColors.muted,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Row(
            children: [
              LevelChip(reading.level),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  reading.topic,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            reading.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 18),
          for (final sentence in reading.sentences)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sentence.ko,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        height: 1.6,
                      ),
                    ),
                    if (showTranslation) ...[
                      const SizedBox(height: 7),
                      Text(
                        sentence.id,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => setState(() => showTranslation = !showTranslation),
            icon: Icon(Icons.translate_rounded, size: 18),
            label: Text(
              showTranslation ? 'Sembunyikan terjemahan' : 'Tampilkan terjemahan',
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => QuizScreen(
                    title: 'Pemahaman bacaan',
                    subtitle: reading.level,
                    questions: reading.questions,
                    state: widget.state,
                  ),
                ),
              );
            },
            icon: Icon(Icons.quiz_rounded, size: 19),
            label: Text('Cek pemahaman · ${reading.questions.length} soal'),
          ),
          const SizedBox(height: 10),
          Text(
            'Baca ulang tanpa terjemahan setelah kuis untuk mengukur pemahaman asli.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
