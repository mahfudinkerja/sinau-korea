import 'package:flutter_test/flutter_test.dart';
import 'package:sinau_korea/utils/hangul.dart';

void main() {
  group('romanToHangul', () {
    test('mengenali frasa umum dari kamus', () {
      expect(romanToHangul('annyeonghaseyo'), '안녕하세요');
      expect(romanToHangul('gamsahamnida'), '감사합니다');
      expect(romanToHangul('hangugeo'), '한국어');
      expect(romanToHangul('isseoyo'), '있어요');
      expect(romanToHangul('bogo sipeo'), '보고 싶어');
    });

    test('menggabungkan suku kata lewat fallback', () {
      expect(romanToHangul('hanguk'), '한국');
      expect(romanToHangul('gaja'), '가자');
      expect(romanToHangul('saram'), '사람');
    });

    test('mempertahankan spasi dan tanda baca', () {
      expect(romanToHangul('annyeong haseyo'), '안녕 하세요');
      expect(romanToHangul('hanguk!'), '한국!');
    });

    test('input kosong menghasilkan string kosong', () {
      expect(romanToHangul(''), '');
      expect(romanToHangul('   '), '');
    });
  });
}
