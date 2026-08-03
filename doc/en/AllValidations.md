# AllValidations — Brazilian Rules and Utilities

`AllValidations` is a non-instantiable facade of static, pure Dart methods.
Boolean methods return `false` for a value outside their documented contract;
the `validate*` family returns `Result<ValidationError, String>`.

```dart
import 'package:all_br_validations/all_br_validations.dart';

final valid = AllValidations.isCpf('529.982.247-25');
```

## Generic types and formats

| Method | Accepted contract |
|---|---|
| `isNull(value)` | true only for null |
| `isNum(value)` | string parsed by `num.tryParse` |
| `isNumericOnly(value)` | one or more decimal digits; no sign or decimal point |
| `isNumericFloat(value)` | complete signed decimal/exponent, or the historical empty alternative; punctuation/exponent alone is rejected |
| `isAlphabetOnly(value)` | ASCII letters only, no whitespace |
| `isBool(value)` | literal string `true` or `false` |
| `isInt(value)` | signed integer with no invalid leading shape |
| `isLowercase` / `isUppercase` | compares the value with Dart case conversion |
| `isJSON(value)` | `jsonDecode` completes without throwing |
| `isBinary(value)` | only `0` and `1`, at least one character |
| `isHexadecimal(value)` | 3 or 6 hexadecimal digits with optional `#` |

`hasMatch(value, pattern)` is the public regex helper used by historical
callers. An invalid regex still throws `FormatException` when constructed.

## Email and URL

```dart
AllValidations.isEmail('dev+tag@example.com'); // true
AllValidations.isURL('https://example.com/path'); // true
```

Email accepts a practical address grammar, including `+` in the local part.
It does not prove that a mailbox exists. URL accepts `http`, `https`, or `ftp`,
requires a non-empty host, and rejects whitespace. It does not fetch the URL.

`BrZod.email` and `Contract.isEmail` delegate to the same canonical email
rule. `BrZod.url` and `Contract.isURL` use the same canonical URL rule.

## Hash strings, identifiers, and networks

| Method | Behavior |
|---|---|
| `isMD5` | 32 lowercase hexadecimal characters |
| `isSHA1` | 40 hex characters or colon-separated bytes |
| `isSHA256` | 64 hex characters or colon-separated bytes |
| `isUUID(value, version)` | versions `3`, `4`, `5`, or structural `all`; null is false |
| `isIPv4` | IPv4 regex used by the historical facade |
| `isIPv6` | complete/compressed IPv6, including `::`, embedded IPv4, and an optional zone suffix |
| `isSSN` | US SSN format validation; no external lookup |

These methods recognize shapes only. They do not calculate a hash, allocate an
identifier, contact a network, or establish authenticity.

## Date and time

`isDateTime` accepts an integral timestamp shaped as
`YYYY-MM-DD HH:MM:SS.mmm` or `YYYY-MM-DDTHH:MM:SS.mmm`, with optional trailing
`Z`. Parsing must round-trip every captured component, so impossible dates are
rejected instead of normalized.

Use [`BrData`](BrData.md) for Brazilian `DD/MM/YYYY` formatting and parsing.

## File-extension checks

`isVideo`, `isImage`, `isAudio`, `isPDF`, `isTxt`, `isChm`, `isVector`, and
`isHTML` compare the complete lowercased extension. Subtitle `.srt` is not
classified as video. They do not inspect file contents,
MIME type, signatures, availability, or safety. Treat them as UI/convenience
checks, not upload security controls.

## Brazilian documents

| Method | Accepted presentation | Validation |
|---|---|---|
| `isCpf` | 11 digits or `000.000.000-00` | check digits; repeated digits rejected |
| `isCnpj` | 14 digits or `00.000.000/0000-00` | numeric check digits; repeated digits rejected |
| `isCnpjAlphanumeric` | 14 alphanumeric characters, optionally masked | delegates to `CnpjAlfanumerico` |
| `isRG` | 7–9 digit state-agnostic shape with optional punctuation and final digit/X | format only |
| `isCnh` | 11 digits | CNH check digits |
| `isRenavam` | 11 digits | RENAVAM check digit |
| `isPisPasep` | 11 digits, punctuation accepted by its documented grammar | check digit |
| `isTituloEleitor` | 12 digits | state and check digits |
| `isCns` | 15 digits | canonical CNS rule |

Valid format and check digits do not prove that a document exists or belongs
to a person. Do not put real personal documents in issues or tests.

## CEP, phones, DDD, and state

`isValidBRZip` accepts exactly these forms:

- `01001000`;
- `01001-000`;
- `01.001-000`.

It validates format, not address existence.

