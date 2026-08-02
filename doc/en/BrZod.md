# BrZod — Fluent Validation for Dart and Flutter

`BrZod` builds a reusable callback that returns null for valid input or the
first error message for invalid input. The implementation is pure Dart; the
callback shape is compatible with Flutter form validators without importing
Flutter.

```dart
import 'package:all_br_validations/br_zod.dart';
```

## Basic usage

```dart
final validator = BrZod().required().email().build;

validator('dev@example.com'); // null
validator('invalid');         // localized message
```

In Flutter, pass the tear-off to a form field:

```dart
TextFormField(
  validator: BrZod().required().email().build,
)
```

`BrZodCallback` is the public alias `String? Function(dynamic value)`.

## Execution order and optional values

Rules execute in chain order and stop at the first message. Put `optional`
before later rules; null and whitespace-only strings then short-circuit as
valid, while a present value continues through the chain.

```dart
final optionalEmail = BrZod().optional().email().build;

optionalEmail(null);              // null
optionalEmail('   ');             // null
optionalEmail('dev@example.com'); // null
optionalEmail('invalid');         // error
```

`required` rejects null and blank strings after trimming. A non-string value is
considered present and can be checked with `type<T>` or `custom`.

## Generic methods

| Method | Rule |
|---|---|
| `required([message])` | non-null and non-blank string/present non-string |
| `optional()` | skip remaining chain when null/blank |
| `min(n, [message])` | string representation length at least n |
| `max(n, [message])` | string representation length at most n |
| `email([message])` | canonical package email rule |
| `phone([message])` | Brazilian 8/9-digit subscriber or 10/11-digit DDD number |
| `equals(other, [message])` | values compare equal after string conversion |
| `type<T>([message])` | String/int/double/bool conversion rules, otherwise Dart `is T` |
| `custom(callback, {message})` | arbitrary boolean callback |
| `isDate([message])` | `dd/MM/yyyy`, `yyyy-MM-dd`, or parseable ISO 8601 form |
| `isBefore(max, [message])` | parsed date strictly before max |
| `isAfter(min, [message])` | parsed date strictly after min |

```dart
final schema = BrZod()
    .required('Required')
    .min(3, 'At least three characters')
    .max(40)
    .custom((value) => value != 'admin', message: 'Reserved name');
```

A throwing `custom` callback propagates its exception. Keep custom validation
pure because map validation invokes each schema once.

## Brazilian documents

| Method | Behavior |
|---|---|
| `cpf` | canonical CPF format/check digits |
| `cnpj` | canonical numeric CNPJ format/check digits |
| `cnpjAlfa` | canonical numeric/alphanumeric CNPJ rule |
| `cpfOuCnpj` | CPF or numeric CNPJ |
| `cep` | `00000000`, `00000-000`, or `00.000-000` |
| `rg` | common format with optional punctuation/final X |
| `placa` | legacy or Mercosur plate |
| `cnh` | canonical CNH check digits |
| `renavam` | canonical RENAVAM rule |
| `pisPasep` | canonical PIS/PASEP rule |
| `tituloEleitor` | canonical voter-ID rule |
| `cns` | canonical CNS rule |

```dart
final document = BrZod().required().cpfOuCnpj().build;
final newCnpj = BrZod().required().cnpjAlfa().build;
```

These rules validate shapes/check digits locally and do not prove identity,
existence, status, or ownership.

## Phone compatibility boundary

`BrZod.phone` intentionally preserves the historical acceptance of subscriber
numbers without DDD:

```dart
BrZod().phone().build('912345678');       // null
BrZod().phone().build('(11) 91234-5678'); // null
```

`Contract.isPhoneNumber` delegates to direct mobile/landline rules that require
DDD. This divergence is documented and covered by a dedicated regression test.

## PasswordPolicy

`password` accepts a public immutable policy:

```dart
BrZod().password(); // PasswordPolicy.strong
BrZod().password(policy: PasswordPolicy.medium);
BrZod().password(
  policy: const PasswordPolicy(
    minLength: 12,
    requireUppercase: true,
    requireLowercase: true,
    requireNumber: true,
    requireSpecial: false,
  ),
);
```

Built-in constants:

| Policy | Requirements |
|---|---|
| `PasswordPolicy.weak` | minimum 6 only |
| `PasswordPolicy.medium` | minimum 6, upper, lower, number |
| `PasswordPolicy.strong` | minimum 8, upper, lower, number, supported special |

Password shape validation does not hash a password, check breaches, or
authenticate a user.

## Security-oriented format methods

| Method | Contract |
|---|---|
| `uuid(version: ...)` | versions `3`, `4`, `5`, or structural `all` |
| `url` | canonical `http`/`https`/`ftp` URL rule |
| `ipv4` | four canonical decimal octets 0–255 |
| `ipv6` | complete/compressed IPv6, optional link-zone suffix removed |
| `regex(pattern, {message})` | Dart `RegExp` match |

An invalid regular expression throws `FormatException`. These methods validate
syntax; they do not establish network reachability or safety.

## Custom messages

Most rule methods accept a message. The supplied message replaces the locale
message for that rule only.

```dart
final validator = BrZod()
    .required('Enter a value')
    .email('Enter a valid email')
    .build;
```

The first failing rule determines the returned message.

## Locales

`LocalePtBR` is the default `ILocaleBrZod` implementation.

### Per instance

```dart
final validator = BrZod(locale: MyEnglishLocale()).required().cpf().build;
```

### Global default

```dart
BrZod.defaultLocale = MyEnglishLocale();
```

Changing the static default affects subsequently evaluated instances that did
not receive their own locale. Global mutation should be reset in tests.

### Custom locale

Implement every getter/method required by `ILocaleBrZod`:

```dart
class MyEnglishLocale implements ILocaleBrZod {
  const MyEnglishLocale();

  @override
  String get required => 'Required field';

  // Implement the remaining members from ILocaleBrZod.
}
```

The interface is the source of truth; compilation identifies any missing
message as the package evolves.

## Validating a Map

`BrZod.validate` accepts data and a parallel map of schemas:

```dart
final result = BrZod.validate(
  data: {
    'email': 'invalid',
    'cpf': '529.982.247-25',
  },
  params: {
    'email': BrZod().required().email(),
    'cpf': BrZod().required().cpf(),
  },
);

if (result.isNotValid) {
  print(result.errors);
  print(result.errorList);
}
```

### Nested maps

```dart
final result = BrZod.validate(
  data: {
    'user': {'email': 'invalid'},
  },
  params: {
    'user': {
      'email': BrZod().required().email(),
    },
  },
);
```

`errors` mirrors nesting. `errorList` flattens paths with dot notation. Each
schema executes once per `validate` call, and the same result populates both
representations.

### BrZodResult

| Member | Meaning |
|---|---|
| `isValid` | no errors were collected |
| `isNotValid` | inverse of `isValid` |
| `errors` | potentially nested field-to-message map |
| `errorList` | flat `field: message` list |

`BrZodResult` has a const constructor and descriptive `toString`.

## Module structure and focused import

The public focused barrel exports exactly `BrZod`, `BrZodCallback`,
`ILocaleBrZod`, `LocalePtBR`, `BrZodResult`, and `PasswordPolicy`. Internal pure
functions remain implementation details.

The historical import
`package:all_validations_br/br_zod.dart` re-exports this exact surface for
compatibility and is deprecated in favor of the focused package import.
