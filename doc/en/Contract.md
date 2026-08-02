# Contract, Notifications, and ValidationResult

Contract validation accumulates multiple domain errors before a caller decides
how to respond. Use the focused entry point when only this surface is needed:

```dart
import 'package:all_br_validations/validation.dart';
```

## ValidationNotification

A notification contains a public `property` and `message`.

```dart
const notification = ValidationNotification(
  property: 'email',
  message: 'Invalid email',
);
```

It is a value used for accumulation/presentation; it does not log or throw.

## ValidationNotifiable

`ValidationNotifiable` owns a private mutable list and exposes an unmodifiable
view through `notifications`.

| Member | Behavior |
|---|---|
| `addNotifications(value)` | adds a notification, iterable/list, Contract, or supported Result according to implementation |
| `notifications` | accumulated notifications |
| `invalid` | true when at least one notification exists |
| `isValid` | inverse of `invalid` |
| `printMessageErrors()` | legacy diagnostic output through `dart:developer` |
| `toResult(value)` | failure with all notifications or success with value |

Do not pass personal data to `printMessageErrors`; it is a convenience API,
not sanitization or observability policy.

```dart
class Registration extends ValidationNotifiable {
  Registration(String email) {
    addNotifications(
      Contract().isEmail(email, 'email', 'Invalid email'),
    );
  }
}
```

## ContractValidations

The fluent base accumulates a notification when a rule fails and returns
`this` so calls can be chained.

### Boolean, equality, and order

- `isFalse`, `isTrue`;
- `isGreaterThan`, `isGreaterOrEqualsThan`, `isLowerThan`,
  `isLowerOrEqualsThan`;
- `areEquals`, `areNotEquals`, `isBetween`;
- `isBefore` for supported date/comparable values.

Order comparators support `num` with `num` (including `int` with `double`) and
`DateTime` with `DateTime`. Null or incompatible values are neither coerced nor
compared lexically: the rule adds one notification, returns the same contract,
and does not throw `TypeError` or `NoSuchMethodError`.

### Presence and length

- `isNullOrNullable`, `isNotNullOrEmpty`, `isNullOrEmpty`;
- `hasMinLen`, `hasMaxLen`, `hasLen`, `contains`, `isDigit`;
- `hasMinLengthIfNotNullOrEmpty`, `hasMaxLengthIfNotNullOrEmpty`,
  `hasExactLengthIfNotNullOrEmpty`.

Read each method name from the perspective of the condition that must be true;
a false condition adds the supplied property/message.

### Domain and custom rules

- `isStrongPassword`, `isURL`, `isPhoneNumber`, `isValidBRZip`, `isUUID`;
- `isEmail`, `isValidCPF`, `isValidCNPJ`;
- `isPalindrome`, `isEnum`, `isUnique`;
- `customValidation` for an application callback.

CPF, CNPJ, CEP, URL, email, strong password, and UUID delegate to canonical
package rules. Phone intentionally requires a full Brazilian mobile or
landline with DDD, unlike `BrZod.phone`, which also accepts a subscriber number
without DDD.

```dart
final contract = Contract()
    .isNotNullOrEmpty(name, 'name', 'Name is required')
    .isEmail(email, 'email', 'Invalid email')
    .isValidCPF(cpf, 'cpf', 'Invalid CPF');
```

## Contract

`Contract` extends `ContractValidations` with composition helpers:

| Member | Purpose |
|---|---|
| `requires()` | fluent starting marker returning the same contract |
| `join(items)` | adds notifications from invalid notifiables |
| `merge(other)` | adds notifications from another contract |
| `checkAll(rules)` | evaluates callbacks according to historical non-strict behavior |
| `checkAllStrict(rules)` | evaluates the strict documented variant |
| `addCustomValidation` | adds a notification when callback fails |
| `addNotification` | adds one property/message |
| `clearNotifications` | removes accumulated notifications |
| `isValid` | true when the list is empty |

```dart
final contract = Contract()
  ..addNotification('name', 'Name is required');

contract.clearNotifications();
expect(contract.isValid, isTrue);
```

A contract is mutable. Create a new instance per validation operation unless
the lifecycle deliberately calls `clearNotifications`.

## Converting to Result

`toResult<T>(value)` returns
`Result<List<ValidationNotification>, T>`. `toResultFirst<T>(value)` returns
`Result<ValidationNotification, T>` using the first failure.

```dart
final result = Contract()
    .isEmail(email, 'email', 'Invalid email')
    .toResult(user);

result.fold(
  (notifications) => showErrors(notifications),
  (validUser) => persist(validUser),
);
```

The public alias from the complete package barrel is:

```dart
typedef ValidationResult<T>
    = Result<List<ValidationNotification>, T>;
```

`ValidationResult` is intentionally owned by `all_br_validations` because it
depends on notification types. The generic order inherited from `all_result`
is failure first, success second.

## Errors, nullability, and lifecycle

Contract rules accumulate; they do not short-circuit unless a specific method
documents it. User-provided custom callbacks may throw, and those exceptions
propagate. A null or empty value follows the explicit rule used in the chain;
there is no universal implicit required rule.

Notifications may include input-derived messages selected by the application.
Do not include real personal documents, credentials, or secrets.

## Migration

Replace:

```dart
import 'package:all_validations_br/validation.dart';
```

with:

```dart
import 'package:all_br_validations/validation.dart';
```

The focused surface remains exactly `ValidationNotifiable`,
`ValidationNotification`, `Contract`, and `ContractValidations`. Import the
complete package barrel when `ValidationResult`, formatters, or direct
validators are also required.
