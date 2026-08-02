import 'package:all_br_validations/all_br_validations.dart';
import 'package:test/test.dart';

bool _zodAccepts(BrZod schema, Object? value) => schema.build(value) == null;

void main() {
  group('regras canônicas compartilhadas', () {
    test('CPF é consistente em AllValidations, BrZod e Contract', () {
      for (final value in ['529.982.247-25', '111.111.111-11']) {
        final direct = AllValidations.isCpf(value);
        final zod = _zodAccepts(BrZod().cpf(), value);
        final contract =
            Contract().isValidCPF(value, 'cpf', 'inválido').isValid;

        expect(zod, direct, reason: value);
        expect(contract, direct, reason: value);
      }
    });

    test('CNPJ, CEP, e-mail e URL preservam o mesmo resultado', () {
      final cases = <(bool Function(), bool Function(), bool Function())>[
        (
          () => AllValidations.isCnpj('11.222.333/0001-81'),
          () => _zodAccepts(BrZod().cnpj(), '11.222.333/0001-81'),
          () => Contract()
              .isValidCNPJ('11.222.333/0001-81', 'cnpj', 'inválido')
              .isValid,
        ),
        (
          () => AllValidations.isValidBRZip('01001-000'),
          () => _zodAccepts(BrZod().cep(), '01001-000'),
          () => Contract().isValidBRZip('01001-000', 'cep', 'inválido').isValid,
        ),
        (
          () => AllValidations.isEmail('dev+tag@example.com'),
          () => _zodAccepts(BrZod().email(), 'dev+tag@example.com'),
          () => Contract()
              .isEmail('dev+tag@example.com', 'email', 'inválido')
              .isValid,
        ),
        (
          () => AllValidations.isURL('https://example.com/path'),
          () => _zodAccepts(BrZod().url(), 'https://example.com/path'),
          () => Contract()
              .isURL('https://example.com/path', 'url', 'inválido')
              .isValid,
        ),
      ];

      for (final (direct, zod, contract) in cases) {
        expect(zod(), direct());
        expect(contract(), direct());
      }
    });

    test('Contract delega senha forte e UUID a AllValidations', () {
      for (final password in ['Senha#123', 'senha fraca']) {
        expect(
          Contract().isStrongPassword(password, 'senha', 'inválida').isValid,
          AllValidations.isStrongPassword(password),
          reason: password,
        );
      }

      for (final uuid in [
        '550e8400-e29b-41d4-a716-446655440000',
        'não-uuid',
      ]) {
        expect(
          Contract().isUUID(uuid, 'id', 'inválido').isValid,
          AllValidations.isUUID(uuid),
          reason: uuid,
        );
      }
    });
  });

  test('telefone preserva divergência histórica intencional', () {
    const semDdd = '912345678';
    const comDdd = '(11) 91234-5678';

    expect(_zodAccepts(BrZod().phone(), semDdd), isTrue);
    expect(
      Contract().isPhoneNumber(semDdd, 'telefone', 'inválido').isValid,
      isFalse,
    );
    expect(_zodAccepts(BrZod().phone(), comDdd), isTrue);
    expect(
      Contract().isPhoneNumber(comDdd, 'telefone', 'inválido').isValid,
      isTrue,
    );
  });
}
