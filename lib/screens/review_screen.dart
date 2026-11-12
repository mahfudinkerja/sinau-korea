import 'package:flutter/material.dart';

import '../models.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class ReviewScreen extends StatefulWidget {
  final AppState state;
  const ReviewScreen({super.key, required this.state});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<Vocab> session = [];
  int index = 0;
  bool revealed = false;
  bool finished = false;
  int reviewed = 0;

  @override
  void initState() {
    super.initState();
    _startDue();
  }

  void _startDue() {
    setState(() {
      session = widget.state.dueVocab.take(20).toList();
      index = 0;
      revealed = false;
      finished = false;
      reviewed = 0;
    });
  }

  void _startRandom() {
    setState(() {
      session = widget.state.randomDeck;
      index = 0;
      revealed = false;
      finished = false;
      reviewed = 0;
    });
  }

  void _rate(SrsRating rating) {
    widget.state.rateCard(session[index], rating);
    setState(() {
      reviewed++;
      revealed = false;
      if (index >= session.length - 1) {
        finished = true;
      } else {
        index++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review SRS'),
        actions: [
          IconButton(
            onPressed: _startDue,
            tooltip: 'Muat ulang kartu jatuh tempo',
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: session.isEmpty
          ? EmptyState(
              icon: Icons.nights_stay_rounded,
              title: 'Tidak ada kartu jatuh tempo',
              message:
                  'Semua kartu sudah dijadwalkan ulang. Kamu tetap bisa memulai sesi acak untuk latihan tambahan.',
              action: Column(
                children: [
                  FilledButton(
                    onPressed: _startRandom,
                    child: const Text('Mulai sesi acak · 10 kartu'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${widget.state.cards.length} kartu di dek · ${widget.state.dueCount} jatuh tempo',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            )
          : finished
              ? _summary(context)
              : _cardView(context),
    );
  }

  Widget _cardView(BuildContext context) {
    final vocab = session[index];
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Row(
          children: [
            Text(
              'Kartu ${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            Text(
              ' / ${session.length}',
              style: const TextStyle(color: AppColors.muted),
            ),
            const Spacer(),
            Text(
              '${widget.state.dueCount} jatuh tempo',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 10),
        ProgressLine(
          value: index / session.length,
          color: AppColors.primary,
          height: 6,
        ),
        const SizedBox(height: 22),
        GestureDetector(
          onTap: () => setState(() => revealed = true),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(minHeight: 300),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B2740), Color(0xFF111823)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: revealed
                    ? AppColors.primary.withValues(alpha: 0.35)
                    : AppColors.line,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    LevelChip(vocab.level),
                    const Spacer(),
                    Text(
                      revealed ? 'SM-2 · ${widget.state.cards[vocab.roman]?.reps ?? 0} reps' : 'FLASHCARD',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 42),
                Center(
                  child: Text(
                    vocab.hangul,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (!revealed)
                  const Center(
                    child: Text(
                      'Ketuk kartu untuk melihat arti',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                if (revealed) ...[
                  Center(
                    child: Text(
                      vocab.roman,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Divider(),
                  const SizedBox(height: 14),
                  Text(
                    vocab.meaning,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.mint,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    vocab.example,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vocab.exampleId,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (!revealed)
          FilledButton.icon(
            onPressed: () => setState(() => revealed = true),
            icon: const Icon(Icons.visibility_rounded, size: 19),
            label: const Text('Tampilkan arti'),
          )
        else ...[
          Text(
            'Seberapa sulit kartu ini?',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _ratingButton('Lagi', '10 mnt', AppColors.rose, SrsRating.again),
              const SizedBox(width: 8),
              _ratingButton('Sulit', '1+ hari', AppColors.amber, SrsRating.hard),
              const SizedBox(width: 8),
              _ratingButton('Bagus', '3 hari', AppColors.primary, SrsRating.good),
              const SizedBox(width: 8),
              _ratingButton('Mudah', '4+ hari', AppColors.mint, SrsRating.easy),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Interval mengikuti jawabanmu. Kartu sulit akan muncul lebih sering.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  Widget _ratingButton(
    String label,
    String hint,
    Color color,
    SrsRating rating,
  ) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _rate(rating),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  hint,
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summary(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 30),
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.mint.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.mint,
              size: 46,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            'Sesi review selesai',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            '$reviewed kartu telah dijadwalkan ulang oleh algoritma SM-2.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 24),
        AppCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _sumStat('$reviewed', 'kartu'),
              _sumStat('+${reviewed * 2}', 'XP'),
              _sumStat('${widget.state.dueCount}', 'tersisa'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: widget.state.dueCount > 0 ? _startDue : _startRandom,
          child: Text(
            widget.state.dueCount > 0
                ? 'Lanjut sesi berikutnya'
                : 'Sesi acak tambahan',
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: const Text('Kembali'),
        ),
      ],
    );
  }

  Widget _sumStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
      ],
    );
  }
}
