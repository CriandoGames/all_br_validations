import 'dart:math';

/// Retorna se os doze dígitos da base de um CNPJ são todos zero.
bool isZeroCnpjBase(String digits) => RegExp(r'^0{12}$').hasMatch(digits);

/// Gera uma base aleatória de doze dígitos que não produz o CNPJ inválido
/// `00.000.000/0000-00`.
List<int> generateCnpjBase(Random random) {
  List<int> digits;
  do {
    digits = List.generate(12, (_) => random.nextInt(10));
  } while (isZeroCnpjBase(digits.join()));
  return digits;
}
