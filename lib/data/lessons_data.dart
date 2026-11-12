import '../models.dart';

class LevelMeta {
  final String code;
  final String name;
  final String exam;
  final String description;
  const LevelMeta(this.code, this.name, this.exam, this.description);
}

const List<LevelMeta> roadmapLevels = [
  LevelMeta('A0', 'Pemula Nol', 'Hangul', 'Kenalan huruf & bunyi. Fondasi sebelum semua level.'),
  LevelMeta('A1', 'Dasar', 'TOPIK 1', 'Kalimat sopan, sapaan, angka, dan kehidupan sehari-hari.'),
  LevelMeta('A2', 'Pra-Menengah', 'TOPIK 2', 'Situasi nyata: transportasi, belanja, kesehatan, rencana.'),
  LevelMeta('B1', 'Menengah', 'TOPIK 3', 'Opini, pengalaman, pekerjaan, dan wawancara.'),
  LevelMeta('B2', 'Menengah Atas', 'TOPIK 4', 'Isu sosial, argumen, sebab-akibat formal.'),
  LevelMeta('C1', 'Mahir', 'TOPIK 5', 'Analisis, sudut pandang, teks berita dan akademik.'),
  LevelMeta('C2', 'Sangat Mahir', 'TOPIK 6', 'Nuansa, wacana, dan pemakaian bahasa tingkat native.'),
];

