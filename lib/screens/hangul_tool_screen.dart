import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';
import '../utils/hangul.dart';
import '../widgets/common.dart';

class HangulToolScreen extends StatefulWidget {
  const HangulToolScreen({super.key});

  @override
  State<HangulToolScreen> createState() => _HangulToolScreenState();
}

class _HangulToolScreenState extends State<HangulToolScreen> {
  final controller = TextEditingController();
  String output = '';

  static const examples = [
    ('annyeonghaseyo', '안녕하세요', 'halo'),
    ('gamsahamnida', '감사합니다', 'terima kasih'),
    ('hangugeo', '한국어', 'bahasa Korea'),
    ('isseoyo', '있어요', 'ada'),
    ('bogo sipeo', '보고 싶어', 'aku merindukanmu'),
    ('eotteokhae', '어떡해', 'bagaimana ini'),
    ('saranghae', '사랑해', 'aku cinta kamu'),
    ('gwaenchanayo', '괜찮아요', 'tidak apa-apa'),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _update(String value) {
    setState(() => output = romanToHangul(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ketik Hangul')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const SectionHeader(
            'Latin → 한글',
            subtitle: 'Ketik bunyinya, langsung jadi Hangul. Fitur khas Sinau Korea.',
          ),
          TextField(
            controller: controller,
            onChanged: _update,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: 'annyeonghaseyo',
              prefixIcon: Icon(Icons.keyboard_rounded, size: 20),
              suffixIcon: controller.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        controller.clear();
                        _update('');
                      },
                      icon: Icon(Icons.close_rounded, size: 18),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            gradient: LinearGradient(
              colors: [AppColors.panelStart, AppColors.panelEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'HASIL',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const Spacer(),
                    if (output.isNotEmpty)
                      IconButton(
                        tooltip: 'Salin',
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(text: output),
                          );
                          if (context.mounted) {
                            showSnack(context, 'Hangul disalin.');
                          }
                        },
                        icon: Icon(
                          Icons.copy_rounded,
                          size: 18,
                          color: AppColors.muted,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  output.isEmpty ? '...' : output,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    color: output.isEmpty ? AppColors.muted : AppColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  output.isEmpty
                      ? 'Hasil konversi muncul di sini.'
                      : '${output.runes.length} karakter Hangul',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const SectionHeader(
            'Coba contoh',
            subtitle: 'Ketuk untuk mengisi kolom dan melihat hasilnya.',
          ),
          for (final example in examples)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                onTap: () {
                  controller.text = example.$1;
                  _update(example.$1);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                example.$2,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                example.$1,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            example.$3,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.north_west_rounded,
                      size: 16,
                      color: AppColors.muted,
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          AppCard(
            color: AppColors.surfaceAlt,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 17,
                  color: AppColors.amber,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Konversi ini untuk latihan. Romanisasi bisa ambigu (mis. bunyi resyllabification), jadi gunakan sebagai pemandu — bukan pengganti aturan ejaan resmi.',
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
