import 'package:all_br_validations/all_br_validations.dart';
import 'package:all_br_validations/src/br_zod/validations/security.dart'
    as security;
import 'package:all_br_validations/src/helpers/constants.dart';
import 'package:test/test.dart';

String _repeat(String value, int count) => List.filled(count, value).join();

void main() {
  group('limites de e-mail', () {
    test('rejeita parte local com 65 caracteres ASCII', () {
      final email = '${_repeat('a', 65)}@example.com';

      expect(AllValidations.isEmail(email), isFalse);
      expect(BrZod().email().build(email), isNotNull);
    });

    test('rejeita domínio maior que o permitido', () {
      final domain = [
        _repeat('a', 63),
        _repeat('b', 63),
        _repeat('c', 63),
        _repeat('d', 63),
        'com',
      ].join('.');

      expect(AllValidations.isEmail('user@$domain'), isFalse);
    });

    test('rejeita endereço completo maior que 254 octetos', () {
      final local = _repeat('a', 64);
      final domain = [
        _repeat('b', 63),
        _repeat('c', 63),
        _repeat('d', 59),
        'com',
      ].join('.');

      expect(domain.length, lessThanOrEqualTo(255));
      expect(AllValidations.isEmail('$local@$domain'), isFalse);
    });
  });

  group('parseCurrency rejeita entrada corrompida', () {
    test('rejeita letras dentro do valor', () {
      expect(
        () => BrFormatter.parseCurrency('1R2,00'),
        throwsFormatException,
      );
    });

    test('stripCurrencySymbol remove apenas o prefixo', () {
      expect(BrFormatter.stripCurrencySymbol('1R2,00'), '1R2,00');
      expect(BrFormatter.stripCurrencySymbol(' R\$ 1.234,56 '), '1.234,56');
    });
  });

  group('formatCurrency trata limites', () {
    test('rejeita valor grande que seria formatado em notação exponencial', () {
      expect(
        () => BrFormatter.formatCurrency(1e21),
        throwsA(allOf(isA<ArgumentError>(), isNot(isA<RangeError>()))),
      );
      expect(
        () => BrFormatter.formatCurrency(-1e21),
        throwsA(allOf(isA<ArgumentError>(), isNot(isA<RangeError>()))),
      );
    });

    test('rejeita valor não finito', () {
      expect(
        () => BrFormatter.formatCurrency(double.infinity),
        throwsA(allOf(isA<ArgumentError>(), isNot(isA<RangeError>()))),
      );
      expect(
        () => BrFormatter.formatCurrency(double.nan),
        throwsA(allOf(isA<ArgumentError>(), isNot(isA<RangeError>()))),
      );
    });

    test('valida casas decimais explicitamente', () {
      expect(
        () => BrFormatter.formatCurrency(1, decimals: -1),
        throwsA(isA<RangeError>()
            .having((error) => error.name, 'name', 'decimals')),
      );
      expect(
        () => BrFormatter.formatCurrency(1, decimals: 21),
        throwsA(isA<RangeError>()
            .having((error) => error.name, 'name', 'decimals')),
      );
    });
  });

  group('senha exige String', () {
    test('rejeita número na política fraca', () {
      expect(
        security.isPassword(123456, policy: PasswordPolicy.weak),
        isFalse,
      );
    });

    test('BrZod rejeita senha numérica', () {
      expect(
        BrZod().password(policy: PasswordPolicy.weak).build(123456),
        isNotNull,
      );
    });
  });

  group('truncate é seguro para Unicode', () {
    test('não divide emoji', () {
      expect('😀abc'.truncate(1), '😀...');
    });

    test('rejeita limite negativo explicitamente', () {
      expect(() => 'abc'.truncate(-1), throwsRangeError);
    });

    test('aceita limite zero', () {
      expect('abc'.truncate(0), '...');
    });
  });

  group('BrData preserva anos com quatro dígitos', () {
    test('format e parse mantêm round-trip para ano menor que 1000', () {
      final date = DateTime(1, 1, 1);
      final formatted = BrData.format(date);

      expect(formatted, '01/01/0001');
      expect(BrData.parse(formatted), date);
    });

    test('formatMonthYear preenche o ano', () {
      expect(BrData.formatMonthYear(DateTime(42, 5)), '05/0042');
    });

    test('rejeita anos que não cabem em AAAA', () {
      expect(() => BrData.format(DateTime(-1)), throwsRangeError);
      expect(() => BrData.format(DateTime(10000)), throwsRangeError);
      expect(() => BrData.formatMonthYear(DateTime(-1)), throwsRangeError);
      expect(() => BrData.formatMonthYear(DateTime(10000)), throwsRangeError);
    });
  });

  test('gerador de CNPJ não depende da lista pública mutável', () {
    final backup = List<String>.of(CnpjAlfanumerico.validChars);
    try {
      CnpjAlfanumerico.validChars.clear();

      final generated = CnpjAlfanumerico.generate(forceAlphanumeric: true);

      expect(CnpjAlfanumerico.isValid(generated), isTrue);
    } finally {
      CnpjAlfanumerico.validChars.addAll(backup);
    }
  });

  group('BrZodResult é imutável', () {
    test('não permite alterar erros externamente', () {
      final result = BrZod.validate(
        data: {'email': 'inválido'},
        params: {'email': BrZod().email()},
      );

      expect(() => result.errors.clear(), throwsUnsupportedError);
      expect(() => result.errorList.clear(), throwsUnsupportedError);
    });

    test('copia e protege mapas aninhados no construtor', () {
      final nested = <String, dynamic>{'email': 'inválido'};
      final errors = <String, dynamic>{'user': nested};
      final errorList = <String>['user.email: inválido'];
      final result = BrZodResult(
        isValid: false,
        errors: errors,
        errorList: errorList,
      );

      nested['email'] = 'alterado';
      errors.clear();
      errorList.clear();

      expect(result.errors, {
        'user': {'email': 'inválido'},
      });
      expect(result.errorList, ['user.email: inválido']);
      expect(
        () => (result.errors['user'] as Map<String, dynamic>).clear(),
        throwsUnsupportedError,
      );
    });
  });

  group('catálogos públicos são imutáveis', () {
    test('meses não podem ser alterados', () {
      expect(
        () => AllValidationsGetMonth.listMonths.clear(),
        throwsUnsupportedError,
      );
      expect(
        () => AllValidationsGetMonth.mapMonths.clear(),
        throwsUnsupportedError,
      );
    });

    test('dias não podem ser alterados', () {
      expect(
        () => AllValidationsGetWeek.listWorkDaysAbvr.clear(),
        throwsUnsupportedError,
      );
      expect(
        () => AllValidationsGetWeek.listDaysWeekOrdered.clear(),
        throwsUnsupportedError,
      );
      expect(
        () => AllValidationsGetWeek.mapWorkDays.clear(),
        throwsUnsupportedError,
      );
    });
  });

  group('DDD possui uma única fonte da verdade', () {
    test('lista legada é imutável e derivada do mapa canônico', () {
      expect(Constants.ddds, orderedEquals(Constants.dddToState.keys));
      expect(() => Constants.ddds.clear(), throwsUnsupportedError);
    });

    test('validade e consulta de estado permanecem consistentes', () {
      for (var value = 0; value <= 99; value++) {
        final ddd = value.toString().padLeft(2, '0');
        final state = AllValidations.getStateByDDD(ddd);

        expect(
          AllValidations.isValidDDD(ddd),
          state != BrazilianState.Unknown,
          reason: 'inconsistência para o DDD $ddd',
        );
      }
    });
  });
}
