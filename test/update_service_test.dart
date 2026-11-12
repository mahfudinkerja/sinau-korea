import 'package:flutter_test/flutter_test.dart';
import 'package:volingo_korean/services/update_service.dart';

void main() {
  group('UpdateInfo', () {
    test('membaca manifest lengkap', () {
      final info = UpdateInfo.fromJson({
        'versionCode': 3,
        'versionName': '1.1.1',
        'apkUrl': 'https://example.com/app.apk',
        'notes': 'Perbaikan.',
        'sizeBytes': 50386553,
        'sha256': 'abc',
      });
      expect(info.versionCode, 3);
      expect(info.versionName, '1.1.1');
      expect(info.apkUrl, 'https://example.com/app.apk');
      expect(info.sizeBytes, 50386553);
      expect(info.sha256, 'abc');
    });

    test('menolak manifest tanpa versionCode atau apkUrl', () {
      expect(() => UpdateInfo.fromJson({}), throwsA(isA<UpdateException>()));
      expect(
        () => UpdateInfo.fromJson({'versionCode': 3}),
        throwsA(isA<UpdateException>()),
      );
    });
  });

  test('UpdateCheckResult mendeteksi versi lebih baru', () {
    const info = UpdateInfo(
      versionCode: 4,
      versionName: '1.2.0',
      apkUrl: 'https://example.com/app.apk',
      notes: '',
      sizeBytes: 0,
    );
    const result = UpdateCheckResult(
      currentVersion: '1.1.1',
      currentBuild: 3,
      available: info,
    );
    expect(result.hasUpdate, isTrue);
    expect(result.available!.versionName, '1.2.0');
  });

  test('formatBytes', () {
    expect(formatBytes(0), '-');
    expect(formatBytes(900), '900 B');
    expect(formatBytes(1536), '2 KB');
    expect(formatBytes(50386553), '48.1 MB');
  });
}