const List<Lesson> koreanLessons = [
  Lesson(
    id: 'a0-1',
    level: 'A0',
    title: 'Hangul & Sapaan Pertama',
    description: 'Baca huruf Korea dan pakai sapaan sopan di hari pertama.',
    sections: [
      LessonSection('Vokal dasar', 'Hangul bukan huruf gambar, tapi sistem bunyi. Mulai dari 6 vokal inti: ㅏ (a), ㅓ (eo), ㅗ (o), ㅜ (u), ㅡ (eu), ㅣ (i). Vokal tambahan dibentuk dari kombinasi ini.', [
        Example('아', 'a'),
        Example('어', 'eo'),
        Example('오', 'o'),
        Example('우', 'u'),
        Example('으', 'eu'),
        Example('이', 'i'),
      ]),
      LessonSection('Konsonan dasar', '14 konsonan dasar: ㄱ ㄴ ㄷ ㄹ ㅁ ㅂ ㅅ ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ. Gabungkan dengan vokal menjadi satu blok suku kata.', [
        Example('가', 'ga'),
        Example('나', 'na'),
        Example('다', 'da'),
        Example('라', 'ra'),
        Example('마', 'ma'),
        Example('사', 'sa'),
        Example('자', 'ja'),
        Example('하', 'ha'),
      ]),
      LessonSection('Sapaan yang langsung kepakai', 'Bentuk -요/-니다 adalah bahasa sopan. Pakai ini dulu sampai kamu paham 반말 (bahasa santai).', [
        Example('안녕하세요.', 'Halo.'),
        Example('감사합니다.', 'Terima kasih.'),
        Example('죄송합니다.', 'Maaf.'),
        Example('안녕히 가세요.', 'Selamat jalan.'),
        Example('네, 맞아요.', 'Iya, benar.'),
      ]),
    ],
  ),
  Lesson(
    id: 'a0-2',
    level: 'A0',
    title: 'Batchim & Kata Benda',
    description: 'Konsonan penutup, pola 이에요/예요, dan tanya dasar.',
    sections: [
      LessonSection('Batchim (받침)', 'Batchim adalah konsonan penutup di bawah suku kata. Contoh: 밥 (bap), 물 (mul), 집 (jip). Bunyinya bisa berubah saat bertemu suku kata berikutnya.', [
        Example('밥', 'bap — nasi'),
        Example('물', 'mul — air'),
        Example('집', 'jip — rumah'),
        Example('사람', 'saram — orang'),
        Example('이름', 'ireum — nama'),
      ]),
      LessonSection('이에요 / 예요', 'Setelah konsonan pakai 이에요, setelah vokal pakai 예요. Artinya "adalah".', [
        Example('저는 학생이에요.', 'Saya adalah pelajar.'),
        Example('이거는 물이에요.', 'Ini adalah air.'),
        Example('제 이름은 민수예요.', 'Nama saya Minsu.'),
      ]),
      LessonSection('Kalimat tanya dasar', 'Naikkan intonasi di akhir kalimat. Kata tanya ditaruh di depan.', [
        Example('이름이 뭐예요?', 'Siapa namamu?'),
        Example('어디에 있어요?', 'Di mana?'),
        Example('밥 먹었어요?', 'Sudah makan?'),
      ]),
    ],
  ),
  Lesson(
    id: 'a1-1',
    level: 'A1',
    title: 'Kehidupan Sehari-hari',
    description: 'Kalimat sopan -아/어요 dan partikel inti.',
    sections: [
      LessonSection('Pola sopan -아/어요', 'Bentuk paling sering dipakai. Vokal akhir menentukan -아요 atau -어요; 하다 menjadi 해요.', [
        Example('가다 → 가요', 'pergi'),
        Example('먹다 → 먹어요', 'makan'),
        Example('오다 → 와요', 'datang'),
        Example('하다 → 해요', 'melakukan'),
      ]),
      LessonSection('Partikel 은/는 dan 이/가', '은/는 menandai topik, 이/가 menandai subjek. 을/를 menandai objek.', [
        Example('저는 학생이에요.', 'Saya (topik) pelajar.'),
        Example('친구가 와요.', 'Teman (subjek) datang.'),
        Example('밥을 먹어요.', 'Saya makan nasi.'),
      ]),
      LessonSection('Kalimat harian', 'Mulai dari pola sederhana: subjek + tempat + kata kerja.', [
        Example('저는 학교에 가요.', 'Saya pergi ke sekolah.'),
        Example('친구를 만나요.', 'Saya bertemu teman.'),
        Example('집에 있어요.', 'Saya di rumah.'),
      ]),
    ],
  ),
  Lesson(
    id: 'a1-2',
    level: 'A1',
    title: 'Waktu, Film & Makanan',
    description: 'Angka, bentuk lampau, dan negasi untuk cerita harian.',
    sections: [
      LessonSection('Angka Sino-Korea 1–10', 'Dipakai untuk tanggal, uang, dan nomor. 일 이 삼 사 오 육 칠 팔 구 십.', [
        Example('한 시', 'jam satu'),
        Example('세 시', 'jam tiga'),
        Example('이천이십육 년', 'tahun 2026'),
      ]),
      LessonSection('Bentuk lampau -았/었어요', 'Ganti akhiran -아/어요 menjadi -았/었어요 untuk kejadian yang sudah selesai.', [
        Example('어제 영화를 봤어요.', 'Kemarin saya menonton film.'),
        Example('밥을 먹었어요.', 'Saya sudah makan.'),
        Example('학교에 갔어요.', 'Saya pergi ke sekolah.'),
      ]),
      LessonSection('Negasi 안 dan 못', '안 = tidak (mau), 못 = tidak bisa. Letakkan sebelum kata kerja.', [
        Example('오늘은 안 가요.', 'Hari ini saya tidak pergi.'),
        Example('커피를 못 마셔요.', 'Saya tidak bisa minum kopi.'),
        Example('시간이 없어요.', 'Tidak ada waktu.'),
      ]),
    ],
  ),
  Lesson(
    id: 'a2-1',
    level: 'A2',
    title: 'Perjalanan & Transaksi',
    description: 'Partikel tempat, rencana, transportasi, dan belanja.',
    sections: [
      LessonSection('에 vs 에서', '에 = arah/tujuan atau keberadaan. 에서 = tempat aksi berlangsung atau asal.', [
        Example('학교에 가요.', 'Pergi ke sekolah.'),
        Example('학교에서 공부해요.', 'Belajar di sekolah.'),
        Example('집에 있어요.', 'Ada di rumah.'),
      ]),
      LessonSection('Rencana -(으)ㄹ 거예요', 'Bentuk masa depan sopan. Akhiran konsonan pakai 을 거예요, vokal pakai ㄹ 거예요.', [
        Example('내일 여행을 갈 거예요.', 'Besok saya akan pergi traveling.'),
        Example('뭐 먹을 거예요?', 'Mau makan apa?'),
      ]),
      LessonSection('Di jalan dan toko', 'Frasa penyelamat saat traveling.', [
        Example('지하철역이 어디예요?', 'Di mana stasiun subway?'),
        Example('이거 얼마예요?', 'Ini berapa harganya?'),
        Example('병원에 가야 해요.', 'Saya harus ke rumah sakit.'),
      ]),
    ],
  ),
  Lesson(
    id: 'a2-2',
    level: 'A2',
    title: 'Keinginan & Perasaan',
    description: 'Bilang mau, memberi alasan, dan mengekspresikan perasaan.',
    sections: [
      LessonSection('-고 싶다 (ingin)', 'Tambahkan -고 싶다 ke stem kata kerja: 가고 싶어요 = ingin pergi.', [
        Example('한국에 가고 싶어요.', 'Saya ingin pergi ke Korea.'),
        Example('커피를 마시고 싶어요.', 'Saya ingin minum kopi.'),
      ]),
      LessonSection('Alasan -아/어서', 'Menyatakan sebab yang wajar. Tidak dipakai untuk kalimat perintah.', [
        Example('비가 와서 집에 있었어요.', 'Karena hujan, saya di rumah.'),
        Example('피곤해서 일찍 잤어요.', 'Karena lelah, saya tidur lebih awal.'),
      ]),
      LessonSection('Perasaan & kemampuan', 'Pola ini muncul terus di dialog sehari-hari.', [
        Example('기분이 좋아요.', 'Perasaan saya baik.'),
        Example('한국어를 조금 배웠어요.', 'Saya belajar sedikit bahasa Korea.'),
        Example('잘 모르겠어요.', 'Saya kurang tahu.'),
      ]),
    ],
  ),
  Lesson(
    id: 'b1-1',
    level: 'B1',
    title: 'Opini, Budaya & Kegagalan',
    description: 'Bandingkan ide, beri alasan, dan bicara soal pengalaman.',
    sections: [
      LessonSection('Kontras -지만 & -는데', '-지만 = tapi. -는데 = latar/ kontras yang lebih halus.', [
        Example('한국어는 어렵지만 재미있어요.', 'Bahasa Korea sulit tapi menyenangkan.'),
        Example('비가 오는데 우산이 없어요.', 'Hujan turun, tapi saya tidak punya payung.'),
      ]),
      LessonSection('Alasan -기 때문에', 'Bentuk alasan yang tegas dan cocok untuk tulisan.', [
        Example('시험이 있기 때문에 공부해요.', 'Karena ada ujian, saya belajar.'),
        Example('관심이 있기 때문에 배워요.', 'Karena tertarik, saya belajar.'),
      ]),
      LessonSection('Opini & budaya', 'Gunakan -다고 생각해요 untuk menyampaikan pendapat.', [
        Example('저는 한국 문화가 중요하다고 생각해요.', 'Saya pikir budaya Korea itu penting.'),
        Example('실수해도 괜찮아요.', 'Tidak apa-apa membuat kesalahan.'),
        Example('좋은 경험이었어요.', 'Itu pengalaman yang baik.'),
      ]),
    ],
  ),
  Lesson(
    id: 'b1-2',
    level: 'B1',
    title: 'Kerja & Wawancara',
    description: 'Spekulasi, kemampuan, dan frasa wawancara kerja.',
    sections: [
      LessonSection('-는 것 같다 (sepertinya)', 'Menyatakan dugaan halus. Tidak perlu yakin 100%.', [
        Example('비가 오는 것 같아요.', 'Sepertinya hujan turun.'),
        Example('이해한 것 같아요.', 'Sepertinya saya sudah paham.'),
      ]),
      LessonSection('Kemampuan -(으)ㄹ 수 있다/없다', 'Bisa atau tidak bisa melakukan sesuatu.', [
        Example('한국어를 조금 말할 수 있어요.', 'Saya bisa bicara bahasa Korea sedikit.'),
        Example('내일은 갈 수 없어요.', 'Besok saya tidak bisa pergi.'),
      ]),
      LessonSection('Frasa wawancara', 'Jawab dengan struktur: pernyataan + alasan + contoh.', [
        Example('자기소개를 해 주세요.', 'Tolong perkenalkan diri Anda.'),
        Example('제 강점은 책임감이에요.', 'Kekuatan saya adalah rasa tanggung jawab.'),
        Example('회사에 지원한 이유가 뭐예요?', 'Apa alasan Anda melamar ke perusahaan ini?'),
      ]),
    ],
  ),
  Lesson(
    id: 'b2-1',
    level: 'B2',
    title: 'Isu Sosial & Perubahan',
    description: 'Bicara data, dampak, dan solusi dengan pola formal.',
    sections: [
      LessonSection('-게 되다 (menjadi/akhirnya)', 'Perubahan keadaan atau hasil yang tidak sepenuhnya direncanakan.', [
        Example('한국에 가게 됐어요.', 'Akhirnya saya jadi pergi ke Korea.'),
        Example('일을 시작하게 되었어요.', 'Saya akhirnya mulai bekerja.'),
      ]),
      LessonSection('Perubahan & dampak', 'Kosakata statistik dan kebijakan.', [
        Example('인구가 증가하고 있어요.', 'Populasi sedang meningkat.'),
        Example('정책이 사회에 큰 영향을 줬어요.', 'Kebijakan itu memberi dampak besar pada masyarakat.'),
      ]),
      LessonSection('Solusi & lingkungan', 'Pola -아/어야 해요 = harus.', [
        Example('문제를 해결해야 해요.', 'Kita harus menyelesaikan masalah.'),
        Example('환경을 보호해야 해요.', 'Kita harus melindungi lingkungan.'),
      ]),
    ],
  ),
  Lesson(
    id: 'b2-2',
    level: 'B2',
    title: 'Menyusun Argumen',
    description: 'Sebab-akibat formal dan struktur pendapat yang rapi.',
    sections: [
      LessonSection('-에 따라 / 따라서', 'Menyatakan hubungan sebab-akibat atau mengikuti sesuatu.', [
        Example('계획에 따라 진행해요.', 'Kami berjalan sesuai rencana.'),
        Example('따라서 새로운 전략이 필요해요.', 'Oleh karena itu, strategi baru diperlukan.'),
      ]),
      LessonSection('-더라도 (meskipun)', 'Mengakui kemungkinan buruk, lalu tetap melanjutkan.', [
        Example('힘들더라도 포기하지 마세요.', 'Meskipun berat, jangan menyerah.'),
        Example('늦더라도 반드시 와 주세요.', 'Meskipun terlambat, pastikan datang.'),
      ]),
      LessonSection('Kerangka argumen', 'Tanda urutan membuat pendapat terdengar terstruktur.', [
        Example('첫째, 근거가 필요해요.', 'Pertama, kita butuh bukti.'),
        Example('반면에 다른 관점도 있어요.', 'Di sisi lain, ada sudut pandang lain.'),
        Example('결론적으로 말하면, 중요해요.', 'Kesimpulannya, itu penting.'),
      ]),
    ],
  ),
  Lesson(
    id: 'c1-1',
    level: 'C1',
    title: 'Analisis & Sudut Pandang',
    description: 'Teks berita, analisis, dan bahasa akademik.',
    sections: [
      LessonSection('-에도 불구하고 (meskipun)', 'Bentuk formal untuk mengakui hambatan.', [
        Example('어려움에도 불구하고 계속했어요.', 'Meskipun ada kesulitan, saya melanjutkan.'),
      ]),
      LessonSection('-는 반면에 (sebaliknya)', 'Membandingkan dua sisi secara seimbang.', [
        Example('도시는 편리한 반면에 복잡해요.', 'Kota itu praktis, sebaliknya juga rumit.'),
      ]),
      LessonSection('Menyatakan analisis', 'Kosakata untuk membedah data dan kebijakan.', [
        Example('이 결과는 많은 점을 시사해요.', 'Hasil ini mengisyaratkan banyak hal.'),
        Example('다른 관점에서 볼 필요가 있어요.', 'Kita perlu melihatnya dari sudut pandang lain.'),
        Example('근거가 부족해요.', 'Buktinya kurang.'),
      ]),
    ],
  ),
  Lesson(
    id: 'c2-1',
    level: 'C2',
    title: 'Nuansa & Wacana',
    description: 'Bicara implikasi, asumsi, dan nuansa tingkat native.',
    sections: [
      LessonSection('-는 셈이다 (bisa dibilang)', 'Menyimpulkan bahwa sesuatu secara praktis setara dengan hal lain.', [
        Example('사실상 같은 셈이에요.', 'Secara praktis, itu sama saja.'),
      ]),
      LessonSection('-기 마련이다 (pasti akan)', 'Menyatakan kecenderungan yang wajar terjadi.', [
        Example('노력하면 발전하기 마련이에요.', 'Kalau berusaha, pasti akan berkembang.'),
      ]),
      LessonSection('Nuansa & wacana', 'Kosakata untuk teks opini dan diskusi serius.', [
        Example('표현이 함축적이에요.', 'Ekspresinya implisit.'),
        Example('두 가치가 상충해요.', 'Dua nilai itu bertentangan.'),
        Example('정책의 함의를 분석했어요.', 'Saya menganalisis implikasi kebijakan.'),
      ]),
    ],
  ),
];
