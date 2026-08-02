# all_br_validations

🇧🇷 Português | [🇺🇸 English](README.en.md)

[![pub package](https://img.shields.io/pub/v/all_br_validations.svg)](https://pub.dev/packages/all_br_validations)
[![CI](https://github.com/CriandoGames/all_br_validations/actions/workflows/ci.yml/badge.svg)](https://github.com/CriandoGames/all_br_validations/actions/workflows/ci.yml)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Núcleo reutilizável de validações e formatação de dados brasileiros em Dart
puro, com APIs diretas, fluentes e por contrato.
Regras canônicas evitam que a mesma validação seja copiada entre camadas.

![all_br_validations hero](https://raw.githubusercontent.com/CriandoGames/all_br_validations/main/documentation/images/hero.png)

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

## Instalação

```yaml
dependencies:
  all_br_validations: ^1.0.0
```

## Como usar

```dart
import 'package:all_br_validations/all_br_validations.dart';

final cpfValido = AllValidations.isCpf('529.982.247-25');
final erro = BrZod().required().cpf().build('529.982.247-25');

final contrato = Contract().isValidCPF(
  '529.982.247-25',
  'cpf',
  'CPF inválido',
);
```

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
