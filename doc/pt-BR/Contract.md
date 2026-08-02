# Contract, notificações e ValidationResult

`Contract` acumula erros de domínio para que o consumidor trate todos em uma
única borda. O import estreito é:

```dart
import 'package:all_br_validations/validation.dart';
```

## ValidationNotification

Cada notificação possui `property` e `message` públicos. Ela representa um
erro acumulado; não faz log nem lança exceção.

```dart
const notification = ValidationNotification(
  property: 'email',
  message: 'E-mail inválido',
);
```

## ValidationNotifiable

`ValidationNotifiable` mantém a lista de notificações e expõe
`notifications`, `invalid`, `isValid`, `addNotifications`,
`printMessageErrors` e `toResult`. `printMessageErrors` é diagnóstico legado;
não envie documentos pessoais ou segredos para ele.

```dart
class Cadastro extends ValidationNotifiable {
  Cadastro(String email) {
    addNotifications(
      Contract().isEmail(email, 'email', 'E-mail inválido'),
    );
  }
}
```

## ContractValidations

Cada regra adiciona `ValidationNotification` quando a condição falha e retorna
o mesmo objeto para encadeamento.

- booleanos/comparações: `isFalse`, `isTrue`, `isGreaterThan`,
  `isGreaterOrEqualsThan`, `isLowerThan`, `isLowerOrEqualsThan`, `areEquals`,
  `areNotEquals`, `isBetween`, `isBefore`;
- nulabilidade/tamanho: `isNullOrNullable`, `isNotNullOrEmpty`,
  `isNullOrEmpty`, `hasMinLen`, `hasMaxLen`, `hasLen`, `contains`, `isDigit` e
  as variantes `*IfNotNullOrEmpty`;
- regras de domínio: `isStrongPassword`, `isURL`, `isPhoneNumber`,
  `isValidBRZip`, `isUUID`, `isEmail`, `isValidCPF`, `isValidCNPJ`,
  `isPalindrome`, `isEnum`, `isUnique`, `customValidation`.

CPF, CNPJ, CEP, URL, e-mail, senha forte e UUID delegam às regras canônicas do
pacote. Telefone preserva divergência histórica: `BrZod.phone()` aceita 8/9
dígitos sem DDD, enquanto `Contract.isPhoneNumber()` exige celular ou fixo com
DDD.

## Contract

`Contract` adiciona `requires`, `join`, `merge`, `checkAll`, `checkAllStrict`,
`addCustomValidation`, `addNotification` e `clearNotifications`. Ele é mutável;
crie uma instância por operação ou limpe explicitamente a anterior.

```dart
final contract = Contract()
    .isNotNullOrEmpty(nome, 'nome', 'Nome obrigatório')
    .isEmail(email, 'email', 'E-mail inválido');
```

## Integração com Result

`toResult<T>` retorna `Result<List<ValidationNotification>, T>`.
`toResultFirst<T>` usa somente a primeira notificação. O alias público
`ValidationResult<T>` representa o primeiro formato e pertence ao barrel
completo de `all_br_validations`.

```dart
final result = contract.toResult(usuario);
result.fold(exibirErros, persistir);
```

A ordem genérica de `all_result` é `<F, S>`: falha primeiro e sucesso depois.

## Migração

Substitua `package:all_validations_br/validation.dart` por
`package:all_br_validations/validation.dart`. A superfície estreita preserva
somente `ValidationNotifiable`, `ValidationNotification`, `Contract` e
`ContractValidations`.
