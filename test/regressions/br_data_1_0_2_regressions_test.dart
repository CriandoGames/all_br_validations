import 'package:all_br_validations/all_br_validations.dart';
import 'package:test/test.dart';

void main() {
  group('BrData.parseWithTime valida horário estritamente', () {
    for (final invalid in [
      '26/06/2026 24:00',
      '26/06/2026 14:60',
      '26/06/2026 -1:30',
      '26/06/2026 14:-1',
      '26/06/2026 14:30:99',
      '26/06/2026 4:5',
    ]) {
      test('rejeita $invalid', () {
        expect(() => BrData.parseWithTime(invalid), throwsFormatException);
      });
    }

    for (final time in ['00:00', '09:05', '14:30', '23:59']) {
      test('aceita $time', () {
        final parsed = BrData.parseWithTime('26/06/2026 $time');
        final actual =
            '${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}';
        expect(actual, time);
      });
    }
  });

  group('BrData exige DD/MM/AAAA', () {
    for (final invalid in ['1/1/2026', '01/1/2026', '1/01/2026']) {
      test('parse rejeita $invalid', () {
        expect(() => BrData.parse(invalid), throwsFormatException);
      });

      test('validate rejeita $invalid', () {
        expect(BrData.validate(invalid), isFalse);
      });
    }

    test('parseWithTime rejeita data sem zeros à esquerda', () {
      expect(
        () => BrData.parseWithTime('1/1/2026 09:05'),
        throwsFormatException,
      );
    });
  });
}
