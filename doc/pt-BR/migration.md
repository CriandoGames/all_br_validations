# Migração da 1.0.2

## Breaking changes

### `BrZod.type<T>()` estrito

`BrZod.type<T>()` agora executa a verificação estrita `value is T`. Strings
deixaram de ser aceitas apenas por serem convertíveis para `int`, `double` ou
`bool`:

```dart
BrZod().type<int>().build(123);   // válido
BrZod().type<int>().build('123'); // inválido
```

Quando a conversão for desejada, converta a entrada antes de validar seu tipo.

### Resultado tipado de chave PIX

`AllValidations.validatePixKey` agora retorna
`Result<ValidationError, PixKeyType>` no lugar de uma string:

```dart
final result = AllValidations.validatePixKey('529.982.247-25');
final isCpf = result.successValue == PixKeyType.cpf;
```

Mapeamento para migração:

| Valor anterior | Novo valor |
|---|---|
| `'CPF'` | `PixKeyType.cpf` |
| `'CNPJ'` | `PixKeyType.cnpj` |
| `'Celular'` | `PixKeyType.phone` |
| `'Email'` | `PixKeyType.email` |
| `'Chave Aleatória'` | `PixKeyType.random` |
