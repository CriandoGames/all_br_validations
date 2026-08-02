# Contributing

Brazilian-rule changes should cite a normative source when applicable, include
valid/invalid vectors, and verify `AllValidations`, `BrZod`, and `Contract`.
Do not duplicate algorithms; delegate to the canonical rule and document any
intentional historical divergence.

Run before submitting:

```text
dart run tool/check_package.dart
dart format --output=none --set-exit-if-changed .
dart analyze
dart test --coverage=coverage
dart doc
dart pub publish --dry-run
```

Update Portuguese and English together. Use synthetic/public data only and
never include real personal documents in tests, logs, or issues. See
[SECURITY.en.md](SECURITY.en.md).

The package must remain pure Dart. `TextInputFormatter` masks belong to
`all_br_forms`.
