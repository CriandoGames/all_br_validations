# Contribuindo

Mudanças de regra brasileira devem citar a fonte normativa quando aplicável,
incluir vetores válidos/inválidos e verificar as fachadas `AllValidations`,
`BrZod` e `Contract`. Não duplique algoritmos; delegue à regra canônica e
documente divergências históricas intencionais.

Execute antes de enviar:

```text
dart run tool/check_package.dart
dart format --output=none --set-exit-if-changed .
dart analyze
dart test --coverage=coverage
dart doc
dart pub publish --dry-run
```

Atualize PT-BR e EN juntos. Use somente massa sintética/pública e nunca inclua
documentos pessoais reais em testes, logs ou issues. Consulte
[SECURITY.md](SECURITY.md).

O pacote deve continuar Dart puro. Máscaras `TextInputFormatter` pertencem a
`all_br_forms`.
