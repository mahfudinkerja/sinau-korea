import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/vocab_data.dart';
import '../models.dart';
import '../services/app_state.dart';
import '../services/haptics.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'hangul_tool_screen.dart';

class ReviewScreen extends StatefulWidget {
  final AppState state;
  final VoidCallback? onProfile;
  const ReviewScreen({super.key, required this.state, this.onProfile});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<Vocab> session = [];
  int index = 0;
  bool revealed = false;
  bool finished = false;
  bool started = false;
  int reviewed = 0;

  void _startDue() {
    final due = widget.state.dueVocab.take(20).toList();
    if (due.isEmpty) return;
    _begin(due);
  }

  void _startRandom() {
    _begin(widget.state.randomDeck);
  }

  void _startMistakes() {
    final mistakes = widget.state.mistakeVocab.take(20).toList();
    if (mistakes.isEmpty) return;
    _begin(mistakes);
  }

  void _begin(List<Vocab> deck) {
    Haptics.selection();
    setState(() {
      session = deck;
      index = 0;
      revealed = false;
      finished = false;
      started = true;
      reviewed = 0;
    });
  }

  void _backToDashboard() {
    setState(() {
      started = false;
      session = [];
      index = 0;
      revealed = false;
      finished = false;
    });
  }

  void _rate(BuildContext context, SrsRating rating) {
    if (rating == SrsRating.again) {
      Haptics.medium();
    } else {
      Haptics.light();
    }
    final vocab = session[index];
    final ratedIndex = index;
    final undo = widget.state.rateCard(vocab, rating);
    setState(() {
      reviewed++;
      revealed = false;
      if (index >= session.length - 1) {
        finished = true;
      } else {
        index++;
      }
    });
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('${vocab.hangul} dijadwalkan ulang.'),
        action: SnackBarAction(
          label: 'Urungkan',
          onPressed: () {
            widget.state.undoRating(vocab, undo);
            if (!mounted) return;
            setState(() {
              index = ratedIndex;
              reviewed = reviewed > 0 ? reviewed - 1 : 0;
              revealed = true;
              finished = false;
            });
          },
        ),
      ),
    );
  }

  void _ratePreview(BuildContext context, Vocab vocab, SrsRating rating) {
    Haptics.selection();
    final undo = widget.state.rateCard(vocab, rating);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('${vocab.hangul} dijadwalkan ulang.'),
        action: SnackBarAction(
          label: 'Urungkan',
          onPressed: () {
            widget.state.undoRating(vocab, undo);
            if (mounted) setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                AppHeader(
                  title: 'Review',
                  streak: widget.state.streak,
                  onProfile: widget.onProfile,
                ),
                Expanded(
                  child: started
                      ? (finished ? _summary(context) : _sessionView(context))
                      : _dashboard(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dashboard(BuildContext context) {
    final cards = widget.state.cards.values.toList();
    final mature = cards.where((card) => card.isMature).length;
    final newCount = cards.where((card) => card.isNew).length;
    final learning = math.max(0, cards.length - mature - newCount);
    final due = widget.state.dueVocab;
    final preview = due.isNotEmpty
        ? due.first
        : (widget.state.mistakeVocab.isNotEmpty
              ? widget.state.mistakeVocab.first
              : (koreanVocab.isEmpty ? null : koreanVocab.first));
    final forecast = _forecast(widget.state);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SoftIcon(
                    icon: Icons.layers_rounded,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STATUS DEK UTAMA',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${cards.length} kartu diperkenalkan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLow,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${widget.state.dueCount} jatuh tempo',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: widget.state.dueCount > 0
                            ? AppColors.rose
                            : AppColors.mint,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _DeckStat(
                      label: 'Baru',
                      value: '$newCount',
                      icon: Icons.arrow_back_ios_new_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _DeckStat(
                      label: 'Belajar',
                      value: '$learning',
                      icon: Icons.hourglass_top_rounded,
                      color: AppColors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _DeckStat(
                      label: 'Matang',
                      value: '$mature',
                      icon: Icons.verified_rounded,
                      color: AppColors.mint,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _DeckStat(
                      label: 'Jatuh tempo',
                      value: '${widget.state.dueCount}',
                      icon: Icons.notification_important_rounded,
                      color: AppColors.rose,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _ForecastCard(forecast: forecast),
        const SizedBox(height: 12),
        if (preview != null)
          _PreviewCard(
            vocab: preview,
            due: due.isNotEmpty,
            onRate: (rating) => _ratePreview(context, preview, rating),
          ),
        const SizedBox(height: 20),
        Text(
          'Latihan terarah',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 9),
        _PracticeTile(
          icon: Icons.troubleshoot_rounded,
          color: AppColors.rose,
          title: 'Bank kosakata sering salah',
          subtitle:
              '${widget.state.mistakeVocab.length} kartu ditandai butuh pengulangan',
          onTap: widget.state.mistakeVocab.isEmpty ? null : _startMistakes,
        ),
        const SizedBox(height: 8),
        _PracticeTile(
          icon: Icons.bolt_rounded,
          color: AppColors.primary,
          title: 'Sesi kilat acak',
          subtitle: '10 kartu · tanpa memengaruhi interval SRS',
          onTap: _startRandom,
        ),
        const SizedBox(height: 8),
        _PracticeTile(
          icon: Icons.keyboard_rounded,
          color: AppColors.mint,
          title: 'Ketik & konversi Hangul',
          subtitle: 'Latin langsung menjadi 한글',
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const HangulToolScreen())),
        ),
        const SizedBox(height: 16),
        _ReviewCta(
          dueCount: widget.state.dueCount,
          onStart: widget.state.dueCount > 0 ? _startDue : _startRandom,
        ),
      ],
    );
  }

  List<int> _forecast(AppState state) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final cards = state.cards.values.toList();
    return List.generate(7, (i) {
      if (i == 0) return state.dueCount;
      final day = today.add(Duration(days: i));
      return cards.where((card) => _sameDay(card.due, day)).length;
    });
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Widget _sessionView(BuildContext context) {
    final vocab = session[index];
    final card = widget.state.cards[vocab.roman];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
      children: [
        Row(
          children: [
            IconButton(
              onPressed: _backToDashboard,
              tooltip: 'Kembali ke ringkasan review',
              icon: const Icon(Icons.arrow_back_rounded, size: 20),
            ),
            Text(
              'Kartu ${index + 1}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            Text(
              ' / ${session.length}',
              style: TextStyle(fontSize: 12, color: AppColors.muted),
            ),
            const Spacer(),
            Text(
              '${widget.state.dueCount} tersisa',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        ProgressLine(
          value: index / math.max(1, session.length),
          color: AppColors.primary,
          height: 6,
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            Haptics.selection();
            setState(() => revealed = true);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(minHeight: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.surfaceLow, AppColors.surface],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: revealed
                    ? AppColors.primary.withValues(alpha: 0.4)
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
                      revealed
                          ? '${card?.stage ?? 'Baru'} · ${card?.reps ?? 0} reps'
                          : 'KETUK UNTUK MEMBUKA',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 38),
                Center(
                  child: Text(
                    vocab.hangul,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: -0.5,
                      color: AppColors.text,
                    ),
                  ),
                ),
                if (!revealed) ...[
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Ketuk kartu untuk melihat arti',
                      style: TextStyle(fontSize: 11, color: AppColors.muted),
                    ),
                  ),
                ],
                if (revealed) ...[
                  Center(
                    child: Text(
                      vocab.roman,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Divider(color: AppColors.line),
                  const SizedBox(height: 12),
                  Text(
                    vocab.meaning,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.mint,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vocab.example,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.text,
                    ),
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
        const SizedBox(height: 16),
        if (!revealed)
          FilledButton.icon(
            onPressed: () {
              Haptics.selection();
              setState(() => revealed = true);
            },
            icon: const Icon(Icons.visibility_rounded, size: 18),
            label: const Text('Tampilkan arti'),
          )
        else ...[
          Text(
            'Seberapa sulit kartu ini?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              _ratingButton(
                'Lagi',
                '< 10 mnt',
                AppColors.rose,
                SrsRating.again,
                context,
              ),
              const SizedBox(width: 7),
              _ratingButton(
                'Sulit',
                '1 hari',
                AppColors.amber,
                SrsRating.hard,
                context,
              ),
              const SizedBox(width: 7),
              _ratingButton(
                'Bagus',
                '3 hari',
                AppColors.primary,
                SrsRating.good,
                context,
              ),
              const SizedBox(width: 7),
              _ratingButton(
                'Mudah',
                '6 hari',
                AppColors.mint,
                SrsRating.easy,
                context,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Interval mengikuti jawabanmu. Kartu sulit muncul lebih sering.',
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
    BuildContext context,
  ) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _rate(context, rating),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.24)),
            ),
            child: Column(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  hint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 8, color: AppColors.muted),
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
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      children: [
        Center(
          child: Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: AppColors.mint.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_rounded, color: AppColors.mint, size: 44),
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: Text(
            'Sesi review selesai',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 7),
        Center(
          child: Text(
            '$reviewed kartu telah dijadwalkan ulang oleh SRS (SM-2 sederhana).',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 20),
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
        const SizedBox(height: 16),
        FilledButton(
          onPressed: widget.state.dueCount > 0 ? _startDue : _startRandom,
          child: Text(
            widget.state.dueCount > 0
                ? 'Lanjut sesi berikutnya'
                : 'Sesi acak tambahan',
          ),
        ),
        const SizedBox(height: 9),
        OutlinedButton(
          onPressed: _backToDashboard,
          child: const Text('Kembali ke ringkasan'),
        ),
      ],
    );
  }

  Widget _sumStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 3),
        Text(label, style: TextStyle(fontSize: 11, color: AppColors.muted)),
      ],
    );
  }
}

class _DeckStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _DeckStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: color),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color,
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

class _ForecastCard extends StatelessWidget {
  final List<int> forecast;
  const _ForecastCard({required this.forecast});

  @override
  Widget build(BuildContext context) {
    final maxValue = forecast.fold<int>(1, math.max);
    final labels = ['Hari ini', 'Besok', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final now = DateTime.now();
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'Prakiraan review 7 hari',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const Spacer(),
              Text(
                'Total ${forecast.fold<int>(0, (a, b) => a + b)}',
                style: TextStyle(fontSize: 10, color: AppColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 96,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < forecast.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i == 6 ? 0 : 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${forecast[i]}',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: i == 0
                                  ? AppColors.rose
                                  : AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: forecast[i] == 0
                                ? 4
                                : 8 + 48 * (forecast[i] / maxValue).clamp(0, 1),
                            decoration: BoxDecoration(
                              color: forecast[i] == 0
                                  ? AppColors.surfaceHigh
                                  : i == 0
                                  ? AppColors.rose.withValues(alpha: 0.35)
                                  : AppColors.primary.withValues(alpha: 0.75),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            i == 0
                                ? labels[0]
                                : i == 1
                                ? labels[1]
                                : _weekday(now.add(Duration(days: i))),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: i == 0
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _weekday(DateTime date) {
    const names = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return names[date.weekday - 1];
  }
}

class _PreviewCard extends StatelessWidget {
  final Vocab vocab;
  final bool due;
  final ValueChanged<SrsRating> onRate;
  const _PreviewCard({
    required this.vocab,
    required this.due,
    required this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Pratinjau sesi review',
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
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  due ? 'JATUH TEMPO' : 'LATIHAN',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: AppColors.onPrimaryFixed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLow,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'TOPIK ${vocab.level} · ${vocab.lessonId.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: AppColors.muted,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  vocab.hangul,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  vocab.roman,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vocab.meaning,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  vocab.example,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  vocab.exampleId,
                  style: TextStyle(fontSize: 10, color: AppColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _previewRating(
                'Lagi',
                '< 10 mnt',
                AppColors.rose,
                SrsRating.again,
              ),
              const SizedBox(width: 6),
              _previewRating(
                'Sulit',
                '1 hari',
                AppColors.amber,
                SrsRating.hard,
              ),
              const SizedBox(width: 6),
              _previewRating(
                'Bagus',
                '3 hari',
                AppColors.primary,
                SrsRating.good,
              ),
              const SizedBox(width: 6),
              _previewRating('Mudah', '6 hari', AppColors.mint, SrsRating.easy),
            ],
          ),
        ],
      ),
    );
  }

  Widget _previewRating(
    String label,
    String hint,
    Color color,
    SrsRating rating,
  ) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: () => onRate(rating),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 7, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PracticeTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  const _PracticeTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.55 : 1,
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SoftIcon(icon: icon, color: color, size: 40),
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
            Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}

class _ReviewCta extends StatelessWidget {
  final int dueCount;
  final VoidCallback onStart;
  const _ReviewCta({required this.dueCount, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.heroStart, AppColors.heroEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MULAI SEMUA REVIEW',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                    color: AppColors.onHeroMuted,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  dueCount > 0
                      ? '$dueCount kartu menunggu jawaban'
                      : 'Tidak ada kartu jatuh tempo',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dueCount > 0
                      ? 'Estimasi ±${math.max(1, (dueCount * 0.5).ceil())} menit'
                      : 'Coba sesi acak untuk latihan tambahan',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              minimumSize: const Size(0, 42),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            onPressed: onStart,
            child: const Text('Mulai'),
          ),
        ],
      ),
    );
  }
}
