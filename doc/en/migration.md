# Migration and public entry points

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
