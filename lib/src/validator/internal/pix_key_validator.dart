import 'brazilian_phone_validator.dart';

final RegExp _pixPhone = RegExp(r'^\+55\d{2}9\d{8}$');
final RegExp _pixEmail = RegExp(
  r"^[a-z0-9.!#$'*+\/=?^_`{|}~-]+@[a-z0-9]"
  r'(?:[a-z0-9-]{0,61}[a-z0-9])?'
  r'(?:\.[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?)*$',
);
final RegExp _pixEvp = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-'
  r'[0-9a-f]{4}-[0-9a-f]{12}$',
);

/// Valida uma chave PIX de telefone brasileira no formato E.164 do DICT.
bool isValidPixPhone(String value) {
  return _pixPhone.hasMatch(value) &&
      isValidBrazilianPhone(
        value,
        type: BrazilianPhoneType.cellPhone,
        requireAreaCode: true,
        allowCountryCode: true,
      );
}

/// Valida uma chave PIX de e-mail conforme a expressão e o limite do DICT.
bool isValidPixEmail(String value) {
  return value.length <= 77 && _pixEmail.hasMatch(value);
}

/// Valida o formato hexadecimal agrupado de uma EVP gerada pelo DICT.
bool isValidPixEvp(String value) => _pixEvp.hasMatch(value);
