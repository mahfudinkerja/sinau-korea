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

## Batasan

Konten disusun ulang sebagai kurikulum orisinal, bukan salinan materi berbayar Volingo. Belum ada audio/TTS, akun, sinkronisasi cloud, atau format ujian TOPIK resmi penuh.
