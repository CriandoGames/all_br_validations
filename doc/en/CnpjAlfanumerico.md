# CnpjAlfanumerico — 2026 Alphanumeric CNPJ

`CnpjAlfanumerico` implements the package's alphanumeric CNPJ rule associated
with IN RFB 2229/2024. The first twelve positions may contain uppercase
letters/digits and the last two positions are numeric check digits.

```dart
import 'package:all_br_validations/all_br_validations.dart';
```

## Accepted input

Validation strips the documented punctuation, normalizes letters to uppercase,
requires fourteen resulting characters, rejects unsupported characters and
repeated-character values, and verifies both check digits.

```dart
CnpjAlfanumerico.isValid('12ABC34501DE35');
CnpjAlfanumerico.isValid('12.ABC.345/01DE-35');
```

Numeric legacy CNPJ values remain accepted when their check digits satisfy the
same public compatibility path. Use `AllValidations.isCnpj` when an API must
explicitly accept only the numeric historical format.

`isValid(null)` returns false. Validation proves neither registration nor
ownership.

## Strip and normalization

```dart
CnpjAlfanumerico.strip('12.Abc.345/01de-35'); // 12ABC34501DE35
```

`strip` uppercases and removes punctuation outside the supported
alphanumeric body. Validate after stripping when input trust matters.

## Formatting

```dart
CnpjAlfanumerico.format('12ABC34501DE35');
// 12.ABC.345/01DE-35
```

`format` requires fourteen characters after stripping and throws
`ArgumentError` for a different length. It does not verify the alphabet or
check digits; call `isValid` at an external boundary.

## Generating test values

```dart
final raw = CnpjAlfanumerico.generate();
final masked = CnpjAlfanumerico.generate(formatted: true);
final numericBody = CnpjAlfanumerico.generate(
  formatted: false,
  forceAlphanumeric: false,
);
```

Generation creates a body from `validChars`, calculates the two digits, and can
return masked output. Use generated values only in tests and examples. They do
not represent an organization and must not be used as real registration data.

`validChars` is a public static list retained for callers that need the
supported body alphabet.

## Flutter input masks

This package is pure Dart and does not expose a `TextInputFormatter`. Use
`CnpjAlfaMask` from `all_br_forms` for keystrokes, then validate the final value
with `CnpjAlfanumerico.isValid`.

```dart
// Flutter layer:
// TextField(inputFormatters: [const CnpjAlfaMask()])
```

A mask shapes input but does not prove check digits.

## Preformatted values

Prepare initial text in the pure Dart layer, then hand the string to Flutter:

```dart
final initialText = CnpjAlfanumerico.format(rawCnpj);
// TextEditingController(text: initialText)
```

## Related facades

```dart
AllValidations.isCnpjAlphanumeric(value);
BrZod().cnpjAlfa().build(value);
```

Both delegate to this canonical implementation.
