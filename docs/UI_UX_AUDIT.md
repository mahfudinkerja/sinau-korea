# Sinau Korea — Audit UI/UX & Brief Redesign Total

Dokumen ini memetakan kondisi UI/UX aplikasi saat ini sebagai basis redesign total.
Sumber utama: kode di `lib/` (Flutter), `README.md`, dan screenshot audit di `dist/audit/`.

- Versi aplikasi: `1.4.0+6`
- Platform: Android (Flutter), offline-first, tanpa login
- Nama tampil: **Sinau Korea** (`android:label`, `MaterialApp.title`)
- Package/applicationId: `id.volingo.volingo_korean` (dipertahankan untuk jalur update APK)

---

## 1. Ringkasan Produk

Sinau Korea adalah aplikasi belajar bahasa Korea untuk Android dengan kurikulum
bertingkat A0–C2, latihan kuis, flashcard SRS, dan konten pendukung (dialog,
bacaan, tata bahasa, frasa drama, konverter Hangul). Semua progres disimpan lokal
di perangkat. Pembaruan aplikasi dilakukan lewat unduhan APK + verifikasi
SHA-256, bukan Play Store.

**Positioning saat ini:** aplikasi belajar mandiri yang padat fitur dan offline,
cenderung terasa seperti "kumpulan tools belajar" daripada satu pengalaman belajar
yang utuh.

**Peluang redesign:** menyatukan kurikulum, latihan, dan review menjadi satu loop
harian yang jelas, dengan identitas visual yang lebih matang dan aksesibilitas
yang lebih baik.

---

## 2. Pengguna & Jobs To Be Done

### Persona yang tersirat dari fitur

| Persona | Kebutuhan utama | Fitur yang relevan |
|---|---|---|
| Pemula nol (A0) | Mengenal Hangul, tidak bingung mulai dari mana | Modul A0, Ketik Hangul, roadmap |
| Pelajar TOPIK 1–2 | Latihan kosakata dan pemahaman dasar | Kuis modul, bank soal, bacaan A1–A2 |
| Penonton K-Drama | Belajar frasa praktis dan konteks | K-Drama Pack, dialog, frasa harian |
| Pembelajar mandiri menengah | Menjaga retensi dan konsistensi | SRS, statistik, streak, target harian |
| Pengguna offline | Belajar tanpa internet dan tanpa akun | Semua konten lokal, SharedPreferences |

### Jobs To Be Done

1. "Saat saya punya 10 menit, saya ingin tahu persis apa yang harus dipelajari."
2. "Saat saya lupa kosakata, saya ingin mengulangnya dengan jadwal yang masuk akal."
3. "Saat saya belajar modul, saya ingin tahu apakah saya benar-benar paham."
4. "Saat saya menonton drama, saya ingin bisa memakai frasa yang saya dengar."
5. "Saat saya ganti perangkat, saya ingin progres saya tidak hilang." (belum terpenuhi)

---

## 3. Information Architecture Saat Ini

### Navigasi utama

`RootShell` memakai `NavigationBar` dengan 4 tab dan `IndexedStack`
(`lib/screens/root_shell.dart:49-95`):

```
Sinau Korea
├── Belajar (Home)
│   ├── Hero "Lanjut Belajar" → LessonScreen → QuizScreen
│   ├── Statistik: XP, kartu jatuh tempo, akurasi, modul selesai
│   ├── Target harian
│   ├── Kartu Review SRS → tab Review
│   ├── Jalur TOPIK (carousel) → tab Roadmap
│   ├── Frasa hari ini (K-Drama)
│   ├── Akses cepat: Bank soal, Dialog, K-Drama pack, Ketik Hangul
│   └── Pengaturan (ikon gear) → SettingsScreen
├── Roadmap
│   └── 7 level A0–C2 → LessonScreen
├── Review (badge jumlah kartu jatuh tempo)
│   └── Sesi SRS: kosong / kartu / ringkasan
└── Latihan
    ├── Bank Soal → QuizScreen
    ├── Dialog → DialogListScreen → DialogScreen
    ├── Bacaan → ReadingListScreen → ReadingScreen → QuizScreen
    ├── Tata Bahasa
    ├── Latihan Kilat → QuizScreen (timer 20 menit)
    ├── K-Drama Pack
    └── Ketik Hangul
```

