# all_br_validations

🇧🇷 Português | [🇺🇸 English](README.en.md)

[![pub package](https://img.shields.io/pub/v/all_br_validations.svg)](https://pub.dev/packages/all_br_validations)
[![CI](https://github.com/CriandoGames/all_br_validations/actions/workflows/ci.yml/badge.svg)](https://github.com/CriandoGames/all_br_validations/actions/workflows/ci.yml)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Núcleo reutilizável de validações e formatação de dados brasileiros em Dart
puro, com APIs diretas, fluentes e por contrato.
Regras canônicas evitam que a mesma validação seja copiada entre camadas.

![all_br_validations hero](https://raw.githubusercontent.com/CriandoGames/all_br_validations/main/documentation/images/hero.png)

## Onde usar

- Cadastros de pessoas e empresas em aplicações Dart ou Flutter.
- Formulários, DTOs e payloads de APIs com erros organizados por campo.
- Onboarding, checkout e backoffice com documentos e formatos brasileiros.
- Pacotes que precisam compartilhar regras canônicas sem depender de Flutter.

## Recursos

- CPF, CNPJ numérico e alfanumérico, CNH, RENAVAM, PIS/PASEP, RG e CNS.
- CEP, DDD, telefones, placas, PIX, EAN-13 e cartão por Luhn.
- E-mail, URL, UUID, IP, datas, arquivos, números e senhas.
- Validação fluente com `BrZod` e contratos com notificações acumuladas.
- `BrFormatter`, `BrData`, extensões null-safe e modelos geográficos.
- Integração com `Result` por meio de `all_result`.

## Base para outros pacotes

`all_br_validations` é o core de validação do ecossistema e foi projetado para
ser usado diretamente por aplicações e por outros pacotes. Ele não depende de
Flutter, mantém uma API pública versionada por SemVer e concentra regras
canônicas cobertas por testes, evitando que cada biblioteca implemente CPF,
CNPJ, contratos e formatação por conta própria.

Para uma dependência menor, use somente o barrel necessário. Novos pacotes que
precisam de validação brasileira devem depender de `all_br_validations`, e não
do agregador `all_validations_br`.

## Catálogo de validações

| Categoria | Validações disponíveis |
|---|---|
| Documentos brasileiros | CPF, CNPJ numérico, CNPJ alfanumérico, RG, CNH, RENAVAM, PIS/PASEP, Título de Eleitor e CNS |
| Endereço e contato | CEP, DDD, celular brasileiro, telefone fixo, e-mail e URL |
| Veículos, pagamentos e códigos | Placa antiga e Mercosul, cartão pelo algoritmo de Luhn, EAN-13 e chaves PIX por CPF, celular, e-mail ou UUID v4 |
| Identificadores, rede e hashes | UUID v3/v4/v5, IPv4, IPv6, JSON, SSN, hexadecimal, MD5, SHA-1 e SHA-256 |
| Datas, tipos e texto | Data brasileira, datetime ISO 8601, número, inteiro, decimal, booleano, binário, alfabético, maiúsculas, minúsculas, nome, nickname e palíndromo |
| Segurança e formatos | Senha média ou forte, regex customizada e cor hexadecimal |
| Arquivos por extensão | Imagem, vídeo, áudio, PDF, TXT, CHM, SVG e HTML |
| Contratos genéricos | Obrigatório/opcional, nulo/vazio, igualdade, ordem, intervalo, tamanho, conteúdo, tipo, enum, unicidade, datas e regra customizada |
| Utilitários | Estado por DDD, presença de chaves em mapas, comparação de frases, remoção de caracteres e acentos |

O pacote oferece quatro estilos de validação, com coberturas documentadas em
cada API:

| API | Uso |
|---|---|
| `AllValidations.is*` | Retorno direto em `bool` |
| `AllValidations.validate*` | `Result<ValidationError, String>` com valor normalizado |
| `BrZod` | Schemas fluentes, composição e validação de mapas |
| `Contract` | Regras encadeadas com notificações acumuladas |

Veja a [referência completa de `AllValidations`](doc/pt-BR/AllValidations.md),
o [catálogo do `BrZod`](doc/pt-BR/BrZod.md) e os
[contratos](doc/pt-BR/Contract.md) para métodos, formatos aceitos e retornos.

## Instalação

```yaml
dependencies:
  all_br_validations: ^1.0.0
```

## Como usar

### Validações diretas

```dart
import 'package:all_br_validations/all_br_validations.dart';

final cpfValido = AllValidations.isCpf('529.982.247-25');
final cnpjAlfaValido =
    AllValidations.isCnpjAlphanumeric('12ABC34501DE35');
final celularValido =
    AllValidations.isBrazilianCellPhone('(11) 91234-5678');
final placaValida = AllValidations.isValidBrazilianLicensePlate('ABC1D23');
final pix = AllValidations.validatePixKey('cliente@example.com');
```

### Cadastro completo com `BrZod`

Valide um payload inteiro e receba os erros organizados por campo:

```dart
final result = BrZod.validate(
  data: {
    'email': 'cliente@example.com',
    'cpf': '529.982.247-25',
    'phone': '(11) 91234-5678',
    'cep': '01310-100',
    'password': 'Segura@123',
  },
  params: {
    'email': BrZod().required().email(),
    'cpf': BrZod().required().cpf(),
    'phone': BrZod().required().phone(),
    'cep': BrZod().required().cep(),
    'password': BrZod().required().password(),
  },
);

if (result.isNotValid) {
  print(result.errors);    // erros estruturados por campo
  print(result.errorList); // lista pronta para logs ou interface
}
```

### Validação com valor normalizado

As APIs `validate*` evitam exceções e retornam um `Result` tipado:

```dart
AllValidations.validateCPF('529.982.247-25').fold(
  (error) => print('${error.property}: ${error.message}'),
  (cpf) => print(cpf), // 52998224725
);

AllValidations.validateEmail('Cliente@Example.com').fold(
  (error) => print(error.message),
  (email) => print(email), // cliente@example.com
);
```

### Regras de negócio acumuladas

```dart
final contract = Contract();
contract
  ..isGreaterOrEqualsThan(
      16,
      18,
      'idade',
      'É necessário ter pelo menos 18 anos.',
    )
  ..isTrue(false, 'termos', 'É necessário aceitar os termos.');

print(contract.isValid);       // false
print(contract.notifications); // os dois erros, sem fail-fast
```

### Formatação e CNPJ alfanumérico

```dart
BrFormatter.formatCpf('52998224725');   // 529.982.247-25
BrFormatter.formatPhone('11912345678'); // (11) 91234-5678
BrFormatter.formatCurrency(1234.5);     // R$ 1.234,50

const cnpj = '12ABC34501DE35';
CnpjAlfanumerico.isValid(cnpj); // true
CnpjAlfanumerico.format(cnpj);  // 12.ABC.345/01DE-35
```

O [exemplo executável](example/all_br_validations_example.dart) reúne essas
APIs em um fluxo completo de cadastro. Execute com:

```bash
dart run example/all_br_validations_example.dart
```

## Qual API escolher?

| Necessidade | API recomendada |
|---|---|
| Apenas saber se um valor é válido | `AllValidations.is*` |
| Validar e receber valor normalizado ou erro tipado | `AllValidations.validate*` |
| Validar campos ou payloads completos com mensagens | `BrZod` |
| Acumular regras e violações de domínio | `Contract` |
| Preparar dados para exibição ou persistência | `BrFormatter`, `BrData` e `CnpjAlfanumerico` |

### Onde usar `BrZod`, `Result` e `Contract`

Use cada API na camada em que ela entrega mais valor:

| API | Onde usar | Exemplo |
|---|---|---|
| `BrZod` | Entrada da aplicação: formulários, controllers, DTOs e payloads de API | Verificar formato, obrigatoriedade e devolver erros por campo |
| `Result` | Serviços e casos de uso que precisam representar sucesso ou falha sem lançar exceções esperadas | Validar e normalizar CPF, e-mail ou chave PIX antes de persistir |
| `Contract` | Entidades e regras de negócio que envolvem um ou mais valores | Idade mínima, aceite de termos e limites definidos pelo domínio |

Uma separação prática para um cadastro:

```text
Entrada não confiável → BrZod → Result com dados normalizados → Contract → salvar
```

- `BrZod` responde: **os campos recebidos têm formato válido?**
- `Result` responde: **a operação terminou em sucesso ou falha, e qual valor seguro ela produziu?**
- `Contract` responde: **os dados respeitam as regras do negócio?**

Eles podem ser usados juntos. Por exemplo, valide o payload com `BrZod`,
normalize o CPF com `AllValidations.validateCPF()` e aplique as regras da
entidade com `Contract`. Use `Contract.toResult()` quando quiser devolver as
violações do domínio pelo mesmo fluxo tipado de sucesso e falha.

Evite usar `Contract` apenas para verificar um campo isolado quando um método
`is*` ou `BrZod` resolve o caso. Da mesma forma, não use `BrZod` para regras que
dependem do estado da entidade ou de decisões do negócio.

Barrels específicos também estão disponíveis:

```dart
import 'package:all_br_validations/br_zod.dart';
import 'package:all_br_validations/validation.dart';
import 'package:all_br_validations/regions_validations.dart';
```

As APIs podem ser usadas com segurança como base de outras bibliotecas dentro
do contrato público documentado. A validação confirma formato, dígitos e regras
locais; ela não comprova identidade, titularidade nem a existência oficial de
um documento. Máscaras baseadas em `TextInputFormatter` ficam no pacote
`all_br_forms`.

## Documentação

Consulte [doc/pt-BR](doc/pt-BR), o [guia de contribuição](CONTRIBUTING.md) e a
[política de segurança](SECURITY.md). Não use documentos pessoais reais em
issues, exemplos ou testes. Licença [MIT](LICENSE).
