import 'dart:convert';

/// Valida o subconjunto de endereços de e-mail suportado pelo pacote.
///
/// A regra é intencionalmente menor que a RFC 5322 e compartilhada pelas
/// APIs `AllValidations`, `Contract` e `BrZod`. Respeita os limites SMTP de
/// 64 octetos na parte local e 254 no endereço completo, além de limitar o
/// domínio a 255 octetos.
bool isAllowedEmail(String value) {
  final parts = value.split('@');
  if (parts.length != 2) return false;

  final local = parts[0];
  final domain = parts[1];
  if (utf8.encode(local).length > 64) return false;
  if (utf8.encode(domain).length > 255) return false;
  if (utf8.encode(value).length > 254) return false;

  final localPart = RegExp(
    r'^[A-Za-z0-9_+\-]+(?:\.[A-Za-z0-9_+\-]+)*$',
  );
  if (!localPart.hasMatch(local)) return false;

  final labels = domain.split('.');
  if (labels.length < 2) return false;
  if (!RegExp(r'^[A-Za-z]{2,}$').hasMatch(labels.last)) return false;

  final domainLabel = RegExp(
    r'^[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?$',
  );
  return labels.every(
    (label) => label.length <= 63 && domainLabel.hasMatch(label),
  );
}
