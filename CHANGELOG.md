# Changelog

## 1.0.2

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