### Layar di luar bottom navigation

- `SettingsScreen` → `UpdateScreen`
- `UpdateBanner` tampil kondisional di Home
- `QuizScreen` dipakai ulang oleh modul, bank soal, bacaan, dan latihan kilat
- `LessonScreen`, `DialogScreen`, `ReadingScreen` adalah layar detail

### Masalah IA

- **Entry point ganda:** Bank Soal, Dialog, K-Drama, Ketik Hangul muncul di Home
  dan tab Latihan. Roadmap dan Review juga muncul sebagai tab sekaligus section
  di Home.
- **Tidak ada "hari ini":** Home adalah dashboard panjang, bukan rencana belajar.
- **Review adalah sesi, bukan pusat:** tab Review langsung memulai sesi dan tidak
  punya beranda deck/statistik/forecast.
- **Latihan tidak dikelompokkan:** 7 tools ditampilkan sebagai grid datar tanpa
  hierarki skill (kosakata, grammar, membaca, mendengar, berbicara).
- **Pengaturan tersembunyi:** hanya lewat ikon gear di Home, bukan pola umum
  (Profil/Me).

---

## 4. Inventaris Layar

| # | Layar | File | Tujuan | Elemen kunci | State |
|---|---|---|---|---|---|
| 1 | RootShell | `root_shell.dart` | Shell 4 tab | NavigationBar, badge due | Tab aktif |
| 2 | Home / Belajar | `home_screen.dart` | Dashboard & pintu masuk | Hero gradient, 4 StatBox, target harian, kartu review, carousel level, frasa, 4 ToolTile | Ada/tidak next lesson, update banner |
| 3 | Roadmap | `roadmap_screen.dart` | Jalur A0–C2 | Hero gradient, section per level, AppCard modul | Selesai/belum |
| 4 | Review SRS | `review_screen.dart` | Sesi flashcard | Kartu besar, reveal, 4 tombol rating, snackbar undo, ringkasan | Kosong, kartu, selesai |
| 5 | Latihan | `practice_screen.dart` | Direktori tools | Hero akurasi, GridView 7 tools, info card | Statis |
| 6 | Modul | `lesson_screen.dart` | Materi + kuis | Chip level, section materi, contoh, daftar kosakata, CTA bawah | Not started, needs review, passed |
| 7 | Kuis | `quiz_screen.dart` | Soal & hasil | Progress, kartu soal, opsi, feedback, timer, ringkasan + pembahasan | Soal, hasil, timeout, kosong |
| 8 | Bank Soal | `question_bank_screen.dart` | Setup kuis | Hero, filter level, statistik, CTA | Filter level |
| 9 | Dialog list | `dialog_screens.dart` | Daftar skrip | AppCard per dialog | Statis |
| 10 | Dialog detail | `dialog_screens.dart` | Baca percakapan | Bubble kiri/kanan, mode fokus | Fokus on/off |
| 11 | Bacaan list | `reading_screens.dart` | Daftar teks | AppCard per bacaan | Statis |
| 12 | Bacaan detail | `reading_screens.dart` | Teks + terjemahan | Kalimat per kartu, toggle terjemahan, CTA kuis | Terjemahan on/off |
| 13 | Tata Bahasa | `grammar_screen.dart` | Lookup pola | Search field, ExpansionTile, pitfall | Query, hasil kosong |
| 14 | Latihan Kilat | `mock_test_screen.dart` | Setup timed quiz | Hero, 3 StatBox, aturan, CTA | Mulai |
| 15 | K-Drama Pack | `drama_screen.dart` | Frasa & roadmap | Hero, roadmap 4 minggu, checklist | Checked/unchecked |
| 16 | Ketik Hangul | `hangul_tool_screen.dart` | Konversi Latin→Hangul | TextField, panel hasil, copy, contoh | Input kosong/terisi |
| 17 | Pengaturan | `settings_screen.dart` | Preferensi | SegmentedButton tema, switch haptic, update, tentang | Tema/haptic |
| 18 | Pembaruan | `update_screen.dart` | Cek/unduh/pasang APK | Hero, status, progress, error, izin installer | Checking, up-to-date, available, downloading, permission, error |
| 19 | UpdateBanner | `update_banner.dart` | Notifikasi update di Home | Banner gradient | Tampil/tidak |

---

## 5. Alur Utama

