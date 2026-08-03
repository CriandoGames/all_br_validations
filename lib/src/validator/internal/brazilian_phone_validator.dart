import '../../helpers/constants.dart';

/// Tipo de assinante aceito pela regra canônica de telefone brasileiro.
enum BrazilianPhoneType {
  /// Celular com nove dígitos e prefixo 9.
  cellPhone,

  /// Telefone fixo com oito dígitos e prefixo de 2 a 5.
  landline,

  /// Celular ou telefone fixo.
  any,
}

/// Valida [input] segundo formato, DDD e tipo de assinante.
///
/// [requireAreaCode] controla a obrigatoriedade do DDD e [allowCountryCode]
/// permite o prefixo brasileiro 55 nos formatos reconhecidos.
bool isValidBrazilianPhone(
  String input, {
  required BrazilianPhoneType type,
  required bool requireAreaCode,
  required bool allowCountryCode,
}) {
  if (input.isEmpty) return false;

  final parsed = _parseBrazilianPhoneFormat(input);
  if (parsed == null) return false;
  if (parsed.hasCountryCode && !allowCountryCode) return false;

  var nationalNumber = parsed.digits;
  if (parsed.hasCountryCode) {
    nationalNumber = nationalNumber.substring(2);
  }

  final hasAreaCode =
      nationalNumber.length == 10 || nationalNumber.length == 11;
  if (requireAreaCode && !hasAreaCode) return false;
  if (!hasAreaCode &&
      nationalNumber.length != 8 &&
      nationalNumber.length != 9) {
    return false;
  }

  var subscriber = nationalNumber;
  if (hasAreaCode) {
    final areaCode = nationalNumber.substring(0, 2);
    if (!Constants.dddToState.containsKey(areaCode)) return false;
    subscriber = nationalNumber.substring(2);
  }

  final isCellPhone = subscriber.length == 9 && subscriber.startsWith('9');
  final isLandline = subscriber.length == 8 &&
      const {'2', '3', '4', '5'}.contains(subscriber[0]);

  return switch (type) {
    BrazilianPhoneType.cellPhone => isCellPhone,
    BrazilianPhoneType.landline => isLandline,
    BrazilianPhoneType.any => isCellPhone || isLandline,
  };
}

_ParsedBrazilianPhone? _parseBrazilianPhoneFormat(String input) {
  if (RegExp(r'^\+55\d{10,11}$').hasMatch(input) ||
      RegExp(r'^\+55 \d{2} \d{4,5}-\d{4}$').hasMatch(input)) {
    return _ParsedBrazilianPhone(
      input.replaceAll(RegExp(r'[^0-9]'), ''),
      hasCountryCode: true,
    );
  }

  if (RegExp(r'^55\d{10,11}$').hasMatch(input)) {
    return _ParsedBrazilianPhone(input, hasCountryCode: true);
  }

  if (RegExp(r'^\(\d{2}\) \d{4,5}-\d{4}$').hasMatch(input) ||
      RegExp(r'^\d{2} \d{4,5}-\d{4}$').hasMatch(input)) {
    return _ParsedBrazilianPhone(
      input.replaceAll(RegExp(r'[^0-9]'), ''),
      hasCountryCode: false,
    );
  }

  if (RegExp(r'^\d{8,11}$').hasMatch(input)) {
    return _ParsedBrazilianPhone(input, hasCountryCode: false);
  }

  return null;
}

final class _ParsedBrazilianPhone {
  const _ParsedBrazilianPhone(
    this.digits, {
    required this.hasCountryCode,
  });

  final String digits;
  final bool hasCountryCode;
}
