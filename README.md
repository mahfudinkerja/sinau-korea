# Sinau Korea

Aplikasi belajar bahasa Korea untuk Android dengan alur belajar terstruktur. Dibangun dengan Flutter, berjalan offline, dan menyimpan progres di perangkat.

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
- **Light & dark mode** — tema Sistem/Terang/Gelap di halaman Pengaturan, dengan palet warna adaptif.
- **Haptic feedback** — getaran saat memilih jawaban, rating kartu SRS, membuka modul, dan berpindah tab; bisa dimatikan.
- **Adaptive app icon** — ikon ㅎ baru untuk legacy, adaptive, dan monochrome icon Android.

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

## Tampilan & haptic

Buka ikon ⚙ di Home. Tema mengikuti sistem secara default, atau pilih Terang/Gelap permanen. Haptic feedback aktif secara default dan dapat dimatikan dari halaman yang sama.

Ikon launcher digenerate dari `tool/generate_icon.py` ke `assets/icon/`. Untuk regenerate setelah mengubah desain:

```bash
python3 -m venv .venv && .venv/bin/pip install pillow
.venv/bin/python tool/generate_icon.py
dart run flutter_launcher_icons
```

## Pembaruan aplikasi

Pembaruan tidak lewat Play Store. App membaca manifest publik, mengunduh APK rilis, memverifikasi checksum, lalu membuka installer Android.

- Manifest: `https://raw.githubusercontent.com/mahfudinkerja/volingo-korean-releases/main/update.json`
- Kanal rilis: `https://github.com/mahfudinkerja/volingo-korean-releases`
- Rilis terbaru: v1.3.0 (`versionCode 5`)
- Izin Android yang dipakai: `INTERNET`, `REQUEST_INSTALL_PACKAGES`, dan FileProvider untuk membagikan file APK ke installer.

Alur rilis baru:

1. Naikkan `version` dan build number di `pubspec.yaml` (contoh `1.3.1+6`).
2. Build: `flutter build apk --release`.
3. Buat GitHub Release di repo rilis dan unggah APK.
4. Perbarui `update.json` dengan `versionCode`, `versionName`, `apkUrl`, `sizeBytes`, `sha256`, dan catatan rilis.

> **applicationId:** `id.volingo.volingo_korean` sengaja dipertahankan setelah rename ke Sinau Korea agar update dari versi lama tetap terpasang sebagai pembaruan, bukan aplikasi duplikat. Repo rilis juga masih memakai nama teknis `volingo-korean-releases`.

> **Signing:** APK rilis saat ini memakai debug keystore Flutter (konfigurasi default). Android hanya mau memasang update dengan package dan signing key yang sama. Jangan ganti keystore selama kanal ini dipakai, dan cadangkan `~/.android/debug.keystore`.

## Batasan

Konten disusun ulang sebagai kurikulum orisinal, bukan salinan materi berbayar produk sumber. Belum ada audio/TTS, akun, sinkronisasi cloud, atau format ujian TOPIK resmi penuh.
