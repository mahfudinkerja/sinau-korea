import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../services/update_installer.dart';
import '../services/update_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

class UpdateScreen extends StatefulWidget {
  final UpdateInfo? initialInfo;
  const UpdateScreen({super.key, this.initialInfo});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final UpdateService service = UpdateService();
  PackageInfo? package;
  UpdateCheckResult? result;
  bool checking = true;
  String? error;
  bool errorDuringCheck = false;
  bool downloading = false;
  bool installing = false;
  bool permissionNeeded = false;
  int received = 0;
  int total = 0;
  File? downloadedFile;
  String? installMessage;

  UpdateInfo? get available => result?.available ?? widget.initialInfo;

  @override
  void dispose() {
    service.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) {
      if (mounted) setState(() => package = value);
    });
    if (widget.initialInfo == null) {
      _check();
    } else {
      checking = false;
    }
  }

  Future<void> _check() async {
    setState(() {
      checking = true;
      error = null;
      errorDuringCheck = false;
      installMessage = null;
      permissionNeeded = false;
    });
    try {
      final value = await service.check();
      if (!mounted) return;
      setState(() {
        result = value;
        checking = false;
        if (value.available != null) {
          total = value.available!.sizeBytes;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        errorDuringCheck = true;
        checking = false;
      });
    }
  }

  Future<void> _downloadAndInstall() async {
    final info = available;
    if (info == null || downloading) return;
    setState(() {
      downloading = true;
      error = null;
      errorDuringCheck = false;
      installMessage = null;
      received = 0;
      total = info.sizeBytes;
    });
    try {
      final file = await service.download(
        info,
        onProgress: (value, size) {
          if (!mounted) return;
          setState(() {
            received = value;
            if (size > 0) total = size;
          });
        },
      );
      if (!mounted) return;
      downloadedFile = file;
      final allowed = await UpdateInstaller.canInstall();
      if (!mounted) return;
      if (!allowed) {
        setState(() {
          downloading = false;
          permissionNeeded = true;
          installMessage =
              'Izinkan "Install unknown apps" untuk Sinau Korea, lalu kembali dan tekan Pasang sekarang.';
        });
        await UpdateInstaller.openInstallSettings();
        return;
      }
      await _install(file);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        downloading = false;
        error = e.toString();
      });
    }
  }

  Future<void> _install(File file) async {
    setState(() => installing = true);
    final outcome = await UpdateInstaller.install(file.path);
    if (!mounted) return;
    setState(() {
      installing = false;
      switch (outcome) {
        case InstallOutcome.started:
          permissionNeeded = false;
          installMessage =
              'Installer Android sudah dibuka. Selesaikan pemasangan, lalu buka aplikasi kembali.';
        case InstallOutcome.permissionRequired:
          permissionNeeded = true;
          installMessage =
              'Android meminta izin pemasangan. Aktifkan izin untuk Sinau Korea, lalu tekan Pasang sekarang.';
        case InstallOutcome.failed:
          error =
              'Installer tidak bisa dibuka. Buka pengaturan izin, lalu coba pasang lagi.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final info = available;
    return Scaffold(
      appBar: AppBar(title: const Text('Pembaruan aplikasi')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          GradientPanel(
            colors: const [Color(0xFF243462), Color(0xFF151D35)],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.system_update_alt_rounded,
                  color: AppColors.onHero,
                  size: 26,
                ),
                const SizedBox(height: 10),
                Text(
                  'Selalu versi terbaru.',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: AppColors.onHero),
                ),
                const SizedBox(height: 6),
                const Text(
                  'App mengecek manifest rilis setiap dibuka. Unduhan diverifikasi SHA-256 sebelum installer Android dibuka.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.onHeroMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          AppCard(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Icon(
                  Icons.smartphone_rounded,
                  size: 19,
                  color: AppColors.muted,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    package == null
                        ? 'Membaca versi terpasang...'
                        : 'Terpasang: ${package!.version} (${package!.buildNumber})',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                TextButton(
                  onPressed: checking ? null : _check,
                  child: const Text('Cek'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (checking)
            const AppCard(
              child: Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Mengecek pembaruan...'),
                ],
              ),
            )
          else if (info == null && error != null)
            _checkErrorView()
          else if (info == null)
            _upToDateView()
          else
            _updateView(info),
          if (error != null && !(info == null && errorDuringCheck)) ...[
            const SizedBox(height: 14),
            AppCard(
              color: AppColors.rose.withValues(alpha: 0.07),
              border: Border.all(
                color: AppColors.rose.withValues(alpha: 0.28),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.rose,
                    size: 19,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      error!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: errorDuringCheck ? _check : _downloadAndInstall,
              child: Text(errorDuringCheck ? 'Cek ulang' : 'Coba lagi'),
            ),
          ],
          const SizedBox(height: 20),
          AppCard(
            color: AppColors.surfaceAlt,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 17,
                      color: AppColors.amber,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Kenapa lewat installer Android?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'App ini dipasang di luar Play Store, jadi Android akan menampilkan dialog konfirmasi "Update app". Data belajar, progres, dan kartu SRS tetap tersimpan karena pembaruan memakai package dan signing key yang sama.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkErrorView() {
    return AppCard(
      color: AppColors.rose.withValues(alpha: 0.07),
      border: Border.all(color: AppColors.rose.withValues(alpha: 0.28)),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.rose.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_off_rounded,
              color: AppColors.rose,
              size: 28,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Pembaruan belum bisa dicek',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            error ?? 'Terjadi kesalahan saat menghubungi server.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _check,
            child: const Text('Coba lagi'),
          ),
        ],
      ),
    );
  }

  Widget _upToDateView() {
    return AppCard(
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.mint.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: AppColors.mint,
              size: 30,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Kamu sudah di versi terbaru',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Tidak ada pembaruan yang tersedia saat ini.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _check,
            child: const Text('Cek lagi'),
          ),
        ],
      ),
    );
  }

  Widget _updateView(UpdateInfo info) {
    final percent = total > 0 ? (received / total).clamp(0.0, 1.0) : 0.0;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.mint.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  'UPDATE TERSEDIA',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: AppColors.mint,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'v${info.versionName}',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Versi ${info.versionName} siap dipasang',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          if (info.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              info.notes,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 14,
                color: AppColors.muted,
              ),
              const SizedBox(width: 5),
              Text(
                formatBytes(info.sizeBytes),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 14),
              Icon(
                Icons.verified_outlined,
                size: 14,
                color: AppColors.muted,
              ),
              const SizedBox(width: 5),
              Text(
                'SHA-256',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          if (downloading) ...[
            const SizedBox(height: 16),
            ProgressLine(value: percent, color: AppColors.primary),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Mengunduh ${(percent * 100).round()}%',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Text(
                  '${formatBytes(received)} / ${formatBytes(total)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
          if (installMessage != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.amber.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.amber.withValues(alpha: 0.24),
                ),
              ),
              child: Text(
                installMessage!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (permissionNeeded) ...[
            FilledButton.icon(
              onPressed: () => UpdateInstaller.openInstallSettings(),
              icon: Icon(Icons.settings_rounded, size: 19),
              label: const Text('Buka pengaturan izin'),
            ),
            if (downloadedFile != null) ...[
              const SizedBox(height: 9),
              OutlinedButton.icon(
                onPressed: installing ? null : () => _install(downloadedFile!),
                icon: Icon(Icons.install_mobile_rounded, size: 19),
                label: Text(
                  installing ? 'Membuka installer...' : 'Pasang sekarang',
                ),
              ),
            ],
          ] else
            FilledButton.icon(
              onPressed: downloading || installing ? null : _downloadAndInstall,
              icon: downloading || installing
                  ? const SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(Icons.download_rounded, size: 19),
              label: Text(
                downloading
                    ? 'Mengunduh...'
                    : installing
                        ? 'Membuka installer...'
                        : 'Unduh & pasang',
              ),
            ),
        ],
      ),
    );
  }
}