### 5.1 Belajar modul

```
Home
→ tap hero "Lanjut Belajar"
→ LessonScreen (materi + kosakata)
→ CTA "Mulai kuis modul"
→ QuizScreen (4–5 soal)
→ jawab → feedback + pembahasan
→ "Lihat hasil"
→ ringkasan LULUS/BELUM LULUS + pembahasan semua soal
→ "Selesai" / "Ulangi"
→ kembali ke LessonScreen
```

- Ambang lulus 70% (`kLessonPassThreshold`).
- Percobaan tersimpan maksimal 20 per modul.
- Jawaban salah kosakata otomatis membuat/menjadwalkan ulang kartu SRS.
- XP: +2 per jawaban benar, +25 saat pertama kali lulus modul.

### 5.2 Review SRS

```
Tab Review
→ ambil maksimal 20 kartu due
→ kartu Hangul
→ "Tampilkan arti" / tap kartu
→ arti + romanisasi + contoh
→ pilih Lagi / Sulit / Bagus / Mudah
→ snackbar "dijadwalkan ulang" + Urungkan
→ kartu berikutnya
→ ringkasan (jumlah kartu, XP, sisa due)
→ sesi berikutnya / sesi acak / kembali
```

State kosong menawarkan "Ulangi kesalahan" dan "Mulai sesi acak 10 kartu".
Tidak ada forecast, browser deck, atau statistik per kartu di UI.

### 5.3 Latihan mandiri

```
Tab Latihan
→ pilih tool
→ Bank Soal: filter level → 10 soal → hasil
→ Bacaan: pilih teks → baca/toggle terjemahan → kuis pemahaman
→ Dialog: pilih skrip → mode fokus
→ Latihan Kilat: 20 soal / 20 menit → skor terbaik
→ K-Drama: checklist frasa + roadmap 4 minggu
→ Ketik Hangul: konversi real-time + copy
```

### 5.4 Pembaruan aplikasi

```
App dibuka
→ UpdateBanner cek manifest (silent)
→ jika ada versi baru: banner di Home
→ UpdateScreen
→ Unduh & pasang
→ verifikasi ukuran + SHA-256
→ cek izin "Install unknown apps"
→ buka installer Android
→ pengguna menyelesaikan instalasi manual
```

### 5.5 Pengaturan

```
Home → ikon gear → SettingsScreen
→ tema Sistem/Terang/Gelap
→ haptic on/off
→ Pembaruan aplikasi
→ Tentang (versi, offline)
```

Tidak ada: tujuan belajar, pengingat, bahasa aplikasi, audio, export/import,
reset progres, atau tautan bantuan/kebijakan.

---

## 6. Design System Saat Ini

### 6.1 Warna

Token semantik ada di `AppColors` (`lib/theme.dart:5-50`), berubah berdasarkan
brightness. Nilai inti:

| Token | Light | Dark | Pemakaian |
|---|---|---|---|
| bg | `#F5F7FC` | `#080C12` | Scaffold |
| surface | `#FFFFFF` | `#111823` | Card |
| surfaceAlt | `#EDF1F8` | `#1A2433` | Sub-card, chip |
| text | `#121826` | `#F3F6FB` | Teks utama |
| muted | `#5D6B80` | `#93A3B8` | Teks sekunder |
| line | `#00000014` | `#FFFFFF14` | Border/divider |
| track | `#0000001F` | `#FFFFFF24` | Progress track |
| primary | `#4C63E8` | `#6C8CFF` | Aksi utama |
| indigo | `#3B4BC2` | `#4353C9` | Gradient brand |
| mint | `#0E9F75` | `#37D8A4` | Sukses, progress |
| amber | `#B7791F` | `#FFC45C` | Peringatan, XP |
| rose | `#D64560` | `#FF7A90` | Error, K-Drama |
| cyan | `#0E7490` | `#54C9E8` | Dialog, info |

Warna level (`levelColor`, `lib/theme.dart:234-253`): A0 rose, A1 primary,
A2 cyan, B1 mint, B2 amber, C1 oranye, default rose.

**Catatan:** `AppColors` adalah static mutable global yang di-apply lewat
`MaterialApp.builder` (`lib/main.dart:29-32`). Banyak warna gradient dan status
masih hardcoded di layar (mis. `#243462`, `#151D35`, `#3D2030`, `#D7DFFF`).

