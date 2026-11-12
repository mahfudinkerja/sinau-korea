import 'package:flutter/material.dart';

import '../data/dialog_data.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';

class DialogListScreen extends StatelessWidget {
  const DialogListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dialog')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const SectionHeader(
            'Skrip situasi nyata',
            subtitle: 'Baca peran, lalu sembunyikan terjemahan untuk mode fokus.',
          ),
          for (final dialog in koreanDialogs)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DialogScreen(dialog: dialog),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.cyan.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        Icons.forum_rounded,
                        color: AppColors.cyan,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  dialog.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              LevelChip(dialog.level, compact: true),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dialog.setting,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${dialog.lines.length} giliran bicara',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.muted,
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 4),
          Text(
            'Semua romanisasi memakai Revised Romanization, bukan ejaan Inggris.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class DialogScreen extends StatefulWidget {
  final DialogScript dialog;
  const DialogScreen({super.key, required this.dialog});

  @override
  State<DialogScreen> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen> {
  bool focusMode = false;

  @override
  Widget build(BuildContext context) {
    final dialog = widget.dialog;
    final firstSpeaker = dialog.lines.first.speaker;
    return Scaffold(
      appBar: AppBar(
        title: Text(dialog.title),
        actions: [
          IconButton(
            tooltip: 'Mode fokus',
            onPressed: () => setState(() => focusMode = !focusMode),
            icon: Icon(
              focusMode ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Row(
            children: [
              LevelChip(dialog.level),
              const SizedBox(width: 8),
              Text(
                '${dialog.lines.length} giliran',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Text(
                focusMode ? 'Fokus Korea' : 'Lengkap',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AppCard(
            color: AppColors.surfaceAlt,
            child: Row(
              children: [
                Icon(
                  Icons.place_outlined,
                  size: 17,
                  color: AppColors.muted,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    dialog.setting,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          for (final line in dialog.lines)
            _bubble(context, line, line.speaker == firstSpeaker),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => setState(() => focusMode = !focusMode),
            icon: Icon(
              focusMode ? Icons.visibility_rounded : Icons.visibility_off_rounded,
              size: 18,
            ),
            label: Text(
              focusMode ? 'Tampilkan terjemahan' : 'Sembunyikan terjemahan',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Coba baca peran satu orang dengan lantang sebelum melihat artinya.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _bubble(BuildContext context, DialogLine line, bool isLeft) {
    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isLeft ? AppColors.surface : AppColors.primary.withValues(alpha: 0.14),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isLeft ? 4 : 16),
            bottomRight: Radius.circular(isLeft ? 16 : 4),
          ),
          border: Border.all(
            color: isLeft
                ? AppColors.line
                : AppColors.primary.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(
              line.speaker,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
                color: isLeft ? AppColors.muted : AppColors.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              line.ko,
              textAlign: isLeft ? TextAlign.left : TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),
            if (!focusMode) ...[
              const SizedBox(height: 5),
              Text(
                line.roman,
                textAlign: isLeft ? TextAlign.left : TextAlign.right,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                line.id,
                textAlign: isLeft ? TextAlign.left : TextAlign.right,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
