import 'package:all_br_validations/all_br_validations.dart';
import 'package:test/test.dart';

import '../../example/all_br_validations_example.dart' as example;

void main() {
  test('exemplo valida um cadastro completo', () {
    final result = example.validateRegistration({
      'name': 'Ana Souza',
      'email': 'ana.souza@example.com',
      'cpf': '529.982.247-25',
      'phone': '(11) 91234-5678',
      'cep': '01310-100',
      'password': 'Segura@123',
    });

    expect(result.isValid, isTrue);
    expect(result.errors, isEmpty);
  });

  test('exemplo devolve todos os campos inválidos', () {
    final result = example.validateRegistration({
      'name': '',
      'email': 'email-invalido',
      'cpf': '111.111.111-11',
      'phone': '123',
      'cep': '123',
      'password': 'fraca',
    });

    expect(result.isNotValid, isTrue);
    expect(result.errors.keys, {
      'name',
      'email',
      'cpf',
      'phone',
      'cep',
      'password',
    });
  });

  test('exemplo acumula violações de regras de negócio', () {
    final contract = example.validateBusinessRules(
      age: 16,
      acceptedTerms: false,
    );

    expect(contract.invalid, isTrue);
    expect(contract.notifications, hasLength(2));
    expect(
      contract.notifications.map((notification) => notification.property),
      ['age', 'acceptedTerms'],
    );
  });

  test('README documenta normalização, formatação e CNPJ alfanumérico', () {
    final cpf = AllValidations.validateCPF('529.982.247-25');
    final email = AllValidations.validateEmail('Ana.Souza@Example.com');
    final pix = AllValidations.validatePixKey('cliente@example.com');

    expect(cpf.successValue, '52998224725');
    expect(email.successValue, 'ana.souza@example.com');
    expect(pix.successValue, 'Email');
    expect(
      AllValidations.isBrazilianCellPhone('(11) 91234-5678'),
      isTrue,
    );
    expect(
      AllValidations.isValidBrazilianLicensePlate('ABC1D23'),
      isTrue,
    );
    expect(BrFormatter.formatPhone('11912345678'), '(11) 91234-5678');
    expect(BrFormatter.formatCep('01310100'), '01310-100');
    expect(CnpjAlfanumerico.isValid('12ABC34501DE35'), isTrue);
  });
}