### 6.2 Tipografi

Tidak memakai font kustom; mengandalkan font sistem Material.

| Style | Ukuran | Weight | Catatan |
|---|---|---|---|
| headlineLarge | 30 | 800 | Hero |
| headlineMedium | 24 | 800 | Judul layar/hero |
| titleLarge | 19 | 700 | Section header |
| titleMedium | 15 | 700 | Judul kartu |
| bodyMedium | 14 / 1.5 | 400 | Teks isi |
| bodySmall | 12 / 1.45 | 400 | Teks sekunder |
| labelSmall | 11 / 0.6 | 600 | Label uppercase |

Banyak ukuran ad-hoc: 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 22, 28, 34,
42. Ukuran 9–11 px dipakai untuk hint rating, badge, label hero, dan metadata.

### 6.3 Spacing, radius, elevasi

- Padding layar: 20 kiri/kanan; atas 8–14; bawah 28–32.
- Gap vertikal: 8, 10, 12, 14, 16, 18, 20, 22, 24.
- Radius: 7, 8, 10, 11, 12, 13, 14, 16, 20, 22, 24, 26.
- Card default radius 20, padding 18.
- GradientPanel radius 24 + shadow blur 28 offset (0,12).
- Hampir semua kartu elevation 0, mengandalkan border tipis dan warna surface.

### 6.4 Komponen bersama

Ada di `lib/widgets/common.dart`:

- `AppCard` — kartu dasar dengan opsi gradient, color, border, onTap + haptic.
- `LevelChip` — badge level A0–C2, varian compact.
- `SectionHeader` — judul + subtitle + trailing.
- `GradientPanel` — panel hero dengan shadow.
- `StatBox` — ikon + nilai + label.
- `ProgressLine` — progress bar tipis.
- `ToolTile` — kartu tool dengan ikon, badge, judul, subtitle.
- `EmptyState` — ikon, judul, pesan, aksi.
- `showSnack` — snackbar standar.

Komponen yang belum terstandar: tombol rating SRS, bubble dialog, kartu opsi
kuis, kartu statistik ringkasan, tile checklist drama, panel hasil Hangul.

### 6.5 Ikon & brand

- Material Icons (rounded/outlined).
- Logo in-app: kotak gradient dengan huruf `한`.
- App icon: `ㅎ`, adaptive background `#3B4BC2`, foreground & monochrome tersedia.
- Emoji dipakai sebagai ikon: `🔥` streak, `🇰🇷` K-Drama.
- Tidak ada logo wordmark, ilustrasi, foto, atau maskot.
- Nama brand tidak konsisten di ekosistem: Sinau Korea (app), volingo
  (repo/applicationId/APK lama), sinau-korea (repo GitHub).

### 6.6 Motion & feedback

- Transisi utama memakai `MaterialPageRoute` default.
- `AnimatedContainer` 220 ms untuk kartu review.
- `ProgressLine` tanpa animasi nilai.
- Haptic terpusat (`lib/services/haptics.dart`): selection, light, medium,
  success, error; bisa dimatikan.
- Tidak ada audio, getaran kustom, atau animasi hasil kuis.
- Tidak ada penghormatan terhadap "reduce motion".

---

## 7. Pola Interaksi & Copywriting

### Pola interaksi

- Hampir semua kartu dapat diketuk (`AppCard.onTap`) dengan haptic selection.
- Aksi utama memakai `FilledButton` tinggi 52; aksi sekunder `OutlinedButton`.
- `SnackBar` floating untuk konfirmasi singkat dan undo rating.
- `showSnack` selalu menghapus snackbar sebelumnya.
- Bottom sheet, dialog modal, dan swipe action tidak dipakai.
- Tidak ada pull-to-refresh; review punya tombol refresh.
- Tidak ada pencarian global, filter lanjutan, atau sort.

### Nada copy

- Bahasa Indonesia santai-instruktif: "Konsistensi > intensitas.",
  "Nonton dengan tujuan, bukan sekadar binge."
- Istilah teknis ditampilkan ke pengguna: SRS, SM-2, SHA-256, interval,
  "kartu jatuh tempo".
- Campuran bahasa Inggris: "FLASHCARD", "K-DRAMA LEARNING METHOD",
  "7 TOOLS INTI", "Grammar lookup", "SOAL & QUIZ".
