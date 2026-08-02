# all_br_validations

[![pub package](https://img.shields.io/pub/v/all_br_validations.svg)](https://pub.dev/packages/all_br_validations)
[![CI](https://github.com/CriandoGames/all_br_validations/actions/workflows/ci.yml/badge.svg)](https://github.com/CriandoGames/all_br_validations/actions/workflows/ci.yml)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

[🇧🇷 Português](README.md) | 🇺🇸 English

Pure Dart validation and formatting for Brazilian data, with direct, fluent,
and contract-based APIs.
Canonical rules avoid copying the same validation across application layers.

![all_br_validations hero](https://raw.githubusercontent.com/CriandoGames/all_br_validations/main/documentation/images/hero.png)

## Features

- CPF, numeric and alphanumeric CNPJ, CNH, RENAVAM, PIS/PASEP, RG, and CNS.
- CEP, DDD, phones, license plates, PIX keys, EAN-13, and Luhn cards.
- Email, URL, UUID, IP, dates, files, numbers, and passwords.
- Fluent validation with `BrZod` and contracts with accumulated notifications.
- `BrFormatter`, `BrData`, null-safe extensions, and geographic models.
- `Result` integration through `all_result`.

## Installing

```yaml
dependencies:
  all_br_validations: ^1.0.0
```

## Usage

```dart
import 'package:all_br_validations/all_br_validations.dart';

final validCpf = AllValidations.isCpf('529.982.247-25');
final error = BrZod().required().cpf().build('529.982.247-25');

final contract = Contract().isValidCPF(
  '529.982.247-25',
  'cpf',
  'Invalid CPF',
);
```

Focused entry points are also available:

```dart
import 'package:all_br_validations/br_zod.dart';
import 'package:all_br_validations/validation.dart';
import 'package:all_br_validations/regions_validations.dart';
```

Masks only format input; they do not prove identity or document existence.
`TextInputFormatter`-based masks are provided by `all_br_forms`.

## Documentation

See [doc/en](doc/en), the [contributing guide](CONTRIBUTING.en.md), and the
[security policy](SECURITY.en.md). Do not use real personal documents in
issues, examples, or tests. Licensed under [MIT](LICENSE).
