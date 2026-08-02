# Extensions — Native-Type Helpers

The public barrel exports three null-safe extensions: `BoolExtension`,
`StringExtension`, and `ListExtension<T>`. They are convenience APIs, not
validation of external identity or data provenance.

```dart
import 'package:all_br_validations/all_br_validations.dart';
```

## BoolExtension

The extension applies to `bool?` and exposes:

| Getter | Meaning |
|---|---|
| `isTrue` | receiver is exactly true |
| `isFalse` | receiver is exactly false |

```dart
bool? enabled;
enabled.isTrue;  // false
enabled.isFalse; // false

enabled = true;
enabled.isTrue; // true
```

Null is never silently treated as true.

## StringExtension

### Null and empty checks

`isNullOrEmpty`/`isNotNullOrEmpty` test null or the literal empty string.
Whitespace-only text is not empty for that pair.

`isNullOrEmptyWithSpace`/`isNotNullOrEmptyWithSpace` trim before testing, so a
string such as `'   '` is empty for the whitespace-aware pair.

```dart
String? value = '   ';
value.isNullOrEmpty;          // false
value.isNullOrEmptyWithSpace; // true
```

### truncate

`truncate(maxLength)` limits a non-null string according to the documented
length and suffix behavior. Null receivers remain safe.

```dart
final short = 'abcdefghijkl'.truncate(5);
```

This is a code-unit/string presentation helper, not Unicode grapheme-aware UI
layout. Use a grapheme-aware package if splitting emoji/combined characters
would be incorrect.

## ListExtension<T>

The extension applies to nullable lists:

| Getter | Meaning |
|---|---|
| `isNullOrEmpty` | null or no items |
| `isNotNullOrEmpty` | exists and has items |

```dart
List<int>? values;
values.isNullOrEmpty; // true

values = [1, 2];
values.isNotNullOrEmpty; // true
```

The extension does not copy or mutate the list and does not inspect whether
items themselves are null.

## Quick reference

| Receiver | Members |
|---|---|
| `bool?` | `isTrue`, `isFalse` |
| `String?` | null/empty pairs, whitespace-aware pairs, `truncate` |
| `List<T>?` | `isNullOrEmpty`, `isNotNullOrEmpty` |

These names are preserved from `all_validations_br`. Replace the aggregator
import with `package:all_br_validations/all_br_validations.dart` without code
changes.