- Banyak penjelasan panjang di kartu (mis. aturan latihan kilat, info update),
  menambah kepadatan layar.

---

## 8. Temuan UX & Prioritas

Severity: **Tinggi** = menghambat loop belajar atau kepercayaan; **Sedang** =
mengganggu efisiensi/kejelasan; **Rendah** = polish.

| # | Severity | Temuan | Dampak | Bukti |
|---|---|---|---|---|
| 1 | Tinggi | Home terlalu padat dan panjang (hero, 4 stat, target, review, carousel, frasa, 4 tool, footer) | Pengguna tidak tahu harus mulai dari mana; CTA utama bersaing | `home_screen.dart:41-560` |
| 2 | Tinggi | Tidak ada onboarding/placement test | Pengguna baru langsung masuk dashboard; 10 kartu SRS sudah due karena seed | `app_state.dart:185-190`, tidak ada layar onboarding |
| 3 | Tinggi | Loop belajar terfragmentasi: materi, kuis, SRS, bank kesalahan di permukaan berbeda | Retensi dan rasa progres lemah | `lesson_screen`, `review_screen`, `question_bank` |
| 4 | Tinggi | Tidak ada audio/TTS/listening/speaking/writing | Aplikasi bahasa tanpa mendengar dan berbicara | README bagian batasan |
| 5 | Tinggi | Tidak ada export/import/reset progres di UI | Risiko kehilangan data; migrasi signing terhambat | `resetProgress` ada di `app_state.dart:442` tapi tidak dipanggil layar mana pun |
| 6 | Tinggi | Review tab tidak punya beranda deck/forecast/statistik | Pengguna tidak bisa memahami beban review | `review_screen.dart` langsung sesi |
| 7 | Tinggi | Tidak ada pengingat/notifikasi SRS | Review hanya terjadi saat app dibuka | Tidak ada dependensi notifikasi |
| 8 | Sedang | Entry point ganda di Home dan Latihan | Navigasi terasa berulang, ruang Home terbuang | `home_screen.dart:484-553`, `practice_screen.dart:24-74` |
| 9 | Sedang | Label dan metadata 9–11 px | Sulit dibaca, gagal di font besar | `review_screen.dart:349-355`, `home_screen.dart:159-167` |
| 10 | Sedang | Status hanya dibedakan warna (benar/salah, level, rating) | Tidak aksesibel untuk color blind | `quiz_screen.dart:264-319`, `LevelChip` |
| 11 | Sedang | Banyak hardcoded color/gradient di luar token | Tema tidak konsisten saat redesign | `home_screen`, `roadmap_screen`, `drama_screen`, `update_banner` |
| 12 | Sedang | `GridView` dengan `childAspectRatio: 1.02` dan tinggi tetap | Berpotensi overflow saat font 200% | `practice_screen.dart:155-171`, `root_shell.dart:229` |
| 13 | Sedang | Tidak ada state loading/error global atau offline indicator | Update gagal terasa seperti bug; tidak ada status koneksi | `update_banner.dart:31-33` |
| 14 | Sedang | Copy teknis (SRS, SM-2, SHA-256) tanpa penjelasan progresif | Beban kognitif untuk pemula | `review_screen.dart`, `update_screen.dart` |
| 15 | Sedang | Nama fitur "Latihan Kilat" mudah disalahartikan sebagai simulasi TOPIK | Ekspektasi salah | `mock_test_screen.dart:70-71` |
| 16 | Sedang | Tidak ada pencarian global; grammar search hanya lokal | Sulit menemukan konten | `grammar_screen.dart:43-50` |
| 17 | Rendah | Emoji sebagai ikon fungsional (🔥, 🇰🇷) | Tidak konsisten antar perangkat | `home_screen.dart:112`, `drama_screen.dart:32` |
| 18 | Rendah | Brand tidak konsisten (Sinau Korea vs volingo) | Identitas melemah saat redesign | `README.md`, `pubspec.yaml`, `applicationId` |
| 19 | Rendah | Banyak radius berbeda (7–26) | Visual terasa kurang disiplin | `common.dart`, layar |
| 20 | Rendah | `IndexedStack` menjaga state tab, tetapi sesi review bisa "nyangkut" di ringkasan | Perilaku tab tidak terduga | `root_shell.dart:61`, `review_screen.dart` |

