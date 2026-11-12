import 'package:flutter/services.dart';

enum InstallOutcome { started, permissionRequired, failed }

class UpdateInstaller {
  static const MethodChannel _channel =
      MethodChannel('id.sinaukorea/updater');

  static Future<bool> canInstall() async {
    try {
      return await _channel.invokeMethod<bool>('canInstall') ?? false;
    } on PlatformException {
      return false;
    }
  }

  static Future<void> openInstallSettings() async {
    try {
      await _channel.invokeMethod('openInstallSettings');
    } on PlatformException {
      // Perangkat tidak menyediakan halaman izin khusus; buka pengaturan app.
      await _channel.invokeMethod('openAppSettings');
    }
  }

  static Future<InstallOutcome> install(String path) async {
    try {
      final result = await _channel.invokeMethod<String>(
        'installApk',
        {'path': path},
      );
      switch (result) {
        case 'started':
          return InstallOutcome.started;
        case 'permission_required':
          return InstallOutcome.permissionRequired;
        default:
          return InstallOutcome.failed;
      }
    } on PlatformException {
      return InstallOutcome.failed;
    }
  }
}
