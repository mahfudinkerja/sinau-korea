# Kanal pembaruan — Sinau Korea

## Kondisi saat ini

Updater sudah berfungsi secara kode, tetapi kanal distribusinya belum aktif:

- Manifest default: `https://raw.githubusercontent.com/mahfudinkerja/sinau-korea/main/update.json`
- Repo `sinau-korea` masih **privat** → permintaan tanpa autentikasi menghasilkan 404.
- Manifest lama di `volingo-korean-releases` juga 404.
- `update.json` di repo masih menunjuk APK v1.3.0 di repo lama dan belum diperbarui ke v1.4.0 karena aset v1.4.0 belum dipublikasikan. Jangan mengarang URL rilis.

Updater sekarang menampilkan pesan 404 yang jelas, bisa di-retry, memvalidasi ukuran dan SHA-256, serta menghapus file sementara yang gagal.

## Yang harus disiapkan pemilik repo

Pilih salah satu:

1. **Repo rilis publik terpisah** (disarankan): source tetap privat, repo baru hanya berisi `update.json` + APK di GitHub Releases.
2. **Jadikan repo `sinau-korea` publik**: source dan rilis berada di tempat yang sama.
3. **Hosting statis sendiri**: unggah `update.json` dan APK ke HTTPS publik.

Repo source boleh privat. Yang wajib publik hanya manifest dan APK.

## Format manifest

```json
{
  "versionCode": 6,
  "versionName": "1.4.0",
  "apkUrl": "https://<host-publik>/<path>/sinau-korea-1.4.0.apk",
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