### Kekuatan yang harus dipertahankan

- Offline-first dan tanpa login: cepat, privat, sederhana.
- Loop SRS nyata dengan rating 4 tingkat dan undo.
- Kesalahan kuis terhubung ke SRS dan bank kesalahan.
- Kurikulum A0–C2 dengan konten Indonesia–Korea yang konsisten.
- Dark/light mode sudah ada dan heading sudah eksplisit.
- Haptic feedback terpusat dan bisa dimatikan.
- Pembaruan APK dengan verifikasi ukuran + SHA-256.
- Komponen dasar (`AppCard`, `LevelChip`, `SectionHeader`) sudah terpusat.

---

## 9. Aksesibilitas

| Area | Kondisi | Rekomendasi |
|---|---|---|
| Kontras | Palet utama cukup, tetapi teks muted 11 px di atas gradient bisa rendah | Uji WCAG AA (4.5:1), naikkan ukuran minimum |
| Ukuran teks | 9–11 px untuk hint, badge, metadata | Minimum 12 px; hint 12–13 px |
| Dynamic type | Layout memakai tinggi/aspect ratio tetap | Ganti ke layout intrinsik; uji 200% |
| Touch target | IconButton compact, tombol rating kecil | Minimum 44×44 dp |
| Semantics | Hampir tidak ada `Semantics`/label untuk kartu kustom | Tambahkan label, hint, dan urutan fokus |
| Status warna | Benar/salah, level, rating hanya lewat warna | Tambahkan ikon + teks |
| Emoji | Emoji sebagai ikon | Ganti ikon vektor atau beri label |
| Motion | Tidak ada preferensi reduce motion | Hormati `MediaQuery.disableAnimations` |
| Bahasa | Campur Indonesia/Inggris/Korea | Tetapkan bahasa UI Indonesia; istilah asing diberi konteks |
| Keyboard/switch | Belum diuji | Uji TalkBack dan switch access |

---

## 10. Rekomendasi Redesign

### 10.1 Tetapkan strategi produk dulu

Pilih satu loop utama yang menjadi pusat redesign:

**Opsi A — "TOPIK companion" (disarankan)**
- Loop: rencana harian → modul → kuis → review SRS → progres level.
- Latihan adalah pendukung, bukan tujuan.
- Home menjadi "Hari Ini", bukan direktori fitur.

**Opsi B — "Korean for K-Drama fans"**
- Loop: frasa drama → dialog → SRS → rekomendasi tontonan.
- Kurikulum formal menjadi jalur sekunder.
- Membutuhkan konten audio/video dan identitas visual yang lebih pop.

**Opsi C — "Toolbox belajar"**
- Pertahankan banyak tools, tetapi perbaiki pengelompokan dan pencarian.
- Risiko: tetap terasa seperti kumpulan fitur.

### 10.2 IA baru yang diusulkan (4 tab)

```
Hari Ini
├── Kartu "Lanjut belajar" (satu CTA utama)
├── Ring target harian + streak
├── Review jatuh tempo (mulai sesi)
├── 1 rekomendasi latihan kontekstual
└── Frasa hari ini (opsional, collapsible)

Belajar
├── Jalur A0–C2 (roadmap)
├── Modul: materi → kuis → ringkasan
└── Pencarian materi/kosakata/grammar

Review
├── Ringkasan deck: Baru / Belajar / Matang / Jatuh tempo
├── Forecast 7 hari
├── Mulai review
├── Ulangi kesalahan
├── Jelajah kartu
└── Riwayat sesi

Progres & Profil
├── Mastery per level
├── Aktivitas mingguan / heatmap
├── Akurasi per skill
├── Pengaturan belajar (target, pengingat, audio)
├── Data: export/import/reset
├── Tema & haptic
└── Pembaruan & tentang
```

Alternatif 5 tab: `Hari Ini`, `Belajar`, `Review`, `Latihan`, `Profil`.
Latihan tetap ada sebagai tab jika ingin mempertahankan 7 tools sebagai nilai jual.

### 10.3 Redesign Home

