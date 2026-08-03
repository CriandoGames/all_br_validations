import 'dart:math';

import 'package:all_br_validations/all_br_validations.dart';
import 'package:all_br_validations/src/br_formatter/internal/cnpj_generator.dart';
import 'package:test/test.dart';

void main() {
  group('Título de Eleitor', () {
    test('aceita título válido conhecido', () {
      expect(AllValidations.isTituloEleitor('743650641660'), isTrue);
    });

    test('rejeita primeiro dígito verificador incorreto', () {
      expect(AllValidations.isTituloEleitor('743650641670'), isFalse);
    });

    test('rejeita segundo dígito verificador incorreto', () {
      expect(AllValidations.isTituloEleitor('743650641661'), isFalse);
    });

    test('aceita códigos de UF nos limites 01 e 28', () {
      expect(AllValidations.isTituloEleitor('123456780191'), isTrue);
      expect(AllValidations.isTituloEleitor('100000002828'), isTrue);
    });

    test('rejeita códigos de UF fora dos limites', () {
      expect(AllValidations.isTituloEleitor('100000000000'), isFalse);
      expect(AllValidations.isTituloEleitor('100000002900'), isFalse);
    });

    test('aplica regra especial de UF 01 quando o primeiro resto é zero', () {
      expect(AllValidations.isTituloEleitor('106438700116'), isTrue);
    });

    test('aplica regra especial de UF 01 quando o primeiro resto é dez', () {
      expect(AllValidations.isTituloEleitor('500000000108'), isTrue);
    });

    test('aplica regra especial de UF 02 quando o primeiro resto é dez', () {
      expect(AllValidations.isTituloEleitor('500000000205'), isTrue);
    });

    test('aplica regra especial de UF 02 quando o segundo resto é dez', () {
      expect(AllValidations.isTituloEleitor('700000000230'), isTrue);
    });
  });

  group('AllValidations.removeCharacters', () {
    test('aceita string vazia', () {
      expect(() => AllValidations.removeCharacters(''), returnsNormally);
    });

    test('mantém string vazia vazia', () {
      expect(AllValidations.removeCharacters(''), '');
    });

    test('permite que isPalindrome trate string vazia consistentemente', () {
      expect(AllValidations.isPalindrome(''), isTrue);
    });
  });

  group('IPv4 consistente entre fachadas', () {
    for (final ip in ['01.02.03.04', '00.0.0.0']) {
      test('rejeita octetos com zero à esquerda: $ip', () {
        expect(AllValidations.isIPv4(ip), isFalse);
        expect(BrZod().ipv4().build(ip), isNotNull);
      });
    }
  });

  group('BrZod optional', () {
    test('mensagem customizada não pode ser confundida com sentinela', () {
      const message = '__br_zod_optional_skip__';

      final result = BrZod()
          .custom(
            (_) => false,
            message: message,
          )
          .build('valor');

      expect(result, message);
    });
  });

  group('BrZod.validate rejeita schemas inválidos', () {
    for (final schema in [
      'email',
      123,
      true,
      <dynamic>[],
      null,
    ]) {
      test('rejeita schema $schema', () {
        expect(
          () => BrZod.validate(
            data: {'email': 'invalido'},
            params: {'email': schema},
          ),
          throwsArgumentError,
        );
      });
    }

    test('informa o caminho completo do schema inválido', () {
      expect(
        () => BrZod.validate(
          data: {
            'user': {'email': 'invalido'},
          },
          params: {
            'user': {'email': 'schema configurado incorretamente'},
          },
        ),
        throwsA(
          isA<ArgumentError>().having(
            (error) => error.message,
            'message',
            'Schema inválido em user.email: esperado BrZod ou Map.',
          ),
        ),
      );
    });
  });

  group('BrFormatter.formatCurrency', () {
    final cases = <double, String>{
      -12: 'R\$ -12,00',
      -123: 'R\$ -123,00',
      -1234: 'R\$ -1.234,00',
      -123456: 'R\$ -123.456,00',
    };

    for (final MapEntry(key: value, value: expected) in cases.entries) {
      test('formata valor negativo $value', () {
        expect(BrFormatter.formatCurrency(value), expected);
      });
    }

    test('formata valor negativo sem símbolo', () {
      expect(
        BrFormatter.formatCurrency(-123456, symbol: false),
        '-123.456,00',
      );
    });
  });

  group('AllValidations.isCreditCard', () {
    test('rejeita cartão formatado com 12 dígitos', () {
      expect(AllValidations.isCreditCard('4000-0000-0002'), isFalse);
    });

    test('rejeita cartão formatado com 20 dígitos', () {
      expect(
        AllValidations.isCreditCard('4000-0000-0000-0000-0002'),
        isFalse,
      );
    });
  });

  group('UUID verifica versão e variante', () {
    test('rejeita UUID v3 com variante inválida', () {
      const uuid = '6ba7b810-9dad-31d1-00b4-00c04fd430c8';

      expect(AllValidations.isUUID(uuid, 3), isFalse);
      expect(BrZod().uuid(version: '3').build(uuid), isNotNull);
    });

    test('rejeita variante inválida no modo padrão', () {
      const uuid = '550e8400-e29b-41d4-0716-446655440000';

      expect(AllValidations.isUUID(uuid), isFalse);
      expect(AllValidations.validateUUID(uuid).isFailure, isTrue);
      expect(BrZod().uuid().build(uuid), isNotNull);
    });

    test('rejeita versão fora do contrato documentado', () {
      const uuid = '550e8400-e29b-01d4-a716-446655440000';

      expect(AllValidations.isUUID(uuid), isFalse);
    });
  });

  group('AllValidations.validatePixKey', () {
    group('telefone valida o DDD', () {
      for (final invalid in [
        '+5500912345678',
        '+5510912345678',
        '+5523912345678',
      ]) {
        test('rejeita $invalid', () {
          expect(
            AllValidations.validatePixKey(invalid).isFailure,
            isTrue,
          );
        });
      }

      test('aceita telefone real com DDD', () {
        final result = AllValidations.validatePixKey('+5521999998877');

        expect(result.isSuccess, isTrue);
        expect(result.successValue, PixKeyType.phone);
      });
    });

    test('aceita chave aleatória conforme exemplo do manual do Pix', () {
      final result = AllValidations.validatePixKey(
        '123e4567-e12b-12d1-a456-426655440000',
      );

      expect(result.isSuccess, isTrue);
      expect(result.successValue, PixKeyType.random);
    });

    test('rejeita UUID sem versão RFC 4122', () {
      final result = AllValidations.validatePixKey(
        '123e4567-e12b-02d1-a456-426655440000',
      );

      expect(result.isFailure, isTrue);
    });
  });

  group('BrFormatter.generateCnpj', () {
    test('base composta apenas por zeros resulta em CNPJ inválido', () {
      expect(isZeroCnpjBase('000000000000'), isTrue);
      expect(AllValidations.isCnpj('00000000000000'), isFalse);
    });

    test('descarta deterministicamente uma base composta apenas por zeros', () {
      final random = _ZeroThenOneRandom();

      expect(generateCnpjBase(random), List<int>.filled(12, 1));
      expect(random.calls, 24);
    });
  });
}

class _ZeroThenOneRandom implements Random {
  int calls = 0;

  @override
  int nextInt(int max) {
    calls++;
    return calls <= 12 ? 0 : 1;
  }

  @override
  bool nextBool() => throw UnimplementedError();

  @override
  double nextDouble() => throw UnimplementedError();
}
