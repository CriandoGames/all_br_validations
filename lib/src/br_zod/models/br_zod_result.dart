/// Resultado de [BrZod.validate] — usado na validação de Maps.
class BrZodResult {
  /// `true` quando todos os campos são válidos.
  final bool isValid;

  /// `true` quando ao menos um campo é inválido.
  bool get isNotValid => !isValid;

  /// Mapa de erros: chave → mensagem (pode ser aninhado para objetos).
  final Map<String, dynamic> errors;

  /// Lista plana de erros no formato `"campo: mensagem"`.
  final List<String> errorList;

  /// Cria um resultado com seu estado e as duas representações dos erros.
  ///
  /// [errors] preserva o aninhamento do schema; [errorList] usa caminhos com
  /// pontos, como `user.email: E-mail inválido`. As coleções são copiadas e
  /// tornadas profundamente imutáveis.
  BrZodResult({
    required this.isValid,
    required Map<String, dynamic> errors,
    required List<String> errorList,
  })  : errors = _freezeErrorMap(errors),
        errorList = List<String>.unmodifiable(errorList);

  @override
  String toString() => 'BrZodResult(isValid: $isValid, errors: $errors)';
}

Map<String, dynamic> _freezeErrorMap(Map<String, dynamic> source) {
  return Map<String, dynamic>.unmodifiable(
    source.map((key, value) => MapEntry(key, _freezeErrorValue(value))),
  );
}

dynamic _freezeErrorValue(dynamic value) {
  if (value is Map<String, dynamic>) return _freezeErrorMap(value);
  if (value is Map) {
    return Map<dynamic, dynamic>.unmodifiable(
      value.map((key, nested) => MapEntry(key, _freezeErrorValue(nested))),
    );
  }
  if (value is List) {
    return List<dynamic>.unmodifiable(value.map(_freezeErrorValue));
  }
  return value;
}