- Satu hero CTA: "Lanjut: <judul modul>" + estimasi waktu + progress modul.
- Ring/linear target harian yang besar dan mudah dipindai.
- Kartu review dengan jumlah due dan estimasi menit.
- Satu kartu rekomendasi latihan, bukan empat.
- Pindahkan 4 statistik ke tab Progres.
- Pindahkan direktori tools ke tab Latihan/Belajar.
- Update banner jangan memakan slot hero; jadikan banner tipis di bawah app bar
  atau badge di Profil.

### 10.4 Redesign loop modul

- Tambahkan daftar isi modul dan progress per section.
- Pisahkan "materi" dan "latihan" dengan checkpoint di tengah.
- Setelah kuis: ringkasan yang menautkan langsung ke "Review kartu yang salah".
- Tandai kosakata yang sudah dikuasai vs perlu review.
- Tambahkan audio/TTS dan tombol putar lambat bila memungkinkan.
- Simpan posisi baca terakhir.

### 10.5 Redesign Review

- Beranda review: jumlah Baru/Belajar/Matang/Due, forecast 7 hari, CTA.
- Kartu sesi: lebih besar, tanpa distraksi, progress jelas.
- Rating: tampilkan interval hasil (mis. "Besok", "3 hari", "1 minggu") dan
  penjelasan singkat; dukung undo.
- Requeue "Lagi" di sesi yang sama, bukan hanya 10 menit kemudian.
- Ringkasan: akurasi, kartu sulit, CTA review kesalahan.
- Jelajah kartu: cari, filter level/status, lihat riwayat.
- Tambahkan pengingat lokal (opsional, izin notifikasi).

### 10.6 Redesign Latihan

Kelompokkan berdasarkan skill, bukan tipe konten:

```
Kosakata   → Bank soal, Latihan kilat, Kartu salah
Tata bahasa → Grammar lookup, kuis pola
Membaca    → Bacaan bertingkat, kuis pemahaman
Mendengar  → (belum ada; peluang baru)
Berbicara  → (belum ada; peluang baru)
Menulis    → (belum ada; peluang baru)
Praktis    → Dialog, K-Drama, Ketik Hangul
```

Setiap tool menampilkan estimasi durasi, level, dan hasil terakhir.

### 10.7 Redesign Pengaturan & data

- Kelompokkan: Belajar, Tampilan, Suara & haptic, Data, Tentang.
- Tambahkan target harian yang bisa diubah.
- Tambahkan export/import JSON dan reset dengan konfirmasi.
- Tampilkan ukuran data dan tanggal backup terakhir.
- Tautkan bantuan, changelog, dan kebijakan privasi.
- Pisahkan "Pembaruan aplikasi" dari pengaturan umum jika sering dipakai.

### 10.8 Arah visual

- Pertahankan indigo–mint sebagai brand, tetapi kurangi jumlah gradient.
- Satu hero gradient per layar maksimum.
- Skala radius: 8 (chip), 12 (input), 16 (card), 24 (hero/sheet).
- Skala spacing 4/8/12/16/20/24/32.
- Skala tipografi: 12, 14, 16, 20, 24, 30; weight 400/600/700/800.
- Gunakan font yang mendukung Hangul dengan baik (mis. Noto Sans KR /
  Pretendard untuk Latin + fallback sistem) dan uji rendering.
- Sediakan token warna di `ThemeExtension`, bukan static global.
- Standarkan komponen: `AppButton`, `AppChip`, `AppStat`, `AppListTile`,
  `AppEmptyState`, `AppSheet`, `AppDialog`.
- Tambahkan ilustrasi/ikon konsisten untuk level dan skill.
- Ganti emoji fungsional dengan ikon.

### 10.9 Motion & feedback

- Transisi halaman 200–250 ms dengan curve standar.
- Animasi progress dan hasil kuis yang halus.
- Kartu review flip 180–220 ms.
- Haptic berbeda untuk benar/salah/rating.
- Hormati reduce motion; sediakan toggle animasi jika perlu.

---

## 11. Prioritas Redesign

### Fase 0 — Fondasi (1–2 minggu)

1. Tetapkan brand final dan bahasa UI.
2. Audit konten dan istilah (SRS, TOPIK, level).
3. Definisikan token warna, tipografi, spacing, radius.
4. Buat component library dasar.
5. Putuskan IA final (4 atau 5 tab).

### Fase 1 — Loop inti (2–4 minggu)

1. Onboarding + placement + target harian.
2. Home "Hari Ini".
3. Lesson → quiz → summary → review yang terhubung.
4. Review hub + sesi yang lebih baik.
5. Progress tab dasar.

