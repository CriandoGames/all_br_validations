/// Regra canônica do Cartão Nacional de Saúde (CNS).
bool isValidCns(String value) {
  if (!RegExp(r'^\d{15}$').hasMatch(value)) return false;

  final first = int.parse(value[0]);
  if (![1, 2, 7, 8, 9].contains(first)) return false;

  var sum = 0;
  for (var i = 0; i < 15; i++) {
    sum += int.parse(value[i]) * (15 - i);
  }
  return sum % 11 == 0;
}
