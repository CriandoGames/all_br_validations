import 'package:all_br_validations/all_br_validations.dart';
import 'package:all_br_validations/src/br_zod/validations/generic.dart'
    as generic;
import 'package:all_br_validations/src/br_zod/validations/security.dart'
    as security;
import 'package:test/test.dart';

void main() {
  group('IPv6 é consistente entre fachadas', () {
    for (final valid in [
      '::',
      '::1',
      '2001:db8::1',
      'fe80::1%eth0',
      '2001:0db8:85a3:0000:0000:8a2e:0370:7334',
    ]) {
      test('aceita $valid', () {
        expect(security.isIpv6(valid), isTrue);
        expect(AllValidations.isIPv6(valid), isTrue);
        expect(BrZod().ipv6().build(valid), isNull);
      });
    }

    for (final invalid in [':::', '2001:::1', 'gggg::1', '192.168.0.1', '']) {
      test('rejeita $invalid', () {
        expect(security.isIpv6(invalid), isFalse);
        expect(AllValidations.isIPv6(invalid), isFalse);
        expect(BrZod().ipv6().build(invalid), isNotNull);
      });
    }

    test('BrZod rejeita null', () {
      expect(security.isIpv6(null), isFalse);
      expect(BrZod().ipv6().build(null), isNotNull);
    });
  });

  group('type<T> preserva coerção histórica documentada', () {
    test('mantém valores e strings convertíveis', () {
      expect(generic.isType<int>(123), isTrue);
      expect(BrZod().type<int>().build('123'), isNull);
      expect(generic.isType<double>(1.5), isTrue);
      expect(BrZod().type<double>().build('1.5'), isNull);
      expect(generic.isType<bool>(true), isTrue);
      expect(BrZod().type<bool>().build('true'), isNull);
      expect(BrZod().type<String>().build('abc'), isNull);
    });
  });

  group('políticas de senha', () {
    for (final password in ['Abc@1234', 'Senha#123']) {
      test('fachadas fortes concordam para $password', () {
        expect(AllValidations.isStrongPassword(password), isTrue);
        expect(
          Contract().isStrongPassword(password, 'password', 'inválida').isValid,
          isTrue,
        );
        expect(BrZod().password().build(password), isNull);
      });
    }

    for (final password in ['abc@1234', 'ABC@1234', 'Abcdefg1', 'Abcdefg@']) {
      test('fachadas fortes rejeitam $password', () {
        expect(AllValidations.isStrongPassword(password), isFalse);
        expect(
          Contract().isStrongPassword(password, 'password', 'inválida').isValid,
          isFalse,
        );
        expect(BrZod().password().build(password), isNotNull);
      });
    }

    test('caracteriza diferença histórica da política média', () {
      expect(AllValidations.isMediumPassword('abcdef1'), isTrue);
      expect(
        security.isPassword('abcdef1', policy: PasswordPolicy.medium),
        isFalse,
      );
      expect(AllValidations.isMediumPassword('Abc123'), isTrue);
      expect(
        security.isPassword('Abc123', policy: PasswordPolicy.medium),
        isTrue,
      );
    });

    test('caracteriza limite histórico de 99 da fachada legada', () {
      final longPassword = 'Aa1!${'x' * 96}';
      expect(AllValidations.isStrongPassword(longPassword), isFalse);
      expect(BrZod().password().build(longPassword), isNull);
    });
  });

  group('BrZod.validate preserva o tipo de objetos aninhados', () {
    final params = {
      'user': {
        'email': BrZod().optional().email(),
      },
    };

    for (final value in ['não é um objeto', 123, <dynamic>[], true]) {
      test('rejeita objeto aninhado incompatível: $value', () {
        final result = BrZod.validate(data: {'user': value}, params: params);
        expect(result.isValid, isFalse);
        expect(result.errors.containsKey('user'), isTrue);
      });
    }

    test('null e mapa vazio continuam representando objeto ausente/vazio', () {
      expect(
          BrZod.validate(data: {'user': null}, params: params).isValid, isTrue);
      expect(
          BrZod.validate(data: {'user': {}}, params: params).isValid, isTrue);
    });
  });
}
