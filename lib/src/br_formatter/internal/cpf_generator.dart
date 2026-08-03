import 'dart:math';

/// Retorna se os nove dígitos da base de um CPF são todos iguais.
///
/// Este helper é interno ao pacote e existe para que a regra do gerador possa
/// ser verificada deterministicamente sem expor injeção de aleatoriedade na
/// API pública de `BrFormatter.generateCpf`.
bool isRepeatedCpfBase(String digits) => RegExp(r'^(.)\1{8}$').hasMatch(digits);

/// Gera uma base aleatória de nove dígitos para o cálculo de um CPF.
List<int> generateCpfBase(Random random) {
  List<int> digits;
  do {
    digits = List.generate(9, (_) => random.nextInt(10));
  } while (isRepeatedCpfBase(digits.join()));
  return digits;
}
