# Sinau Korea

Repo: https://github.com/mahfudinkerja/sinau-korea

Aplikasi belajar bahasa Korea untuk Android dengan alur belajar terstruktur. Dibangun dengan Flutter, berjalan offline, dan menyimpan progres di perangkat.

## Fitur

- **Roadmap Hangul → C2** — 12 modul bertingkat A0–C2 dengan materi, contoh kalimat, kosakata, dan kuis.
- **Mastery modul** — kuis modul wajib minimal **70%** untuk lulus. Percobaan gagal tersimpan sebagai `needs review`, bisa diulang, dan skor serta jawaban salah bisa ditinjau.
- **SRS Flashcard (SM-2 sederhana)** — rating Lagi/Sulit/Bagus/Mudah, kartu baru/belajar/matang, dan jadwal ulang. Rating bisa diurungkan.
- **Kuis terhubung SRS** — jawaban kosakata yang salah langsung masuk antrean review dan bank kesalahan; kesalahan non-kosakata masuk bank kesalahan terpisah.
- **Bank soal** — tiga tipe soal, filter level, penilaian instan, dan pembahasan.
- **Dialog** — 8 skrip situasi nyata dengan romanisasi, terjemahan, dan mode fokus.
- **Bacaan** — 5 teks bertingkat dengan terjemahan per kalimat dan kuis pemahaman.
- **Tata bahasa** — 21 pola dengan rumus, contoh, dan jebakan umum.
- **Latihan Kilat Kosakata** — 20 soal kosakata, timer 20 menit. **Bukan** simulasi struktur ujian TOPIK.
- **K-Drama Pack** — 18 frasa, roadmap 4 minggu, dan checklist.
- **Ketik Hangul** — konversi romanisasi Latin ke Hangul secara langsung.
- **Pembaruan dalam aplikasi** — cek manifest, unduh APK berprogres, verifikasi ukuran + SHA-256, lalu buka installer Android. Kanal rilis aktif lewat GitHub Releases publik.
- **Light & dark mode** — tema Sistem/Terang/Gelap dengan warna heading eksplisit agar tetap terbaca.
- **Haptic feedback** — bisa dimatikan.
- **Adaptive app icon** — ikon ㅎ untuk legacy, adaptive, dan monochrome.

## Build

```bash
flutter pub get
flutter run
flutter build apk --release
```

APK release dihasilkan di `build/app/outputs/flutter-apk/app-release.apk`.

Untuk kanal pembaruan kustom:

```bash
flutter build apk --release \
  --dart-define=UPDATE_MANIFEST_URL=https://contoh-publik.example/update.json
```

### Signing

Release otomatis memakai keystore produksi bila `android/key.properties` tersedia. Tanpa file itu, build tetap berjalan tetapi memakai **debug key** dan tidak boleh didistribusikan. Lihat [`docs/SIGNING.md`](docs/SIGNING.md).

## Verifikasi

```bash
flutter analyze
flutter test
```

## Struktur

- `lib/data/` — kurikulum, kosakata, dialog, bacaan, tata bahasa, frasa drama.
- `lib/services/` — state/progres (SharedPreferences), SRS, generator soal, updater.
- `lib/screens/` — dashboard, roadmap, modul, review, dan seluruh layar latihan.
- `lib/utils/hangul.dart` — konverter romanisasi → Hangul.
- `docs/` — prosedur signing dan rilis.

## Pembaruan aplikasi

Pembaruan tidak lewat Play Store. App membaca manifest publik, mengunduh APK rilis, memverifikasi ukuran dan checksum, lalu membuka installer Android.

- Manifest default: `https://raw.githubusercontent.com/mahfudinkerja/sinau-korea/main/update.json`
- Kanal lama: `https://raw.githubusercontent.com/mahfudinkerja/volingo-korean-releases/main/update.json` (redirect ke repo yang sama)
- Status: repo dan aset rilis publik. Rilis terbaru **v1.5.0** (`versionCode 7`). App v1.3.0 memakai URL lama, dan redirect GitHub membuat manifest baru tetap terjangkau. Lihat [`docs/RELEASING.md`](docs/RELEASING.md).
- Izin Android: `INTERNET`, `REQUEST_INSTALL_PACKAGES`, dan FileProvider.
- `applicationId` sengaja dipertahankan: `id.volingo.volingo_korean`.

> **Signing:** versi 1.3.0 dan APK debug sebelumnya memakai debug certificate. APK dengan certificate berbeda tidak dapat dipasang sebagai pembaruan. Baca rencana migrasi di `docs/SIGNING.md` sebelum mengganti key.

## Batasan saat ini

- Belum ada audio/TTS, listening, speaking, writing, notifikasi, atau onboarding.
- Konten masih 85 kosakata, 12 modul, 21 pola grammar, dan 5 bacaan.
- Latihan timer kosakata bukan ujian TOPIK resmi.
- Belum ada export/import progres; ini prasyarat sebelum migrasi signing.
- Light/dark heading sudah diperbaiki, tetapi audit aksesibilitas menyeluruh (screen reader, font 200%, touch target) belum selesai.
