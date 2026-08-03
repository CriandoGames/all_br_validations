import 'package:all_br_validations/all_br_validations.dart';
import 'package:all_br_validations/src/br_formatter/internal/cpf_generator.dart';
import 'package:test/test.dart';

void main() {
  group('BrFormatter.extractDdd reconhece código do país', () {
    test('remove +55 ou 55 somente de números completos', () {
      expect(BrFormatter.extractDdd('+55 11 99999-8877'), '11');
      expect(BrFormatter.extractDdd('5511999998877'), '11');
      expect(BrFormatter.extractDdd('(21) 3333-4444'), '21');
      expect(BrFormatter.extractDdd('21999998877'), '21');
    });

    test('não inventa DDD em número local', () {
      expect(BrFormatter.extractDdd('999998877'), '');
      expect(BrFormatter.extractDdd('33334444'), '');
    });
  });

  group('BrFormatter.generateCpf rejeita base repetida', () {
    for (final base in ['000000000', '111111111', '999999999']) {
      test('reconhece deterministicamente a base $base', () {
        expect(isRepeatedCpfBase(base), isTrue);
      });
    }

    test('CPF gerado continua válido', () {
      final cpf = BrFormatter.generateCpf();
      expect(AllValidations.isCpf(cpf), isTrue);
    });
  });
}
