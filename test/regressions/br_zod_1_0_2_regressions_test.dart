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

  group('type<T> faz verificação estrita de tipo', () {
    test('aceita instâncias e rejeita strings convertíveis', () {
      expect(generic.isType<int>(123), isTrue);
      expect(BrZod().type<int>().build('123'), isNotNull);
      expect(generic.isType<double>(1.5), isTrue);
      expect(BrZod().type<double>().build('1.5'), isNotNull);
      expect(generic.isType<bool>(true), isTrue);
      expect(BrZod().type<bool>().build('true'), isNotNull);
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

    test('fachadas médias exigem as mesmas três categorias', () {
      for (final password in ['abcdef1', 'ABCDEF1', 'Abcdef']) {
        expect(AllValidations.isMediumPassword(password), isFalse);
        expect(
          security.isPassword(password, policy: PasswordPolicy.medium),
          isFalse,
        );
      }

      expect(AllValidations.isMediumPassword('Abc123'), isTrue);
      expect(
        security.isPassword('Abc123', policy: PasswordPolicy.medium),
        isTrue,
      );

      for (final password in ['Ab c123', 'Ab\nc123', 'Ab1${'x' * 100}']) {
        expect(
          security.isPassword(password, policy: PasswordPolicy.medium),
          AllValidations.isMediumPassword(password),
          reason: password,
        );
      }
    });

    test('fachadas fortes aplicam o mesmo limite de 99 caracteres', () {
      final longPassword = 'Aa1!${'x' * 96}';
      expect(AllValidations.isStrongPassword(longPassword), isFalse);
      expect(BrZod().password().build(longPassword), isNotNull);
    });

    test('fachadas fortes rejeitam espaços', () {
      const password = 'Abc 123!';
      expect(AllValidations.isStrongPassword(password), isFalse);
      expect(BrZod().password().build(password), isNotNull);
    });

    test('política customizada pode liberar limite e espaços', () {
      const policy = PasswordPolicy(
        maxLength: null,
        allowWhitespace: true,
      );
      final password = 'Aa1! ${'x' * 100}';
      expect(security.isPassword(password, policy: policy), isTrue);
      expect(BrZod().password(policy: policy).build(password), isNull);
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
