/// Konversi romanisasi Latin ke Hangul.
/// Bukan transliterasi sempurna — dirancang untuk latihan ketik cepat,
/// dengan kamus frasa umum dan fallback komposisi suku kata.
library;

const List<(String, int)> _initials = [
  ('g', 0),
  ('kk', 1),
  ('n', 2),
  ('d', 3),
  ('tt', 4),
  ('r', 5),
  ('l', 5),
  ('m', 6),
  ('b', 7),
  ('pp', 8),
  ('s', 9),
  ('ss', 10),
  ('', 11),
  ('j', 12),
  ('jj', 13),
  ('ch', 14),
  ('k', 15),
  ('t', 16),
  ('p', 17),
  ('h', 18),
];

const List<(String, int)> _medials = [
  ('a', 0),
  ('ae', 1),
  ('ya', 2),
  ('yae', 3),
  ('eo', 4),
  ('e', 5),
  ('yeo', 6),
  ('ye', 7),
  ('o', 8),
  ('wa', 9),
  ('wae', 10),
  ('oe', 11),
  ('yo', 12),
  ('u', 13),
  ('wo', 14),
  ('we', 15),
  ('wi', 16),
  ('yu', 17),
  ('eu', 18),
  ('ui', 19),
  ('i', 20),
];

const List<(String, int)> _finals = [
  ('', 0),
  ('k', 1),
  ('kk', 2),
  ('ks', 3),
  ('n', 4),
  ('nj', 5),
  ('nh', 6),
  ('t', 7),
  ('l', 8),
  ('lk', 9),
  ('lm', 10),
  ('lb', 11),
  ('ls', 12),
  ('lt', 13),
  ('lp', 14),
  ('lh', 15),
  ('m', 16),
  ('p', 17),
  ('ps', 18),
  ('s', 19),
  ('ss', 20),
  ('ng', 21),
  ('j', 22),
  ('ch', 23),
];

List<(String, int)> _byLength(List<(String, int)> source) {
  final list = [...source];
  list.sort((a, b) => b.$1.length.compareTo(a.$1.length));
  return list;
}

final List<(String, int)> _initialsSorted = _byLength(_initials);
final List<(String, int)> _medialsSorted = _byLength(_medials);
final List<(String, int)> _finalsSorted = _byLength(_finals);

const Map<String, String> _common = {
  'annyeong': '안녕',
  'hangugeo': '한국어',
  'hangungmal': '한국말',
  'saranghae': '사랑해',
  'saranghaeyo': '사랑해요',
  'gomawo': '고마워',
  'gomawoyo': '고마워요',
  'joayo': '좋아요',
  'jalhaesseo': '잘했어',
  'mianhaeyo': '미안해요',
  'bogosipeo': '보고 싶어',
  'bogo sipeo': '보고 싶어',
  'sipeo': '싶어',
  'hago sipeo': '하고 싶어',
  'meokgo sipeo': '먹고 싶어',
  'gago sipeo': '가고 싶어',
  'eotteokhae': '어떡해',
  'gwaenchanha': '괜찮아',
  'gwaenchanayo': '괜찮아요',
  'baegopa': '배고파',
  'pigonhae': '피곤해',
  'gwiyeowo': '귀여워',
  'museowo': '무서워',
  'isseoyo': '있어요',
  'eopseoyo': '없어요',
  'juseyo': '주세요',
  'haseyo': '하세요',
  'mwo': '뭐',
  'wae': '왜',
  'eodiyeyo': '어디예요',
  'eolmayeyo': '얼마예요',
  'gamsahamnida': '감사합니다',
  'annyeonghaseyo': '안녕하세요',
  'joesonghamnida': '죄송합니다',
  'annyeonghi gaseyo': '안녕히 가세요',
  'da jal doel geoya': '다 잘 될 거야',
  'geokjeonghaji ma': '걱정하지 마',
  'haenguneul bireo': '행운을 빌어',
  'yeonghwareul bwayo': '영화를 봐요',
  'babeul meogeoyo': '밥을 먹어요',
  'hakgyoe gayo': '학교에 가요',
  'hangugeoreul baewoyo': '한국어를 배워요',
};

String romanToHangul(String input) {
  if (input.trim().isEmpty) return '';
  final normalized = input
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  final exact = _common[normalized];
  if (exact != null) return exact;

  final buffer = StringBuffer();
  for (final match in RegExp(r'[a-z]+|[^a-z]+').allMatches(normalized)) {
    final token = match.group(0)!;
    if (!RegExp(r'[a-z]').hasMatch(token)) {
      buffer.write(token);
      continue;
    }
    buffer.write(_common[token] ?? _convertWord(token));
  }
  return buffer.toString();
}

String _convertWord(String word) {
  final n = word.length;
  final cost = List<double>.filled(n + 1, double.infinity);
  final prev = List<int>.filled(n + 1, -1);
  final syllable = List<String>.filled(n + 1, '');
  cost[0] = 0;

  for (var i = 0; i < n; i++) {
    if (cost[i] == double.infinity) continue;
    for (final candidate in _candidatesAt(word, i)) {
      final end = i + candidate.length;
      if (end > n) continue;
      final next = cost[i] + candidate.cost;
      if (next < cost[end]) {
        cost[end] = next;
        prev[end] = i;
        syllable[end] = candidate.syllable;
      }
    }
  }

  if (cost[n] == double.infinity) return word;
  final parts = <String>[];
  var cursor = n;
  while (cursor > 0) {
    parts.add(syllable[cursor]);
    cursor = prev[cursor];
  }
  return parts.reversed.join();
}

class _Candidate {
  final String syllable;
  final int length;
  final double cost;
  const _Candidate(this.syllable, this.length, this.cost);
}

List<_Candidate> _candidatesAt(String word, int start) {
  final result = <_Candidate>[];
  for (final initial in _initialsSorted) {
    if (!word.startsWith(initial.$1, start)) continue;
    final afterInitial = start + initial.$1.length;
    if (afterInitial > word.length) continue;
    for (final medial in _medialsSorted) {
      if (!word.startsWith(medial.$1, afterInitial)) continue;
      final afterMedial = afterInitial + medial.$1.length;
      for (final finalConsonant in _finalsSorted) {
        if (finalConsonant.$1.isNotEmpty &&
            !word.startsWith(finalConsonant.$1, afterMedial)) {
          continue;
        }
        final consumed = initial.$1.length +
            medial.$1.length +
            finalConsonant.$1.length;
        if (consumed == 0) continue;
        final code = 0xAC00 +
            initial.$2 * 21 * 28 +
            medial.$2 * 28 +
            finalConsonant.$2;
        final penalty =
            1.0 +
            (finalConsonant.$2 == 0 ? 0 : 0.35) +
            (initial.$1.isEmpty ? 0.12 : 0) -
            (medial.$1.length * 0.02);
        result.add(_Candidate(
          String.fromCharCode(code),
          consumed,
          penalty,
        ));
      }
    }
  }
  return result;
}
