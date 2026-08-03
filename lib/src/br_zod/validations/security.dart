/// Funções puras de validação de segurança usadas pelo [BrZod].
///
/// Separadas da classe principal para facilitar testes unitários
/// e eventual extração do módulo como pacote standalone.
library;

import '../../validator/internal/url_validator.dart';
import '../../validator/internal/ip_validator.dart';
import '../../validator/internal/uuid_validator.dart';

// ── Senha ────────────────────────────────────────────────────

/// Configuração de política de senha para [isPassword].
class PasswordPolicy {
  /// Quantidade mínima de caracteres.
  final int minLength;

  /// Quantidade máxima de caracteres, ou `null` para não limitar.
  final int? maxLength;

  /// Permite caracteres de espaço em branco.
  final bool allowWhitespace;

  /// Exige ao menos uma letra ASCII maiúscula.
  final bool requireUppercase;

  /// Exige ao menos uma letra ASCII minúscula.
  final bool requireLowercase;

  /// Exige ao menos um dígito ASCII.
  final bool requireNumber;

  /// Exige ao menos um símbolo da lista reconhecida por [isPassword].
  final bool requireSpecial;

  /// Cria uma política configurável.
  ///
  /// Por padrão equivale a [strong].
  const PasswordPolicy({
    this.minLength = 8,
    this.maxLength = 99,
    this.allowWhitespace = false,
    this.requireUppercase = true,
    this.requireLowercase = true,
    this.requireNumber = true,
    this.requireSpecial = true,
  });

  /// Política fraca: apenas comprimento mínimo de 6.
  static const weak = PasswordPolicy(
    minLength: 6,
    maxLength: null,
    allowWhitespace: true,
    requireUppercase: false,
    requireLowercase: false,
    requireNumber: false,
    requireSpecial: false,
  );

  /// Política média: maiúscula + minúscula + número, mínimo 6.
  static const medium = PasswordPolicy(
    minLength: 6,
    maxLength: null,
    allowWhitespace: true,
    requireUppercase: true,
    requireLowercase: true,
    requireNumber: true,
    requireSpecial: false,
  );

  /// Política forte: todos os requisitos, de 8 a 99 caracteres, sem espaços.
  static const strong = PasswordPolicy();
}

/// Valida senha conforme [policy] (padrão: forte — 8+ chars, maiúscula,
/// minúscula, número e símbolo, máximo 99 e sem espaços).
bool isPassword(dynamic value,
    {PasswordPolicy policy = PasswordPolicy.strong}) {
  if (value is! String) return false;
  final s = value;
  if (s.length < policy.minLength) return false;
  if (policy.maxLength case final maxLength?) {
    if (s.length > maxLength) return false;
  }
  if (!policy.allowWhitespace && s.contains(RegExp(r'\s'))) return false;
  if (policy.requireUppercase && !s.contains(RegExp(r'[A-Z]'))) return false;
  if (policy.requireLowercase && !s.contains(RegExp(r'[a-z]'))) return false;
  if (policy.requireNumber && !s.contains(RegExp(r'[0-9]'))) return false;
  if (policy.requireSpecial &&
      !s.contains(RegExp(r'[~!@#$%^&*()_\-+=|\\{}\[\]:;<>?/]'))) {
    return false;
  }
  return true;
}

// ── UUID ─────────────────────────────────────────────────────

/// Valida UUID. Por padrão aceita as versões 3, 4 e 5 (`all`).
/// Versões suportadas: `'3'`, `'4'`, `'5'`, `'all'`.
bool isUuid(dynamic value, {String version = 'all'}) {
  if (value == null) return false;

  final allowedVersions = switch (version) {
    '3' => const {3},
    '4' => const {4},
    '5' => const {5},
    'all' => const {3, 4, 5},
    _ => null,
  };

  return allowedVersions != null &&
      isValidUuid(
        value.toString(),
        allowedVersions: allowedVersions,
      );
}

// ── URL ──────────────────────────────────────────────────────

/// Valida URL com esquema `http`, `https` ou `ftp`.
bool isUrl(dynamic value) {
  final s = value?.toString() ?? '';
  return isAllowedUrl(s);
}

// ── IPv4 ─────────────────────────────────────────────────────

/// Valida endereço IPv4 no formato `0.0.0.0` a `255.255.255.255`.
bool isIpv4(dynamic value) {
  return value != null && isValidIpv4(value.toString());
}

// ── IPv6 ─────────────────────────────────────────────────────

/// Valida endereço IPv6 em formato completo ou comprimido (com `::` e zonas).
bool isIpv6(dynamic value) {
  return value != null && isValidIpv6(value.toString());
}

// ── Regex genérico ───────────────────────────────────────────

/// Valida [value] contra um padrão regex arbitrário.
bool matchesRegex(dynamic value, String pattern) {
  final s = value?.toString() ?? '';
  return RegExp(pattern).hasMatch(s);
}
