# BrFormatter — Brazilian Formatting and Generation

`BrFormatter` provides pure Dart formatting for CPF, numeric CNPJ, CEP,
Brazilian phones, BRL-like currency strings, and kilometers. Formatting is not
the same as document validation.

```dart
import 'package:all_br_validations/all_br_validations.dart';
```

## CPF

```dart
BrFormatter.stripCpf('529.982.247-25'); // 52998224725
BrFormatter.formatCpf('52998224725');   // 529.982.247-25
```

`formatCpf` expects exactly 11 digits after stripping supported punctuation and
throws `ArgumentError` when the length/shape is invalid. It formats digits;
use `AllValidations.isCpf` when check-digit validity is required.

### Generating CPF test values

```dart
final raw = BrFormatter.generateCpf();
final masked = BrFormatter.generateCpf(formatted: true);
```

Generation calculates valid check digits and is intended for tests/examples.
Generated values are synthetic but may coincidentally match assigned numbers;
never use them as identity or production data.

## Numeric CNPJ

```dart
BrFormatter.stripCnpj('11.222.333/0001-81'); // 11222333000181
BrFormatter.formatCnpj('11222333000181');   // 11.222.333/0001-81
```

`formatCnpj` covers the 14-digit numeric format. Use
`CnpjAlfanumerico.format` for the alphanumeric 2026 format.

```dart
final raw = BrFormatter.generateCnpj();
final masked = BrFormatter.generateCnpj(formatted: true);
```

Generated CNPJ values are for testing only. Formatting does not query
registration status.

## CEP

```dart
BrFormatter.stripCep('01001-000'); // 01001000
BrFormatter.formatCep('01001000'); // 01001-000
```

`formatCep` requires eight digits and throws `ArgumentError` otherwise. It
does not verify that an address exists.

## Phone

```dart
BrFormatter.stripPhone('(11) 91234-5678'); // 11912345678
BrFormatter.extractDdd('(11) 91234-5678'); // 11
BrFormatter.extractDdd('+55 11 91234-5678'); // 11
BrFormatter.extractDdd('912345678'); // empty: local number has no DDD
BrFormatter.formatPhone('11912345678');    // (11) 91234-5678
BrFormatter.formatPhone('11912345678', ddd: false); // 91234-5678
```

`formatPhone` requires 10 digits (DDD plus landline) or 11 digits (DDD plus
mobile). Passing `ddd: false` omits the two DDD digits from the output; it does
not make the input DDD optional. The method throws `ArgumentError` for
incompatible lengths. Formatting does not validate that
the DDD exists or that a number is active; use `AllValidations` as needed.
`extractDdd` recognizes complete 10/11-digit national numbers and removes a
Brazilian country code only from compatible 12/13-digit inputs.

## Currency

### Formatting

```dart
BrFormatter.formatCurrency(1234.56); // R$ 1.234,56
BrFormatter.formatCurrency(
  1234.5,
  symbol: false,
  decimals: 2,
);
```

The implementation uses separators and options exposed by the method; it does
not depend on `intl`. This is deterministic formatting, not locale negotiation
or monetary arithmetic. Use an appropriate decimal/money type when binary
floating-point precision is unacceptable.

### Parsing

```dart
BrFormatter.parseCurrency('R\$ 1.234,56'); // 1234.56
```

The parser follows the documented Brazilian separator shape and throws
`FormatException` for input it cannot interpret. Do not pass arbitrary user
text without handling that exception.

### Removing the symbol

```dart
BrFormatter.stripCurrencySymbol('R\$ 1.234,56'); // 1.234,56
```

This removes the recognized currency symbol/spacing only; it does not parse the
numeric value.

## Kilometers

```dart
BrFormatter.formatKm(12345); // 12.345 km
```

The value is an integer count and the method returns a presentation string.

## Flutter controllers

The formatter package is pure Dart. It can provide an initial controller value
without depending on Flutter:

```dart
final initialText = BrFormatter.formatCpf(cpfDigits);
// In the Flutter layer:
// final controller = TextEditingController(text: initialText);
```

For live keystroke masks, use `all_br_forms`. Do not add Flutter as a dependency
of this package merely to construct a controller.

## Exceptions and validation

Formatting methods that require an exact shape throw `ArgumentError`. Currency
parsing delegates invalid numeric input to `double.parse`, which throws
`FormatException`. Strip
methods return normalized text according to their narrow character-removal
rule. Generated values use randomness and should not be asserted as stable.

```dart
try {
  final formatted = BrFormatter.formatCpf(input);
  if (!AllValidations.isCpf(formatted)) {
    handleInvalidCpf();
  }
} on ArgumentError catch (error) {
  handleWrongShape(error);
}
```

## Quick reference

| Data | Strip | Format | Generate |
|---|---|---|---|
| CPF | `stripCpf` | `formatCpf` | `generateCpf` |
| numeric CNPJ | `stripCnpj` | `formatCnpj` | `generateCnpj` |
| CEP | `stripCep` | `formatCep` | — |
| phone | `stripPhone` | `formatPhone` | — |
| currency | `stripCurrencySymbol` | `formatCurrency` | — |
| KM | — | `formatKm` | — |
