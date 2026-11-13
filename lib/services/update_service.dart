import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class UpdateException implements Exception {
  final String message;
  const UpdateException(this.message);
  @override
  String toString() => message;
}

class UpdateInfo {
  final int versionCode;
  final String versionName;
  final String apkUrl;
  final String notes;
  final int sizeBytes;
  final String? sha256;

  const UpdateInfo({
    required this.versionCode,
    required this.versionName,
    required this.apkUrl,
    required this.notes,
    required this.sizeBytes,
    this.sha256,
  });

  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    final versionCode = json['versionCode'];
    final apkUrl = json['apkUrl'];
    if (versionCode is! num || apkUrl is! String) {
      throw const UpdateException('Format manifest pembaruan tidak valid.');
    }
    if (versionCode.toInt() <= 0) {
      throw const UpdateException('versionCode manifest harus lebih dari 0.');
    }
    final uri = Uri.tryParse(apkUrl);
    if (uri == null || (uri.scheme != 'https' && uri.scheme != 'http')) {
      throw const UpdateException('URL APK pada manifest tidak valid.');
    }
    final sha = json['sha256'] as String?;
    if (sha != null &&
        sha.isNotEmpty &&
        !RegExp(r'^[a-fA-F0-9]{64}$').hasMatch(sha)) {
      throw const UpdateException('Checksum SHA-256 pada manifest tidak valid.');
    }
    final size = (json['sizeBytes'] as num?)?.toInt() ?? 0;
    if (size < 0) {
      throw const UpdateException('Ukuran APK pada manifest tidak valid.');
    }
    return UpdateInfo(
      versionCode: versionCode.toInt(),
      versionName: json['versionName'] as String? ?? versionCode.toString(),
      apkUrl: apkUrl,
      notes: json['notes'] as String? ?? '',
      sizeBytes: size,
      sha256: sha,
    );
  }
}

class UpdateCheckResult {
  final String currentVersion;
  final int currentBuild;
  final UpdateInfo? available;

  const UpdateCheckResult({
    required this.currentVersion,
    required this.currentBuild,
    required this.available,
  });

  bool get hasUpdate => available != null;
}

class UpdateService {
  /// Harus berupa URL publik. Repo source boleh privat, tetapi manifest dan APK
  /// rilis harus dapat diunduh tanpa autentikasi.
  static const String defaultManifestUrl =
      'https://raw.githubusercontent.com/mahfudinkerja/sinau-korea/main/update.json';
  static const String manifestUrl = String.fromEnvironment(
    'UPDATE_MANIFEST_URL',
    defaultValue: defaultManifestUrl,
  );

  final http.Client _client;
  final bool _ownsClient;

  UpdateService({http.Client? client})
      : _client = client ?? http.Client(),
        _ownsClient = client == null;

  Future<UpdateCheckResult> check() async {
    final package = await PackageInfo.fromPlatform();
    final currentBuild = int.tryParse(package.buildNumber) ?? 0;
    final uri = Uri.parse(
      '$manifestUrl?ts=${DateTime.now().millisecondsSinceEpoch}',
    );
    try {
      final response = await _client
          .get(uri, headers: const {'Cache-Control': 'no-cache'})
          .timeout(const Duration(seconds: 12));
      if (response.statusCode == 404) {
        throw const UpdateException(
          'Manifest pembaruan tidak ditemukan (404). Pastikan repo rilis '
          'publik dan update.json tersedia di branch utama.',
        );
      }
      if (response.statusCode != 200) {
        throw UpdateException(
          'Server pembaruan merespons ${response.statusCode}.',
        );
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const UpdateException('Manifest pembaruan tidak valid.');
      }
      final info = UpdateInfo.fromJson(decoded);
      return UpdateCheckResult(
        currentVersion: package.version,
        currentBuild: currentBuild,
        available: info.versionCode > currentBuild ? info : null,
      );
    } on TimeoutException {
      throw const UpdateException(
        'Cek pembaruan timeout. Periksa koneksi internet.',
      );
    } on FormatException {
      throw const UpdateException('Manifest pembaruan tidak bisa dibaca.');
    } on SocketException {
      throw const UpdateException(
        'Tidak dapat menghubungi server pembaruan. Periksa koneksi internet.',
      );
    } on http.ClientException {
      throw const UpdateException(
        'Koneksi ke server pembaruan terputus. Coba lagi.',
      );
    }
  }

  Future<File> download(
    UpdateInfo info, {
    void Function(int received, int total)? onProgress,
  }) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/sinau-korea-${info.versionName}.apk');
    if (await file.exists()) await file.delete();

    IOSink? sink;
    var success = false;
    try {
      final request = http.Request('GET', Uri.parse(info.apkUrl));
      request.headers['Accept'] = 'application/vnd.android.package-archive';
      final response = await _client
          .send(request)
          .timeout(const Duration(seconds: 25));
      if (response.statusCode != 200) {
        throw UpdateException('Unduhan gagal (${response.statusCode}).');
      }
      final total = response.contentLength ?? info.sizeBytes;
      sink = file.openWrite();
      var received = 0;
      await for (final chunk in response.stream.timeout(
        const Duration(seconds: 45),
      )) {
        sink.add(chunk);
        received += chunk.length;
        onProgress?.call(received, total);
      }
      await sink.flush();
      await sink.close();
      sink = null;

      if (info.sizeBytes > 0 && received != info.sizeBytes) {
        throw UpdateException(
          'Ukuran APK tidak sesuai (${formatBytes(received)} dari '
          '${formatBytes(info.sizeBytes)}).',
        );
      }
      final expected = info.sha256;
      if (expected != null && expected.isNotEmpty) {
        final digest = await sha256.bind(file.openRead()).first;
        if (digest.toString().toLowerCase() != expected.toLowerCase()) {
          throw const UpdateException(
            'Checksum APK tidak cocok. Unduhan dibatalkan.',
          );
        }
      }
      success = true;
      return file;
    } on TimeoutException {
      throw const UpdateException('Unduhan timeout. Coba lagi.');
    } finally {
      await sink?.close();
      if (!success && await file.exists()) {
        try {
          await file.delete();
        } on FileSystemException {
          // File sementara akan dibersihkan sistem bila masih terkunci.
        }
      }
    }
  }

  void dispose() {
    if (_ownsClient) _client.close();
  }
}

String formatBytes(int bytes) {
  if (bytes <= 0) return '-';
  const units = ['B', 'KB', 'MB', 'GB'];
  var value = bytes.toDouble();
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  final decimals = unit >= 2 ? 1 : 0;
  return '${value.toStringAsFixed(decimals)} ${units[unit]}';
}
