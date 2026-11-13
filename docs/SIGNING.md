# Release signing — Sinau Korea

## Status saat ini

- `android/app/build.gradle.kts` mendukung dua jalur:
  - **Dengan** `android/key.properties` → memakai signing config `release`.
  - **Tanpa** file tersebut → fallback ke debug key dan menulis peringatan saat build.
- Tidak ada keystore produksi yang dibuat atau di-commit oleh agen. Pembuatan key adalah keputusan deployment dan harus dilakukan pemilik aplikasi.
- APK v1.3.0 (`versionCode 5`) dan v1.4.0 (`versionCode 6`) yang beredar ditandatangani dengan `CN=Android Debug`. Ini memungkinkan update mempertahankan data, tetapi belum layak untuk distribusi produksi.

## Membuat keystore produksi (hanya setelah keputusan deploy)

```bash
cd android
keytool -genkeypair -v \
  -keystore sinau-korea-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias sinau-korea
```

Lalu:

```bash
cd ..
cp android/key.properties.example android/key.properties
# isi storePassword, keyPassword, dan storeFile
```

`storeFile` di-resolve relatif terhadap folder `android/`. File `key.properties`, `*.jks`, dan `*.keystore` sudah masuk `.gitignore`.

**Cadangkan keystore dan password di tempat aman di luar repo.** Kehilangan key berarti tidak bisa merilis pembaruan dengan identitas yang sama.

## Build dan verifikasi

```bash
flutter build apk --release
"$HOME/Library/Android/sdk/build-tools/36.0.0/apksigner" verify \
  --print-certs build/app/outputs/flutter-apk/app-release.apk
```

Pastikan output menampilkan sertifikat produksi, bukan `CN=Android Debug`. Build tanpa `key.properties` akan tetap memakai debug key; jangan mengunggah APK itu.

## Migrasi dari debug key

Android mengizinkan pembaruan hanya jika **package name dan signing certificate sama**. Konsekuensinya:

1. **Tetap memakai debug key** — hanya cocok untuk kanal sideload internal. Tidak layak untuk distribusi publik dan berisiko bila debug keystore hilang.
2. **Ganti ke certificate produksi** — pengguna v1.3.0 harus uninstall lalu install ulang. Progres lokal (XP, streak, SRS, riwayat kuis) hilang karena belum ada export/import. Implementasikan export/import terlebih dahulu sebelum migrasi ini.
3. **Play Store dengan Play App Signing** — distribusi baru memakai upload key terpisah. Ini bukan pembaruan langsung dari kanal sideload; butuh listing dan keputusan produk.

Jangan mengganti signing key sebelum salah satu jalur di atas dipilih secara eksplisit.
