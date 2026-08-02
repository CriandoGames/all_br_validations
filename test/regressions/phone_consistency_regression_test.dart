import 'package:all_br_validations/all_br_validations.dart';
import 'package:test/test.dart';

void main() {
  group('formatos de telefone compartilhados', () {
    const validValues = [
      '11987654321',
      '(11) 98765-4321',
      '1133334444',
      '(11) 3333-4444',
    ];

    const invalidValues = [
      '11@99999#8877',
      '11@3333#4444',
      '(11)/99999.8877',
      '(11)/3333.4444',
      'abc11999998877',
      '11999998877xyz',
      ' 11999998877',
      '11999998877 ',
    ];

    for (final value in [...validValues, ...invalidValues]) {
      test('fachadas concordam para "$value"', () {
        final directCell = AllValidations.isBrazilianCellPhone(value);
        final directLandline = AllValidations.isBrazilianLandline(value);
        final direct = directCell || directLandline;
        final contract = Contract()
            .isPhoneNumber(value, 'phone', 'Telefone inválido')
            .isValid;
        final zod = BrZod().required().phone().build(value) == null;

        expect(contract, direct);
        expect(zod, direct);
      });
    }

    test('rejeita pontuação arbitrária nas fachadas públicas', () {
      expect(
        AllValidations.isBrazilianCellPhone('11@99999#8877'),
        isFalse,
      );
      expect(
        AllValidations.isBrazilianLandline('11@3333#4444'),
        isFalse,
      );
      expect(
        BrZod().required().phone().build('abc11999998877'),
        isNotNull,
      );
    });

    test('aceita código do país apenas nas fachadas que o documentam', () {
      for (final value in [
        '+5511987654321',
        '+55 11 98765-4321',
      ]) {
        expect(AllValidations.isBrazilianCellPhone(value), isTrue);
        expect(
          Contract().isPhoneNumber(value, 'phone', 'Telefone inválido').isValid,
          isTrue,
        );
        expect(BrZod().required().phone().build(value), isNotNull);
      }

      for (final value in [
        '+551133334444',
        '+55 11 3333-4444',
      ]) {
        expect(AllValidations.isBrazilianLandline(value), isTrue);
        expect(
          Contract().isPhoneNumber(value, 'phone', 'Telefone inválido').isValid,
          isTrue,
        );
        expect(BrZod().required().phone().build(value), isNotNull);
      }
    });

    test('BrZod preserva telefone local sem DDD', () {
      expect(BrZod().required().phone().build('33334444'), isNull);
      expect(BrZod().required().phone().build('987654321'), isNull);
      expect(AllValidations.isBrazilianLandline('33334444'), isFalse);
      expect(AllValidations.isBrazilianCellPhone('987654321'), isFalse);
    });
  });

  test('rejeita todos os DDDs inativos confirmados', () {
    const invalidDdds = [
      '00',
      '10',
      '20',
      '23',
      '25',
      '26',
      '29',
      '30',
      '36',
      '52',
      '72',
      '76',
      '78',
    ];

    for (final ddd in invalidDdds) {
      final cell = '${ddd}987654321';
      final landline = '${ddd}33334444';

      expect(AllValidations.isBrazilianCellPhone(cell), isFalse, reason: ddd);
      expect(AllValidations.isBrazilianLandline(landline), isFalse,
          reason: ddd);
      expect(
        Contract().isPhoneNumber(cell, 'phone', 'Telefone inválido').isValid,
        isFalse,
        reason: ddd,
      );
      expect(BrZod().required().phone().build(cell), isNotNull, reason: ddd);
    }
  });
}