`isBrazilianCellPhone` requires DDD plus nine subscriber digits starting with
9. It accepts digits or the documented `DD XXXXX-XXXX` and
`(DD) XXXXX-XXXX` masks. It also accepts country code 55 in a digit-only value
or as `+55` in the documented international forms. Arbitrary punctuation,
extra text, and surrounding spaces are rejected before normalization.
`isBrazilianLandline` requires DDD plus eight digits starting with 2–5 and
applies the same country-code rule.

```dart
AllValidations.isBrazilianCellPhone('(11) 91234-5678');
AllValidations.isBrazilianLandline('(11) 3456-7890');
AllValidations.isValidDDD('11');
AllValidations.getStateByDDD('11'); // BrazilianState.SP
```

Unknown DDD mapping returns `BrazilianState.Unknown`. `BrZod.phone` preserves
an intentional historical difference: it accepts an 8- or 9-digit subscriber
number without DDD. `Contract.isPhoneNumber` uses the stricter direct rules and
therefore requires DDD.

## Other validation rules

| Method | Contract |
|---|---|
| `isCreditCard` | accepted grouped/plain card shapes, known prefix grammar, and Luhn checksum |
| `isValidBrazilianLicensePlate` | legacy `ABC-1234`/`ABC1234` or Mercosur `ABC1D23` |
| `isValidHexColor` | `#RGB` or `#RRGGBB` |
| `isValidEAN13` | 13 digits with EAN-13 check digit |
| `isMediumPassword` | historical medium-password grammar |
| `isStrongPassword` | 8–99 non-space characters with upper, lower, digit, and supported special character |
| `isPalindrome` | accents/non-alphanumerics removed before case-insensitive comparison |
| `isNickname` | ASCII alphanumeric endpoints with alphanumeric/underscore/dot inside |
| `isName` | name grammar documented by the API; no identity check |
| `isLowerThan`, `isGreaterThan`, `isEqual` | direct numeric comparisons |
| `isPhraseEqual` | normalized phrase comparison |

Card validation does not authorize a payment or prove account status. Password
shape validation is not password hashing, breach checking, or authentication.

## Text helpers

`removeCharacters` removes every non-alphanumeric ASCII character and asserts
that input is not empty in assertion-enabled builds. `removeAccents` replaces
characters from the package's historical accent table. Neither is a complete
Unicode normalization or sanitization API.

## Nested Map keys

`isMapExists(key: path, map: data)` verifies that every listed key is present
and non-null. Empty strings and collections count as existing values. The
method does not log keys or values.

## Typed validate methods

Each method below returns `Success<String>` with the normalized or original
accepted value documented by that method, or `Failure<ValidationError>` with
property/message details:

| Direct rule | Typed method |
|---|---|
| CPF | `validateCPF` |
| CNPJ | `validateCNPJ` |
| email | `validateEmail` |
| CEP | `validateCEP` |
| mobile | `validateCellPhone` |
| landline | `validateLandline` |
| CNH | `validateCNH` |
| RENAVAM | `validateRENAVAM` |
| PIS/PASEP | `validatePIS` |
| voter ID | `validateTituloEleitor` |
| RG | `validateRG` |
| plate | `validateLicensePlate` |
| URL | `validateURL` |
| UUID | `validateUUID` |
| strong password | `validateStrongPassword` |
| card | `validateCreditCard` |
| PIX key | `validatePixKey` |

```dart
final result = AllValidations.validateCPF(
  '529.982.247-25',
  property: 'cpf',
);

result.fold(
  (error) => print('${error.field}: ${error.message}'),
  (value) => print(value),
);
```

See `all_result` for `Result<F, S>` composition. Failure is the first generic
parameter.

## PIX keys

PIX validation classifies supported keys by their documented shape (CPF,
numeric or alphanumeric CNPJ, phone, email, or EVP/UUID) and reuses canonical
rules where applicable. Alphanumeric CNPJ is accepted unmasked, matching the
DICT key shape.
It does not contact a payment provider and cannot prove registration or
ownership.

## Utility lists and models

The package exports `AllValidationsGetMonth`, `AllValidationsGetWeek`,
`AllValidationsGetRegions`, `AllValidationsGetStates`, and `BrazilianState`.
These are static Portuguese-language lists/models retained for compatibility.

## Facade consistency

The direct facade is the source for Brazilian document rules used by `BrZod`
and `Contract`. Shared CPF, CNPJ, CEP, email, URL, strong-password, and UUID
behavior is covered by cross-facade tests. The documented phone difference is
intentional and tested.

## Quick reference

```dart
AllValidations.isCpf('529.982.247-25');
AllValidations.isCnpj('11.222.333/0001-81');
AllValidations.isCnpjAlphanumeric('12ABC34501DE35');
AllValidations.isValidBRZip('01001-000');
AllValidations.isEmail('dev@example.com');
AllValidations.isURL('https://example.com');
AllValidations.isUUID('550e8400-e29b-41d4-a716-446655440000');
```
