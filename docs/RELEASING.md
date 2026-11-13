# Kanal pembaruan — Sinau Korea

## Kondisi saat ini

Kanal distribusi aktif lewat GitHub Releases publik:

- Manifest: `https://raw.githubusercontent.com/mahfudinkerja/sinau-korea/main/update.json`
- Rilis terbaru: **v1.5.0** (`versionCode 7`), aset `sinau-korea-1.5.0.apk`.
- URL manifest lama (`volingo-korean-releases`) di-redirect GitHub ke repo yang sama, sehingga app v1.3.0 tetap bisa mengecek update.
- APK v1.4.0 dan v1.5.0 masih memakai debug certificate yang sama dengan v1.3.0. Ini cukup untuk kanal sideload, tetapi belum memenuhi standar distribusi produksi; lihat `docs/SIGNING.md`.

Updater memvalidasi URL, `versionCode`, ukuran, dan SHA-256, menampilkan error yang jelas, bisa di-retry, serta menghapus file sementara yang gagal.

## Yang harus disiapkan pemilik repo

Pilih salah satu:

1. **Repo rilis publik terpisah** (disarankan): source tetap privat, repo baru hanya berisi `update.json` + APK di GitHub Releases.
2. **Jadikan repo `sinau-korea` publik**: source dan rilis berada di tempat yang sama.
3. **Hosting statis sendiri**: unggah `update.json` dan APK ke HTTPS publik.

Repo source boleh privat. Yang wajib publik hanya manifest dan APK.

## Format manifest

```json
{
  "versionCode": 7,
  "versionName": "1.5.0",
  "apkUrl": "https://<host-publik>/<path>/sinau-korea-1.5.0.apk",
  "notes": "Catatan rilis singkat.",
  "sizeBytes": 12345678,
  "sha256": "<64 karakter hex>"
}
```

`versionCode` harus lebih besar dari build number terpasang. `apkUrl` wajib `http(s)`. SHA-256 divalidasi sebelum installer dibuka.

## Alur rilis

```bash
flutter test
flutter analyze
flutter build apk --release
APK=build/app/outputs/flutter-apk/app-release.apk
stat -f%z "$APK"          # macOS: ukuran byte
shasum -a 256 "$APK"      # checksum
```

1. Verifikasi certificate dengan `apksigner` (lihat `docs/SIGNING.md`).
2. Unggah APK ke GitHub Release / hosting publik.
3. Perbarui `update.json` dengan ukuran dan checksum **file yang benar-benar diunggah**.
4. Verifikasi manifest dapat diakses tanpa login:

```bash
curl -sS -o /dev/null -w '%{http_code}\n' \
  https://raw.githubusercontent.com/<owner>/<repo-publik>/main/update.json
```

5. Jalankan `flutter build apk --release` dengan manifest final (atau `--dart-define=UPDATE_MANIFEST_URL=...`) sebelum didistribusikan.

## Catatan keamanan

- Jangan menaruh token, password keystore, atau URL yang memerlukan autentikasi di manifest.
- Jangan mengaktifkan `allowBackup` tanpa kebijakan data yang jelas.
- Setelah kanal aktif, uji update dari versi lama di perangkat/emulator sebelum mengumumkannya.
