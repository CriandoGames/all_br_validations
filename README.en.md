# all_br_validations

[🇧🇷 Português](README.md) | 🇺🇸 English

[![pub package](https://img.shields.io/pub/v/all_br_validations.svg)](https://pub.dev/packages/all_br_validations)
[![CI](https://github.com/CriandoGames/all_br_validations/actions/workflows/ci.yml/badge.svg)](https://github.com/CriandoGames/all_br_validations/actions/workflows/ci.yml)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Reusable pure Dart core for Brazilian data validation and formatting, with
direct, fluent, and contract-based APIs.
Canonical rules avoid copying the same validation across application layers.

![all_br_validations hero](https://raw.githubusercontent.com/CriandoGames/all_br_validations/main/documentation/images/hero.png)

## Where to use it

- Customer and company registration in Dart or Flutter applications.
- Forms, DTOs, and API payloads with errors organized by field.
- Onboarding, checkout, and back-office flows with Brazilian data formats.
- Packages that need shared canonical rules without depending on Flutter.

## Features

- CPF, numeric and alphanumeric CNPJ, CNH, RENAVAM, PIS/PASEP, RG, and CNS.
- CEP, DDD, phones, license plates, PIX keys, EAN-13, and Luhn cards.
- Email, URL, UUID, IP, dates, files, numbers, and passwords.
- Fluent validation with `BrZod` and contracts with accumulated notifications.
- `BrFormatter`, `BrData`, null-safe extensions, and geographic models.
- `Result` integration through `all_result`.

## Foundation for other packages

`all_br_validations` is the ecosystem's validation core and is designed for
direct use by applications and other packages. It has no Flutter dependency,
maintains a SemVer-versioned public API, and centralizes canonical rules covered
by tests so each library does not need to reimplement CPF, CNPJ, contracts, and
formatting.

For a smaller dependency surface, import only the required entry point. New
packages that need Brazilian validation should depend on `all_br_validations`,
not on the `all_validations_br` aggregator.

## Validation catalog

| Category | Available validations |
|---|---|
| Brazilian documents | CPF, numeric CNPJ, alphanumeric CNPJ, RG, CNH, RENAVAM, PIS/PASEP, voter registration, and CNS |
| Address and contact | CEP, DDD, Brazilian mobile and landline phones, email, and URL |
| Vehicles, payments, and codes | Legacy and Mercosur license plates, Luhn cards, EAN-13, and PIX keys using CPF, mobile phone, email, or UUID v4 |
| Identifiers, network, and hashes | UUID v3/v4/v5, IPv4, IPv6, JSON, SSN, hexadecimal, MD5, SHA-1, and SHA-256 |
| Dates, types, and text | Brazilian dates, ISO 8601 datetime, number, integer, decimal, boolean, binary, alphabetic, uppercase, lowercase, name, nickname, and palindrome |
| Security and formats | Medium or strong passwords, custom regex, and hexadecimal colors |
| Files by extension | Image, video, audio, PDF, TXT, CHM, SVG, and HTML |
| Generic contracts | Required/optional, null/empty, equality, ordering, ranges, length, content, type, enum, uniqueness, dates, and custom rules |
| Utilities | State by DDD, map key presence, phrase comparison, and character/accent removal |

The package provides four validation styles, with each API's coverage
documented separately:

| API | Usage |
|---|---|
| `AllValidations.is*` | Direct `bool` result |
| `AllValidations.validate*` | `Result<ValidationError, String>` with a normalized value |
| `BrZod` | Fluent schemas, composition, and map validation |
| `Contract` | Chained rules with accumulated notifications |

See the complete [`AllValidations` reference](doc/en/AllValidations.md), the
[`BrZod` catalog](doc/en/BrZod.md), and the
[contracts](doc/en/Contract.md) for methods, accepted formats, and return
values.

## Installing

```yaml
dependencies:
  all_br_validations: ^1.0.1
```

## Usage

### Direct validation

```dart
import 'package:all_br_validations/all_br_validations.dart';

final validCpf = AllValidations.isCpf('529.982.247-25');
final validAlphanumericCnpj =
    AllValidations.isCnpjAlphanumeric('12ABC34501DE35');
final validMobile =
    AllValidations.isBrazilianCellPhone('(11) 91234-5678');
final validPlate = AllValidations.isValidBrazilianLicensePlate('ABC1D23');
final pix = AllValidations.validatePixKey('customer@example.com');
```

Phones accept digits or the documented masks only; arbitrary punctuation,
extra text, and surrounding spaces are rejected. Direct validation and
`Contract` require DDD and accept `+55`. `BrZod.phone()` also accepts local
8- or 9-digit phones, but it does not accept a country code.

### Complete registration with `BrZod`

Validate an entire payload and receive errors organized by field:

```dart
final result = BrZod.validate(
  data: {
    'email': 'customer@example.com',
    'cpf': '529.982.247-25',
    'phone': '(11) 91234-5678',
    'cep': '01310-100',
    'password': 'Secure@123',
  },
  params: {
    'email': BrZod().required().email(),
    'cpf': BrZod().required().cpf(),
    'phone': BrZod().required().phone(),
    'cep': BrZod().required().cep(),
    'password': BrZod().required().password(),
  },
);

if (result.isNotValid) {
  print(result.errors);    // errors structured by field
  print(result.errorList); // flat list for logs or UI
}
```

### Validation with a normalized value

The `validate*` APIs avoid exceptions and return a typed `Result`:

```dart
AllValidations.validateCPF('529.982.247-25').fold(
  (error) => print('${error.property}: ${error.message}'),
  (cpf) => print(cpf), // 52998224725
);

AllValidations.validateEmail('Customer@Example.com').fold(
  (error) => print(error.message),
  (email) => print(email), // customer@example.com
);
```

### Accumulated business rules

```dart
final contract = Contract();
contract
  ..isGreaterOrEqualsThan(
      16,
      18,
      'age',
      'You must be at least 18 years old.',
    )
  ..isTrue(false, 'terms', 'You must accept the terms.');

print(contract.isValid);       // false
print(contract.notifications); // both errors, without fail-fast
```

Order comparators accept `num` with `num` (including `int` with `double`) and
`DateTime` with `DateTime`. Incompatible types do not throw; they add exactly
one notification to the contract.

### Formatting and alphanumeric CNPJ

```dart
BrFormatter.formatCpf('52998224725');   // 529.982.247-25
BrFormatter.formatPhone('11912345678'); // (11) 91234-5678
BrFormatter.formatCurrency(1234.5);     // R$ 1.234,50

const cnpj = '12ABC34501DE35';
CnpjAlfanumerico.isValid(cnpj); // true
CnpjAlfanumerico.format(cnpj);  // 12.ABC.345/01DE-35
```

The [runnable example](example/all_br_validations_example.dart) combines these
APIs into a complete registration flow. Run it with:

```bash
dart run example/all_br_validations_example.dart
```

## Which API should I choose?

| Need | Recommended API |
|---|---|
| Only check whether a value is valid | `AllValidations.is*` |
| Validate and receive a normalized value or typed error | `AllValidations.validate*` |
| Validate fields or complete payloads with messages | `BrZod` |
| Accumulate domain rules and violations | `Contract` |
| Prepare data for display or persistence | `BrFormatter`, `BrData`, and `CnpjAlfanumerico` |

### Where to use `BrZod`, `Result`, and `Contract`

Use each API in the layer where it provides the most value:

| API | Where to use it | Example |
|---|---|---|
| `BrZod` | Application input: forms, controllers, DTOs, and API payloads | Check formats and required fields, returning errors by field |
| `Result` | Services and use cases that must represent success or failure without throwing expected exceptions | Validate and normalize a CPF, email, or PIX key before persistence |
| `Contract` | Entities and business rules involving one or more values | Minimum age, accepted terms, and domain-defined limits |

A practical registration flow is:

```text
Untrusted input → BrZod → Result with normalized data → Contract → persist
```

- `BrZod` answers: **do the received fields have valid formats?**
- `Result` answers: **did the operation succeed or fail, and which safe value did it produce?**
- `Contract` answers: **does the data comply with business rules?**

They can be combined. Validate the payload with `BrZod`, normalize the CPF
with `AllValidations.validateCPF()`, and enforce entity rules with `Contract`.
Use `Contract.toResult()` when domain violations should join the same typed
success-or-failure flow.

Avoid using `Contract` only to check an isolated field when an `is*` method or
`BrZod` solves the case. Likewise, do not use `BrZod` for rules that depend on
entity state or business decisions.

Focused entry points are also available:

```dart
import 'package:all_br_validations/br_zod.dart';
import 'package:all_br_validations/validation.dart';
import 'package:all_br_validations/regions_validations.dart';
```

The APIs are safe to use as a foundation for other libraries within their
documented public contract. Validation checks formats, digits, and local rules;
it does not prove identity, ownership, or official document existence.
`TextInputFormatter`-based masks are provided by `all_br_forms`.

## Documentation

See [doc/en](doc/en), the [contributing guide](CONTRIBUTING.en.md), and the
[security policy](SECURITY.en.md). Do not use real personal documents in
issues, examples, or tests. Licensed under [MIT](LICENSE).
