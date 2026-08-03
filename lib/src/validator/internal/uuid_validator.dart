/// Valida a estrutura, a versão e a variante de um UUID RFC 4122.
///
/// Por padrão, aceita somente as versões públicas suportadas pelo pacote:
/// 3, 4 e 5. Consumidores internos, como a chave aleatória PIX, podem fornecer
/// outro conjunto explícito de versões permitidas.
bool isValidUuid(
  String value, {
  Set<int> allowedVersions = const {3, 4, 5},
}) {
  final match = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-([0-9a-f])[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    caseSensitive: false,
  ).firstMatch(value);
  if (match == null) return false;

  final version = int.parse(match.group(1)!, radix: 16);
  return allowedVersions.contains(version);
}
