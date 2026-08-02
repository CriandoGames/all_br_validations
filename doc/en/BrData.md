# BrData — Dates and Times without intl

`BrData` formats, parses, and validates the package's strict Brazilian date
shapes using only `DateTime` and Dart core libraries.

```dart
import 'package:all_br_validations/all_br_validations.dart';
```

## Formatting

| Method | Output |
|---|---|
| `format(date)` | `DD/MM/YYYY` |
| `formatMonthYear(date)` | `MM/YYYY` |
| `formatDayMonth(date)` | `DD/MM` |
| `formatTime(date)` | `HH:MM:SS` |
| `formatTimeShort(date)` | `HH:MM` |

```dart
final value = DateTime(2026, 7, 15, 9, 5, 3);

BrData.format(value);          // 15/07/2026
BrData.formatMonthYear(value); // 07/2026
BrData.formatDayMonth(value);  // 15/07
BrData.formatTime(value);      // 09:05:03
BrData.formatTimeShort(value); // 09:05
```

Formatting uses local components already present in the `DateTime`. It does not
convert time zones or localize names.

## Parsing a date

`parse` accepts exactly `DD/MM/YYYY` with two-digit day/month and four-digit
year.

```dart
final date = BrData.parse('31/12/2026');
expect(date, DateTime(2026, 12, 31));
```

Invalid shape or impossible components throw `FormatException`:

```dart
BrData.parse('2026-12-31'); // throws FormatException
BrData.parse('31/02/2026'); // throws FormatException
```

Dart's `DateTime` normally normalizes overflowing components. `BrData` compares
the constructed components with the input, so such normalization is rejected.

## Parsing date and time

`parseWithTime` accepts exactly `DD/MM/YYYY HH:MM`.

```dart
final value = BrData.parseWithTime('15/07/2026 09:05');
expect(value, DateTime(2026, 7, 15, 9, 5));
```

Hours must be 0–23 and minutes 0–59. Seconds are not part of this parser.
Malformed or impossible values throw `FormatException`.

## Validation without throwing

`validate` checks only the strict `DD/MM/YYYY` date form and returns `bool`.

```dart
BrData.validate('29/02/2024'); // true
BrData.validate('29/02/2025'); // false
BrData.validate('1/2/2025');   // false
```

Use `validate` when invalid user input is expected and a boolean is enough. Use
`parse` when a valid `DateTime` is required and a `FormatException` represents
contract violation.

## Text fields

`BrData` is pure Dart and is not a `TextInputFormatter`. In Flutter, use the
date mask from `all_br_forms` to shape input, then call `validate`/`parse` when
processing it. A mask does not prove that the calendar date exists.

```dart
final raw = controller.text;
if (BrData.validate(raw)) {
  final date = BrData.parse(raw);
  save(date);
}
```

## Comparison with legacy HelperUtil

The `all_validations_br` aggregator still contains legacy date helpers in
`HelperUtil`. New focused code should use `BrData` for the strict formats above
and Dart `DateTime` for conversion/comparison. `all_br_validations` does not
depend on the aggregator.

## Quick reference

```dart
BrData.format(DateTime(2026, 1, 2));
BrData.parse('02/01/2026');
BrData.parseWithTime('02/01/2026 14:30');
BrData.validate('02/01/2026');
```
