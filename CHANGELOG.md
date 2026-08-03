# Changelog

## Unreleased

### Breaking changes

- `BrZodResult` deixou de possuir construtor `const` para copiar e proteger
  profundamente `errors` e `errorList` contra mutações externas.
- Os catálogos públicos de meses e dias agora são coleções imutáveis; código
  que alterava essas listas ou mapas deve manter uma cópia própria.

### Fixed

- Adicionados vetores independentes para Título de Eleitor, incluindo dígitos
  verificadores, limites de UF e regras especiais dos códigos eleitorais.
- Removida a dependência de `assert` em `removeCharacters('')`, mantendo o
  mesmo resultado em desenvolvimento e produção.
- Impedido que os geradores numérico e alfanumérico de CNPJ produzam valores
  inválidos por bases degeneradas ou por mutação do catálogo público.
- Unificadas as fachadas de IPv4 em um validador canônico que rejeita octetos
  com zeros à esquerda.
- Substituída a string mágica de `optional()` por uma sentinela privada.
- Corrigida a formatação de valores monetários negativos.
- Restringidos cartões, inclusive mascarados, ao intervalo de 13 a 19 dígitos
  antes da verificação de Luhn.
- Ajustada a chave aleatória PIX ao formato UUID do DICT sem restringi-la à
  versão 4.
- Chaves PIX telefônicas agora exigem um DDD brasileiro atribuído.
- UUIDs agora exigem versão suportada e variante RFC válida em
  `AllValidations`, `BrZod` e PIX.
- `BrZod.validate` agora lança `ArgumentError` com o caminho completo quando
  recebe um schema que não é `BrZod` nem `Map`.
- Aplicados os limites de 64 octetos para a parte local, 255 para o domínio e
  254 para o endereço completo de e-mail.
- `parseCurrency` agora remove apenas o prefixo `R$` e rejeita caracteres ou
  agrupamentos inválidos no restante do valor.
- `formatCurrency` agora rejeita valores não finitos, valores absolutos a
  partir de `1e21` e quantidades de casas decimais fora de 0 a 20.
- Políticas de senha agora aceitam somente valores que já sejam `String`.
- `StringExtension.truncate` agora opera sobre pontos de código Unicode e
  rejeita limites negativos explicitamente.
- `BrData.format` e `formatMonthYear` preenchem anos até quatro dígitos e
  rejeitam explicitamente anos fora de `0000` a `9999`.
- `BrZodResult` agora mantém mapa, mapas aninhados e lista de erros imutáveis e
  coerentes após a construção.
- Catálogos públicos de meses e dias passaram a ser somente leitura.
- Centralizado o catálogo de DDDs no mapa canônico `DDD → estado`; validação,
  telefones, consulta de estado e a lista legada derivam dessa única fonte.

## 1.0.2

### Breaking changes

- `AllValidations.validatePixKey` agora retorna
  `Result<ValidationError, PixKeyType>`; comparações com strings como `'CPF'`
  devem usar `PixKeyType.cpf`.
- `BrZod.type<T>()` e `isType<T>()` agora verificam estritamente `value is T`.
  Strings convertíveis, como `'123'` para `int` e `'true'` para `bool`, passam
  a ser rejeitadas.

### Fixed

- Corrigida a identificação de CNPJ numérico e alfanumérico em chaves PIX.
- Corrigida a validação estrita de datas e horários em `BrData`.
- Corrigido o reconhecimento de IPv6 comprimido, inclusive `::` e zonas.
- Evitado erro de runtime em `Contract.isNotNullOrEmpty` com tipos dinâmicos.
- Corrigida a extração de DDD em números com código do país `+55`.
- Corrigido o bloqueio determinístico de bases repetidas no gerador de CPF.
- Corrigidos formatos sem número aceitos por `isNumericFloat`.
- Corrigida a identificação de extensões de vídeo e removida a legenda `.srt`.
- Corrigida a normalização de placas em minúsculas e com espaços externos.
- Ampliada a validação genérica de PAN por formato e algoritmo de Luhn.
- Impedido que tipos incompatíveis sejam aceitos como objetos aninhados vazios.
- Removidos logs de chaves e valores de mapas em `isMapExists`.
- Unificadas as políticas de senha média e forte entre `AllValidations`,
  `Contract` e `BrZod`.
- Completada a documentação DartDoc da API e habilitado seu lint obrigatório.

## 1.0.1

### Correções

- Telefones brasileiros agora validam o formato original antes da normalização.
- `AllValidations`, `Contract` e `BrZod` utilizam regras canônicas compartilhadas para telefone.
- Comparadores ordenáveis do `Contract` não lançam mais exceções para valores incompatíveis.
- Comparações entre valores numéricos e datas foram centralizadas.

## 1.0.0

- Primeira versão pública.
- Validações, contratos, formatação e modelos brasileiros em Dart puro.
