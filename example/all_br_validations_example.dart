import 'package:all_br_validations/all_br_validations.dart';

void main() {
  const registration = <String, dynamic>{
    'name': 'Ana Souza',
    'email': 'Ana.Souza@Example.com',
    'cpf': '529.982.247-25',
    'phone': '(11) 91234-5678',
    'cep': '01310-100',
    'password': 'Segura@123',
  };

  final schemaResult = validateRegistration(registration);
  if (schemaResult.isNotValid) {
    print('Cadastro inválido: ${schemaResult.errorList.join(', ')}');
    return;
  }
  print('Cadastro válido');

  AllValidations.validateCPF(registration['cpf']! as String).fold(
    (error) => print('${error.property}: ${error.message}'),
    (cpf) => print('CPF normalizado: $cpf'),
  );

  AllValidations.validateEmail(registration['email']! as String).fold(
    (error) => print('${error.property}: ${error.message}'),
    (email) => print('E-mail normalizado: $email'),
  );

  final businessRules = validateBusinessRules(
    age: 28,
    acceptedTerms: true,
  );
  print('Regras de negócio válidas: ${businessRules.isValid}');

  print(
    'Contato: ${BrFormatter.formatPhone('11912345678')} · '
    'CEP: ${BrFormatter.formatCep('01310100')}',
  );

  const companyDocument = '12ABC34501DE35';
  print(
    'CNPJ alfanumérico: ${CnpjAlfanumerico.format(companyDocument)} · '
    'válido: ${CnpjAlfanumerico.isValid(companyDocument)}',
  );
}

/// Valida de uma vez o payload recebido por um formulário ou uma API.
BrZodResult validateRegistration(Map<String, dynamic> data) {
  return BrZod.validate(
    data: data,
    params: {
      'name': BrZod().required().min(3),
      'email': BrZod().required().email(),
      'cpf': BrZod().required().cpf(),
      'phone': BrZod().required().phone(),
      'cep': BrZod().required().cep(),
      'password': BrZod().required().password(),
    },
  );
}

/// Acumula regras de domínio para que a interface mostre todos os erros.
Contract validateBusinessRules({
  required int age,
  required bool acceptedTerms,
}) {
  final contract = Contract();
  contract
    ..isGreaterOrEqualsThan(
      age,
      18,
      'age',
      'É necessário ter pelo menos 18 anos.',
    )
    ..isTrue(
      acceptedTerms,
      'acceptedTerms',
      'É necessário aceitar os termos.',
    );
  return contract;
}
