import 'package:all_br_validations/all_br_validations.dart';

void main() {
  final cpfIsValid = AllValidations.isCpf('529.982.247-25');
  final error = BrZod().required().cpf().build('529.982.247-25');
  final contract = Contract().isValidCPF(
    '529.982.247-25',
    'cpf',
    'CPF inválido',
  );

  print('direto=$cpfIsValid zod=$error contrato=${contract.isValid}');
}
