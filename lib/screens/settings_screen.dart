import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'update_screen.dart';

class SettingsScreen extends StatefulWidget {
  final AppState state;
  const SettingsScreen({super.key, required this.state});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final Future<PackageInfo> _version = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Pengaturan')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              const SectionHeader(
                'Tampilan',
                subtitle: 'Pilih tema yang paling nyaman untuk matamu.',
              ),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mode tema',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sistem mengikuti pengaturan terang/gelap Android.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment(
                            value: ThemeMode.system,
                            icon: Icon(Icons.brightness_auto_rounded, size: 17),
                            label: Text('Sistem'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.light,
                            icon: Icon(Icons.light_mode_rounded, size: 17),
                            label: Text('Terang'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            icon: Icon(Icons.dark_mode_rounded, size: 17),
                            label: Text('Gelap'),
                          ),
                        ],
                        selected: {widget.state.themeMode},
                        onSelectionChanged: (selection) =>
                            widget.state.setThemeMode(selection.first),
                        showSelectedIcon: false,
                        style: ButtonStyle(
                          visualDensity: VisualDensity.compact,
                          textStyle: WidgetStateProperty.all(
                            TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const SectionHeader(
                'Umpan balik',
                subtitle: 'Getaran halus saat memilih jawaban dan kartu.',
              ),
              AppCard(
                padding: EdgeInsets.zero,
                child: SwitchListTile(
                  value: widget.state.hapticsEnabled,
                  onChanged: widget.state.setHapticsEnabled,
                  activeThumbColor: AppColors.primary,
                  title: const Text(
                    'Haptic feedback',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    'Aktifkan getaran saat jawaban, rating kartu, dan navigasi.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const SectionHeader('Pembaruan'),
              AppCard(
                padding: const EdgeInsets.all(15),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const UpdateScreen(),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.system_update_alt_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pembaruan aplikasi',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Cek versi terbaru dan pasang langsung dari app.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.muted,
                      size: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const SectionHeader('Tentang'),
              AppCard(
                child: FutureBuilder<PackageInfo>(
                  future: _version,
                  builder: (context, snapshot) {
                    final package = snapshot.data;
                    return Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 18,
                              color: AppColors.muted,
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Volingo Korean',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              package == null
                                  ? '...'
                                  : 'v${package.version} (${package.buildNumber})',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.offline_bolt_rounded,
                              size: 18,
                              color: AppColors.mint,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Semua progres, XP, streak, dan kartu SRS disimpan offline di perangkat ini.',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
