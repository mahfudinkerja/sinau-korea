# Volingo Korean

Aplikasi belajar bahasa Korea untuk Android, terinspirasi alur produk Volingo tetapi khusus track Korea. Dibangun dengan Flutter, berjalan offline, dan menyimpan progres di perangkat.

## Fitur

- **Roadmap Hangul → C2** — 12 modul bertingkat A0–C2 dengan materi, contoh kalimat, kosakata, dan kuis.
- **SRS Flashcard (SM-2)** — penjadwalan ulang otomatis, rating Lagi/Sulit/Bagus/Mudah.
- **Bank soal** — tiga tipe soal, filter level, penilaian instan, dan pembahasan.
- **Dialog** — 8 skrip situasi nyata dengan romanisasi, terjemahan, dan mode fokus.
- **Bacaan** — 5 teks bertingkat dengan terjemahan per kalimat dan kuis pemahaman.
- **Tata bahasa** — 20 pola dengan rumus, contoh, dan jebakan umum.
- **Simulasi TOPIK** — 20 soal, timer 20 menit, skor terbaik tersimpan.
- **K-Drama Pack** — 18 frasa, roadmap 4 minggu, dan checklist.
- **Ketik Hangul** — konversi romanisasi Latin ke Hangul secara langsung.
- **Pembaruan dalam aplikasi** — cek versi saat dibuka, unduh APK berprogres, verifikasi SHA-256, lalu buka installer Android.

## Build

```bash
flutter pub get
flutter run
flutter build apk --release
```

APK release dihasilkan di `build/app/outputs/flutter-apk/app-release.apk`.

## Verifikasi

```bash
flutter analyze
flutter test
```

## Struktur

- `lib/data/` — kurikulum, kosakata, dialog, bacaan, tata bahasa, frasa drama.
- `lib/services/` — state/progres (SharedPreferences), SRS, generator soal.
- `lib/screens/` — dashboard, roadmap, modul, review, dan seluruh layar latihan.
- `lib/utils/hangul.dart` — konverter romanisasi → Hangul.

## Pembaruan aplikasi

Pembaruan tidak lewat Play Store. App membaca manifest publik, mengunduh APK rilis, memverifikasi checksum, lalu membuka installer Android.

- Manifest: `https://raw.githubusercontent.com/mahfudinkerja/volingo-korean-releases/main/update.json`
- Kanal rilis: `https://github.com/mahfudinkerja/volingo-korean-releases`
- Izin Android yang dipakai: `INTERNET`, `REQUEST_INSTALL_PACKAGES`, dan FileProvider untuk membagikan file APK ke installer.

Alur rilis baru:

1. Naikkan `version` dan build number di `pubspec.yaml` (contoh `1.2.0+4`).
2. Build: `flutter build apk --release`.
3. Buat GitHub Release di repo rilis dan unggah APK.
4. Perbarui `update.json` dengan `versionCode`, `versionName`, `apkUrl`, `sizeBytes`, `sha256`, dan catatan rilis.

> **Signing:** APK rilis saat ini memakai debug keystore Flutter (konfigurasi default). Android hanya mau memasang update dengan package dan signing key yang sama. Jangan ganti keystore selama kanal ini dipakai, dan cadangkan `~/.android/debug.keystore`.

## Batasan

Konten disusun ulang sebagai kurikulum orisinal, bukan salinan materi berbayar Volingo. Belum ada audio/TTS, akun, sinkronisasi cloud, atau format ujian TOPIK resmi penuh.
