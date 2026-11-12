import 'package:flutter/material.dart';

import '../screens/update_screen.dart';
import '../services/update_service.dart';
import '../theme.dart';

class UpdateBanner extends StatefulWidget {
  const UpdateBanner({super.key});

  @override
  State<UpdateBanner> createState() => _UpdateBannerState();
}

class _UpdateBannerState extends State<UpdateBanner> {
  final UpdateService service = UpdateService();
  UpdateInfo? info;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    try {
      final result = await service.check();
      if (!mounted) return;
      if (result.available != null) {
        setState(() => info = result.available);
      }
    } catch (_) {
      // Pemeriksaan otomatis bersifat silent; layar Pembaruan menampilkan error.
    }
  }

  Future<void> _open() async {
    final current = info;
    if (current == null) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UpdateScreen(initialInfo: current),
      ),
    );
    if (!mounted) return;
    setState(() => info = null);
    await _check();
  }

  @override
  Widget build(BuildContext context) {
    final current = info;
    if (current == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: _open,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF21305A), Color(0xFF152033)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.32),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.system_update_alt_rounded,
                size: 19,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pembaruan v${current.versionName} tersedia',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Unduh dan pasang langsung dari aplikasi.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Perbarui',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