### Fase 2 — Latihan & konten (2–4 minggu)

1. Kelompokkan latihan per skill.
2. Tingkatkan bank soal dan feedback.
3. Tambahkan audio/TTS jika memungkinkan.
4. Tambahkan pencarian global.

### Fase 3 — Kepercayaan & retensi (1–2 minggu)

1. Export/import/reset.
2. Pengingat lokal.
3. Accessibility pass (font 200%, TalkBack, touch target).
4. Update flow yang lebih tenang.

### Fase 4 — Diferensiasi (opsional)

1. Listening/speaking/writing.
2. Simulasi TOPIK.
3. Personalisasi rekomendasi.
4. Gamifikasi yang lebih kaya (achievement, quest).

---

## 12. Batasan Teknis yang Harus Dihormati

| Batasan | Implikasi redesign |
|---|---|
| Offline-first, tanpa login | Jangan desain fitur yang bergantung server; sinkronisasi opsional |
| Data di SharedPreferences schema v2 | Perlu migrasi aman; jangan ubah key tanpa fallback |
| `applicationId` tetap | Brand baru tidak boleh mengubah package id |
| Update via APK + signing key | Alur update harus tetap jelas; jangan sembunyikan |
| Android-only | Fokus Material 3; belum perlu iOS |
| Tanpa audio aset saat ini | Fitur listening butuh pipeline konten baru |
| 85 kosakata, 12 modul, 21 grammar, 8 dialog, 5 bacaan, 18 frasa | Redesign tidak bisa mengandalkan volume konten |
| Tanpa notifikasi | Retensi harus dibantu pengingat lokal |
| Tanpa export/import | Harus ditambahkan sebelum redesign data |

---

## 13. Metrik Keberhasilan Redesign

- **Activation:** % pengguna baru yang menyelesaikan 1 modul dalam sesi pertama.
- **Time to first value:** waktu dari buka app ke jawaban kuis pertama.
- **D1/D7 retention:** kembali belajar dalam 1 dan 7 hari.
- **Daily goal completion:** % hari dengan target harian tercapai.
- **Review completion:** % sesi review yang diselesaikan.
- **Lesson pass rate:** distribusi skor kuis modul.
- **Mistake recurrence:** % kesalahan yang berulang setelah review.
- **Accessibility:** lolos uji font 200%, TalkBack, dan kontras AA.
- **Crash-free sessions** dan keberhasilan update APK.

---

## 14. Referensi Aset

- Screenshot audit: `dist/audit/01-home-light.png`, `02-home-dark.png`,
  `03-roadmap.png`, `04-review.png`, `05-practice.png`, `06-settings-dark.png`,
  `10-home-light.png`, `11-roadmap-light.png`, `12-review-light.png`,
  `13-practice-light.png`, `14-lesson-light.png`, `15-settings-light.png`,
  `16-settings-dark.png`.
- Tema & token: `lib/theme.dart`.
- Komponen: `lib/widgets/common.dart`.
- State & progres: `lib/services/app_state.dart`.
- Data kurikulum: `lib/data/`.
- Alur kuis: `lib/screens/quiz_screen.dart`, `lib/services/quiz_factory.dart`.
- Dokumen rilis: `docs/RELEASING.md`, `docs/SIGNING.md`.

---

## 15. Pertanyaan Terbuka untuk Keputusan Redesign

1. Apakah brand final tetap **Sinau Korea**, atau kembali ke **V olingo**?
2. Apakah target utama pemula TOPIK, penggemar K-Drama, atau pembelajar mandiri?
3. Apakah redesign mempertahankan 4 tab atau menambah tab Latihan/Profil?
4. Apakah audio/TTS masuk scope redesign, atau fase terpisah?
5. Apakah perlu login/sinkronisasi, atau tetap offline murni?
6. Apakah fitur update APK tetap dipertahankan, atau pindah ke Play Store?
7. Apakah konten akan diperbanyak sebelum redesign visual?
8. Apakah perlu dukungan bahasa Inggris, atau tetap Indonesia?
9. Apakah gamifikasi (XP, streak, achievement) dipertahankan atau disederhanakan?
10. Apakah redesign harus kompatibel dengan data progres lama tanpa migrasi manual?
