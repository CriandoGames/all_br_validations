import 'package:all_br_validations/all_br_validations.dart';
import 'package:test/test.dart';

void main() {
  group('validatePixKey com CNPJ numérico', () {
    for (final cnpj in ['11.222.333/0001-81', '11222333000181']) {
      test('identifica $cnpj como CNPJ', () {
        final result = AllValidations.validatePixKey(cnpj);

        expect(result.isSuccess, isTrue);
        expect(result.successValue, PixKeyType.cnpj);
      });
    }

    test('identifica CNPJ alfanumérico vigente no DICT sem máscara', () {
      final result = AllValidations.validatePixKey('12ABC34501DE35');

      expect(result.isSuccess, isTrue);
      expect(result.successValue, PixKeyType.cnpj);
    });

    for (final invalid in [
      '11.222.333/0001-82',
      '11.222.333/000181',
      '11.A22.333/0001-81',
      '11222333000182',
    ]) {
      test('rejeita CNPJ PIX inválido: $invalid', () {
        expect(AllValidations.validatePixKey(invalid).isFailure, isTrue);
      });
    }
  });

  group('isNumericFloat exige um número completo', () {
    for (final invalid in ['.', '-', 'e2', 'E2', '1e', '1E+', '+.']) {
      test('rejeita $invalid', () {
        expect(AllValidations.isNumericFloat(invalid), isFalse);
      });
    }

    for (final valid in ['', '1', '-1', '1.0', '.5', '-.5', '1e3', '-1.2E-3']) {
      test('preserva entrada válida: $valid', () {
        expect(AllValidations.isNumericFloat(valid), isTrue);
      });
    }
  });

  group('isVideo compara a extensão completa', () {
    test('aceita extensões de vídeo já suportadas', () {
      expect(AllValidations.isVideo('video.rmvb'), isTrue);
      expect(AllValidations.isVideo('video.mpeg'), isTrue);
    });

    test('rejeita sufixos sem ponto e arquivo de legenda', () {
      expect(AllValidations.isVideo('arquivo-sem-extensaormvb'), isFalse);
      expect(AllValidations.isVideo('arquivo-sem-extensaompeg'), isFalse);
      expect(AllValidations.isVideo('legenda.srt'), isFalse);
    });
  });

  group('placas são normalizadas antes da validação', () {
    for (final plate in [
      'ABC-1234',
      'abc-1234',
      'ABC1D23',
      'abc1d23',
      ' ABC-1234 ',
      ' abc1d23 ',
    ]) {
      test('aceita $plate', () {
        expect(AllValidations.isValidBrazilianLicensePlate(plate), isTrue);
      });
    }

    test('validateLicensePlate retorna valor normalizado', () {
      final result = AllValidations.validateLicensePlate(' abc1d23 ');

      expect(result.isSuccess, isTrue);
      expect(result.successValue, 'ABC1D23');
    });
  });

  group('isCreditCard valida PAN genérico por Luhn', () {
    test('aceita os limites da faixa Mastercard 2', () {
      expect(AllValidations.isCreditCard(_validLuhn('2221', 16)), isTrue);
      expect(AllValidations.isCreditCard(_validLuhn('2720', 16)), isTrue);
    });

    test('aceita Visa com 19 dígitos', () {
      expect(AllValidations.isCreditCard(_validLuhn('4', 19)), isTrue);
    });

    test('rejeita Luhn inválido e sequência repetida', () {
      final valid = _validLuhn('2221', 16);
      final last = int.parse(valid[valid.length - 1]);
      final invalid =
          valid.substring(0, valid.length - 1) + ((last + 1) % 10).toString();

      expect(AllValidations.isCreditCard(invalid), isFalse);
      expect(AllValidations.isCreditCard('0000000000000000'), isFalse);
    });
  });

  group('isMapExists preserva semântica de existência', () {
    test('exige chave presente e valor não nulo', () {
      expect(
        AllValidations.isMapExists(key: ['name'], map: {'name': 'Carlos'}),
        isTrue,
      );
      expect(
        AllValidations.isMapExists(key: ['name'], map: {'name': null}),
        isFalse,
      );
      expect(AllValidations.isMapExists(key: ['name'], map: {}), isFalse);
    });

    test('string vazia continua sendo um valor existente', () {
      expect(
        AllValidations.isMapExists(key: ['name'], map: {'name': ''}),
        isTrue,
      );
    });
  });
}

String _validLuhn(String prefix, int length) {
  final body = prefix.padRight(length - 1, '0');
  for (var digit = 0; digit <= 9; digit++) {
    final candidate = body + digit.toString();
    if (_passesLuhn(candidate)) return candidate;
  }
  throw StateError('Não foi possível gerar um PAN de teste.');
}

bool _passesLuhn(String digits) {
  var sum = 0;
  var shouldDouble = false;
  for (var index = digits.length - 1; index >= 0; index--) {
    var digit = int.parse(digits[index]);
    if (shouldDouble) {
      digit *= 2;
      if (digit > 9) digit -= 9;
    }
    sum += digit;
    shouldDouble = !shouldDouble;
  }
  return sum % 10 == 0;
}
