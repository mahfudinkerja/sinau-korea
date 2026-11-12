import '../models.dart';

const List<GrammarPoint> koreanGrammar = [
  GrammarPoint(
    pattern: '은/는',
    level: 'A1',
    formula: 'Kata benda + 은 (batchim) / 는 (vokal)',
    explanation: 'Menandai topik kalimat — "kalau bicara tentang X". Sering dipakai untuk kontras dan informasi lama.',
    examples: [
      Example('저는 학생이에요.', 'Saya adalah pelajar.'),
      Example('오늘은 추워요.', 'Hari ini dingin.'),
    ],
    pitfall: 'Jangan samakan dengan 이/가. 은/는 topik, 이/가 subjek; pilihan mengubah nuansa.',
  ),
  GrammarPoint(
    pattern: '이/가',
    level: 'A1',
    formula: 'Kata benda + 이 (batchim) / 가 (vokal)',
    explanation: 'Menandai subjek, terutama informasi baru atau jawaban atas "siapa/apa".',
    examples: [
      Example('친구가 와요.', 'Teman datang.'),
      Example('누가 했어요? 제가 했어요.', 'Siapa yang melakukannya? Saya.'),
    ],
    pitfall: 'Pada kalimat "ada/tidak ada" (있다/없다), subjek hampir selalu memakai 이/가.',
  ),
  GrammarPoint(
    pattern: '을/를',
    level: 'A1',
    formula: 'Kata benda + 을 (batchim) / 를 (vokal)',
    explanation: 'Menandai objek langsung dari kata kerja transitif.',
    examples: [
      Example('밥을 먹어요.', 'Saya makan nasi.'),
      Example('영화를 봐요.', 'Saya menonton film.'),
    ],
    pitfall: 'Kata kerja seperti 가다, 오다, 있다 tidak mengambil objek, jadi jangan pakai 을/를.',
  ),
  GrammarPoint(
    pattern: '에 / 에서',
    level: 'A1',
    formula: 'Tempat + 에 (arah/keberadaan) · Tempat + 에서 (aksi/asal)',
    explanation: '에 untuk tujuan atau posisi; 에서 untuk tempat aktivitas berlangsung dan asal.',
    examples: [
      Example('학교에 가요.', 'Pergi ke sekolah.'),
      Example('학교에서 공부해요.', 'Belajar di sekolah.'),
    ],
    pitfall: 'Jangan bilang 학교에서 가요 untuk "pergi ke sekolah". Tujuan pakai 에.',
  ),
  GrammarPoint(
    pattern: '-아/어요',
    level: 'A1',
    formula: 'Stem + 아요 / 어요 (하다 → 해요)',
    explanation: 'Bentuk sopan sehari-hari untuk present dan future dekat.',
    examples: [
      Example('저는 한국어를 배워요.', 'Saya belajar bahasa Korea.'),
      Example('지금 집에 가요.', 'Sekarang saya pulang.'),
    ],
    pitfall: 'Vokal akhir menentukan 아요/어요. 먹다 → 먹어요, 가다 → 가요, 하다 → 해요.',
  ),
  GrammarPoint(
    pattern: '-았/었어요',
    level: 'A1',
    formula: 'Stem + 았어요 / 었어요 (하다 → 했어요)',
    explanation: 'Bentuk lampau sopan untuk kejadian yang sudah selesai.',
    examples: [
      Example('어제 영화를 봤어요.', 'Kemarin saya menonton film.'),
      Example('밥을 먹었어요.', 'Saya sudah makan.'),
    ],
    pitfall: 'Jangan menambahkan 아/어요 lagi setelah 았/었. Cukup 봤어요, bukan 봤어어요.',
  ),
  GrammarPoint(
    pattern: '-(으)ㄹ 거예요',
    level: 'A2',
    formula: 'Stem + ㄹ 거예요 (vokal) / 을 거예요 (batchim)',
    explanation: 'Rencana atau prediksi masa depan.',
    examples: [
      Example('내일 여행을 갈 거예요.', 'Besok saya akan pergi traveling.'),
      Example('무엇을 먹을 거예요?', 'Mau makan apa?'),
    ],
    pitfall: 'Untuk janji/kesepakatan gunakan -(으)ㄹ게요, bukan -(으)ㄹ 거예요.',
  ),
  GrammarPoint(
    pattern: '-고 싶다',
    level: 'A2',
    formula: 'Stem + 고 싶어요',
    explanation: 'Menyatakan keinginan pembicara. Subjek biasanya orang pertama.',
    examples: [
      Example('한국에 가고 싶어요.', 'Saya ingin pergi ke Korea.'),
      Example('커피를 마시고 싶어요.', 'Saya ingin minum kopi.'),
    ],
    pitfall: 'Untuk orang ketiga, jangan pakai -고 싶어요; gunakan -고 싶어하다.',
  ),
  GrammarPoint(
    pattern: '-아/어서',
    level: 'A2',
    formula: 'Stem + 아서 / 어서',
    explanation: 'Menyatakan alasan yang wajar atau urutan aksi.',
    examples: [
      Example('비가 와서 집에 있었어요.', 'Karena hujan, saya di rumah.'),
      Example('피곤해서 일찍 잤어요.', 'Karena lelah, saya tidur awal.'),
    ],
    pitfall: 'Tidak dipakai di kalimat perintah atau ajakan (pakai -(으)니까).',
  ),
  GrammarPoint(
    pattern: '-(으)니까',
    level: 'B1',
    formula: 'Stem + 으니까 (batchim) / 니까 (vokal)',
    explanation: 'Alasan yang menjadi dasar perintah, ajakan, atau penemuan.',
    examples: [
      Example('비가 오니까 우산을 가져가세요.', 'Karena hujan, bawa payung.'),
      Example('피곤하니까 좀 쉬어요.', 'Karena lelah, istirahatlah.'),
    ],
    pitfall: 'Tidak dipakai untuk perasaan pribadi di masa lalu seperti -아서.',
  ),
  GrammarPoint(
    pattern: '-지만',
    level: 'B1',
    formula: 'Stem + 지만',
    explanation: 'Menyatakan kontras: "tapi/meskipun".',
    examples: [
      Example('한국어는 어렵지만 재미있어요.', 'Bahasa Korea sulit tapi menyenangkan.'),
      Example('비싸지만 살 거예요.', 'Mahal tapi saya akan membelinya.'),
    ],
    pitfall: 'Jangan gabungkan 지만 dengan akhiran sopan di depan: bukan 어렵어요지만.',
  ),
  GrammarPoint(
    pattern: '-기 때문에',
    level: 'B1',
    formula: 'Stem + 기 때문에',
    explanation: 'Alasan formal dan tegas, cocok untuk tulisan atau presentasi.',
    examples: [
      Example('시험이 있기 때문에 공부해요.', 'Karena ada ujian, saya belajar.'),
      Example('관심이 있기 때문에 배워요.', 'Karena tertarik, saya belajar.'),
    ],
    pitfall: 'Bentuk ini lebih kaku dari -아서; hindari di percakapan santai.',
  ),
  GrammarPoint(
    pattern: '-(으)ㄴ/는 것 같다',
    level: 'B1',
    formula: 'Kata sifat + -(으)ㄴ 것 같다 · Kata kerja + -는 것 같다',
    explanation: 'Dugaan halus: "sepertinya".',
    examples: [
      Example('비가 오는 것 같아요.', 'Sepertinya hujan.'),
      Example('음식이 매운 것 같아요.', 'Sepertinya makanannya pedas.'),
    ],
    pitfall: 'Untuk kata sifat masa lalu gunakan -았/었던 것 같다, bukan -는 것 같다.',
  ),
  GrammarPoint(
    pattern: '-(으)ㄹ 수 있다/없다',
    level: 'B1',
    formula: 'Stem + ㄹ 수 있어요 / 을 수 있어요',
    explanation: 'Menyatakan kemampuan atau kemungkinan.',
    examples: [
      Example('한국어를 조금 말할 수 있어요.', 'Saya bisa bicara bahasa Korea sedikit.'),
      Example('내일은 갈 수 없어요.', 'Besok saya tidak bisa pergi.'),
    ],
    pitfall: 'Untuk "tidak tahu" gunakan 모르다, bukan 몰라요 수 없어요.',
  ),
  GrammarPoint(
    pattern: '-게 되다',
    level: 'B2',
    formula: 'Stem + 게 되다',
    explanation: 'Perubahan keadaan atau hasil yang terjadi tanpa direncanakan.',
    examples: [
      Example('한국에 가게 됐어요.', 'Akhirnya saya pergi ke Korea.'),
      Example('일을 시작하게 되었어요.', 'Saya akhirnya mulai bekerja.'),
    ],
    pitfall: 'Jangan pakai untuk keputusan yang jelas disengaja; gunakan -기로 하다.',
  ),
  GrammarPoint(
    pattern: '-(으)ㄹ수록',
    level: 'B2',
    formula: 'Stem + ㄹ수록 / 을수록',
    explanation: 'Semakin ... semakin ...',
    examples: [
      Example('배울수록 재미있어요.', 'Semakin belajar, semakin menyenangkan.'),
      Example('생각할수록 복잡해요.', 'Semakin dipikir, semakin rumit.'),
    ],
    pitfall: 'Tidak dipakai sendiri tanpa klausa kedua.',
  ),
  GrammarPoint(
    pattern: '-더라도',
    level: 'B2',
    formula: 'Stem + 더라도',
    explanation: 'Meskipun (kemungkinan ekstrem), tetap dilakukan.',
    examples: [
      Example('힘들더라도 포기하지 마세요.', 'Meskipun berat, jangan menyerah.'),
      Example('늦더라도 꼭 와 주세요.', 'Meskipun terlambat, pastikan datang.'),
    ],
    pitfall: 'Berbeda dari -아도: -더라도 lebih menekankan pengandaian ekstrem.',
  ),
  GrammarPoint(
    pattern: '-는 반면에',
    level: 'C1',
    formula: 'Kata kerja + 는 반면에 · Kata sifat + -(으)ㄴ 반면에',
    explanation: 'Membandingkan dua sisi yang berlawanan.',
    examples: [
      Example('도시는 편리한 반면에 복잡해요.', 'Kota praktis, sebaliknya rumit.'),
      Example('값은 비싼 반면에 품질이 좋아요.', 'Harganya mahal, sebaliknya kualitasnya bagus.'),
    ],
    pitfall: 'Kedua klausa harus benar-benar kontras; jangan pakai untuk tambahan biasa.',
  ),
  GrammarPoint(
    pattern: '-에도 불구하고',
    level: 'C1',
    formula: 'Kata benda + 에도 불구하고',
    explanation: 'Meskipun terjadi hal yang biasanya menghalangi.',
    examples: [
      Example('어려움에도 불구하고 계속했어요.', 'Meskipun ada kesulitan, saya melanjutkan.'),
      Example('비에도 불구하고 행사가 열렸어요.', 'Meskipun hujan, acara tetap digelar.'),
    ],
    pitfall: 'Bentuk formal; di percakapan lebih natural pakai -는데도.',
  ),
  GrammarPoint(
    pattern: '-는 셈이다',
    level: 'C2',
    formula: 'Kata kerja + 는 셈이다 · Kata sifat + -(으)ㄴ 셈이다',
    explanation: 'Menyimpulkan bahwa secara praktis sesuatu setara dengan hal lain.',
    examples: [
      Example('사실상 같은 셈이에요.', 'Secara praktis, itu sama saja.'),
      Example('다 배운 셈이에요.', 'Bisa dibilang sudah belajar semuanya.'),
    ],
    pitfall: 'Nuansanya kesimpulan pembicara, bukan fakta objektif.',
  ),
  GrammarPoint(
    pattern: '-기 마련이다',
    level: 'C2',
    formula: 'Stem + 기 마련이다',
    explanation: 'Sesuatu yang wajar/pasti terjadi.',
    examples: [
      Example('노력하면 발전하기 마련이에요.', 'Kalau berusaha, pasti berkembang.'),
      Example('처음에는 실수하기 마련이에요.', 'Pada awalnya, wajar membuat kesalahan.'),
    ],
    pitfall: 'Jangan pakai untuk kejadian unik satu kali; ini untuk kecenderungan umum.',
  ),
];

List<GrammarPoint> grammarForLevel(String level) =>
    koreanGrammar.where((g) => g.level == level).toList();
