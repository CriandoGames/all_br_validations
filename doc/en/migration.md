# Migration and public entry points

## Breaking changes in 1.0.2

### Strict `BrZod.type<T>()`

`BrZod.type<T>()` now performs Dart's strict `value is T` check. It no longer
accepts strings merely because they can be converted to `int`, `double`, or
`bool`:

```dart
BrZod().type<int>().build(123);   // valid
BrZod().type<int>().build('123'); // invalid
```

Parse external input before validating its runtime type when conversion is
intended.

### Typed PIX key result

`AllValidations.validatePixKey` now returns
`Result<ValidationError, PixKeyType>` instead of a string success value:

```dart
final result = AllValidations.validatePixKey('529.982.247-25');
final isCpf = result.successValue == PixKeyType.cpf;
```

The package can replace validation-related imports from the
`all_validations_br` aggregator without adding Flutter.

| Historical import | Focused replacement |
|---|---|
| `package:all_validations_br/br_zod.dart` | `package:all_br_validations/br_zod.dart` |
| `package:all_validations_br/validation.dart` | `package:all_br_validations/validation.dart` |
| `package:all_validations_br/regions_validations.dart` | `package:all_br_validations/regions_validations.dart` |
| main aggregator for validation/formatting | `package:all_br_validations/all_br_validations.dart` |

The focused barrels intentionally prevent accidental exposure:

- `br_zod.dart` exports BrZod, its callback, locale interface/default locale,
  map result, and password policy;
- `validation.dart` exports contracts and notifications only;
- `regions_validations.dart` exports month/week/region/state models,
  `BrazilianState`, and `ValidationError`.

Flutter input masks moved to `all_br_forms`. `Result<F, S>` itself lives in
`all_result`; the validation-specific `ValidationResult<T>` alias stays here.

The aggregator remains maintained for compatibility. Its historical focused
imports are deprecated with actionable replacement messages, while the
specialized-package APIs themselves are not deprecated.
