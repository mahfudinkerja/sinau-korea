import '../models.dart';

const List<ReadingPassage> koreanReadings = [
  ReadingPassage(
    title: '저는 학생이에요',
    level: 'A1',
    topic: 'Perkenalan · kehidupan sehari-hari',
    sentences: [
      ReadingSentence('저는 인도네시아에서 온 리나예요.', 'Saya Lina, berasal dari Indonesia.'),
      ReadingSentence('지금 서울에서 한국어를 배워요.', 'Sekarang saya belajar bahasa Korea di Seoul.'),
      ReadingSentence('매일 학교에 가고 친구를 만나요.', 'Setiap hari saya pergi ke sekolah dan bertemu teman.'),
      ReadingSentence('주말에는 집에서 영화를 봐요.', 'Akhir pekan saya menonton film di rumah.'),
    ],
    questions: [
      QuizQuestion(
        prompt: '리나는 지금 어디에서 살아요?',
        options: ['부산', '서울', '인도네시아', '도쿄'],
        answerIndex: 1,
        explanation: 'Teks menyebut 지금 서울에서 한국어를 배워요 — sekarang belajar di Seoul.',
      ),
      QuizQuestion(
        prompt: '리나는 주말에 뭐 해요?',
        options: ['학교에 가요', '친구를 만나요', '영화를 봐요', '여행을 가요'],
        answerIndex: 2,
        explanation: '주말에는 집에서 영화를 봐요 — akhir pekan menonton film di rumah.',
      ),
    ],
  ),
  ReadingPassage(
    title: '주말 여행',
    level: 'A2',
    topic: 'Perjalanan · bentuk lampau',
    sentences: [
      ReadingSentence('지난 주말에 친구와 부산에 갔어요.', 'Akhir pekan lalu saya pergi ke Busan dengan teman.'),
      ReadingSentence('아침 일찍 기차를 탔어요.', 'Pagi-pagi kami naik kereta.'),
      ReadingSentence('바다가 정말 아름다웠어요.', 'Lautnya benar-benar indah.'),
      ReadingSentence('우리는 해운대에서 사진을 많이 찍었어요.', 'Kami banyak berfoto di Haeundae.'),
      ReadingSentence('저녁에는 맛있는 해산물을 먹었어요.', 'Malamnya kami makan seafood yang enak.'),
    ],
    questions: [
      QuizQuestion(
        prompt: '부산에 어떻게 갔어요?',
        options: ['버스로 갔어요', '기차를 탔어요', '비행기를 탔어요', '걸어서 갔어요'],
        answerIndex: 1,
        explanation: '아침 일찍 기차를 탔어요 — pagi-pagi naik kereta.',
      ),
      QuizQuestion(
        prompt: '저녁에 무엇을 먹었어요?',
        options: ['해산물', '김치찌개', '비빔밥', '치킨'],
        answerIndex: 0,
        explanation: '저녁에는 맛있는 해산물을 먹었어요 — makan seafood.',
      ),
    ],
  ),
  ReadingPassage(
    title: '한국의 카페 문화',
    level: 'B1',
    topic: 'Budaya · kebiasaan sosial',
    sentences: [
      ReadingSentence('한국에는 카페가 아주 많아요.', 'Di Korea, kafe sangat banyak.'),
      ReadingSentence('사람들은 카페에서 공부하거나 친구를 만나요.', 'Orang-orang belajar atau bertemu teman di kafe.'),
      ReadingSentence('특히 조용한 카페는 혼자 일하기에 좋아요.', 'Terutama kafe yang tenang cocok untuk bekerja sendiri.'),
      ReadingSentence('하지만 주말에는 사람이 많아서 자리를 찾기 어려워요.', 'Tetapi akhir pekan ramai sehingga sulit mencari tempat.'),
      ReadingSentence('한국 카페는 디저트도 다양해서 인기가 많아요.', 'Kafe Korea juga punya banyak dessert, jadi populer.'),
    ],
    questions: [
      QuizQuestion(
        prompt: '사람들은 카페에서 주로 무엇을 해요?',
        options: ['운동하거나 요리해요', '공부하거나 친구를 만나요', '여행을 계획해요', '회의를 해요'],
        answerIndex: 1,
        explanation: 'Teks: 사람들은 카페에서 공부하거나 친구를 만나요.',
      ),
      QuizQuestion(
        prompt: '언제 자리를 찾기 어려워요?',
        options: ['평일 아침', '주말', '새벽', '점심 전'],
        answerIndex: 1,
        explanation: '주말에는 사람이 많아서 자리를 찾기 어려워요.',
      ),
    ],
  ),
  ReadingPassage(
    title: '서울의 교통',
    level: 'B2',
    topic: 'Kota · transportasi publik',
    sentences: [
      ReadingSentence('서울은 대중교통이 잘 발달한 도시예요.', 'Seoul adalah kota dengan transportasi publik yang berkembang baik.'),
      ReadingSentence('지하철과 버스가 촘촘하게 연결되어 있어서 어디든 갈 수 있어요.', 'Subway dan bus terhubung rapat sehingga bisa pergi ke mana saja.'),
      ReadingSentence('특히 지하철은 정시에 도착해서 출퇴근 시간에도 편리해요.', 'Terutama subway datang tepat waktu sehingga nyaman saat jam sibuk.'),
      ReadingSentence('그러나 환승 구간이 복잡해서 처음 온 사람은 헷갈릴 수 있어요.', 'Namun jalur transit rumit sehingga pendatang bisa bingung.'),
      ReadingSentence('요즘은 교통카드 하나로 대부분의 교통수단을 이용할 수 있어요.', 'Kini dengan satu kartu transportasi, hampir semua moda bisa digunakan.'),
    ],
    questions: [
      QuizQuestion(
        prompt: '지하철의 장점은 무엇이에요?',
        options: ['항상 비어 있어요', '정시에 도착해요', '무료예요', '밤에만 다녀요'],
        answerIndex: 1,
        explanation: '지하철은 정시에 도착해서 편리해요 — datang tepat waktu.',
      ),
      QuizQuestion(
        prompt: '처음 온 사람이 헷갈릴 수 있는 이유는?',
        options: ['표가 없어서', '환승 구간이 복잡해서', '역이 없어서', '버스가 없어서'],
        answerIndex: 1,
        explanation: '환승 구간이 복잡해서 처음 온 사람은 헷갈릴 수 있어요.',
      ),
    ],
  ),
  ReadingPassage(
    title: '세대 갈등과 소통',
    level: 'C1',
    topic: 'Sosial · analisis',
    sentences: [
      ReadingSentence('한국 사회에서는 세대 간 가치관 차이가 자주 논의됩니다.', 'Di masyarakat Korea, perbedaan nilai antargenerasi sering dibahas.'),
      ReadingSentence('고령 세대는 안정과 공동체를 중시하는 반면, 젊은 세대는 개인의 선택과 일과 삶의 균형을 강조합니다.', 'Generasi tua menekankan stabilitas dan komunitas, sementara generasi muda menekankan pilihan pribadi serta keseimbangan kerja-hidup.'),
      ReadingSentence('이러한 차이는 갈등으로 이어지기도 하지만, 새로운 문화를 만드는 원동력이 되기도 합니다.', 'Perbedaan ini kadang berujung konflik, tetapi juga menjadi pendorong lahirnya budaya baru.'),
      ReadingSentence('중요한 것은 서로의 관점을 인정하고 대화를 이어 가는 태도입니다.', 'Yang penting adalah sikap saling mengakui sudut pandang dan melanjutkan dialog.'),
    ],
    questions: [
      QuizQuestion(
        prompt: '젊은 세대가 강조하는 것은?',
        options: ['안정과 공동체', '개인의 선택과 일과 삶의 균형', '전통의 보존', '경제 성장만'],
        answerIndex: 1,
        explanation: '젊은 세대는 개인의 선택과 일과 삶의 균형을 강조합니다.',
      ),
      QuizQuestion(
        prompt: '글쓴이가 중요하다고 말하는 태도는?',
        options: ['갈등을 피하는 것', '한쪽 관점만 따르는 것', '서로의 관점을 인정하고 대화하는 것', '세대를 분리하는 것'],
        answerIndex: 2,
        explanation: '마지막 문장: 서로의 관점을 인정하고 대화를 이어 가는 태도.',
      ),
    ],
  ),
];
