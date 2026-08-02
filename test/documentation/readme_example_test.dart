import 'package:all_br_validations/all_br_validations.dart';
import 'package:test/test.dart';

void main() {
  test('três fachadas concordam para CPF válido', () {
    const cpf = '529.982.247-25';
    expect(AllValidations.isCpf(cpf), isTrue);
    expect(BrZod().required().cpf().build(cpf), isNull);
    expect(Contract().isValidCPF(cpf, 'cpf', 'inválido').isValid, isTrue);
  });
}
