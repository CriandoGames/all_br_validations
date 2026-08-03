/// Funções puras usadas pelo [BrZod]. Todas delegam às regras canônicas do
/// pacote, evitando algoritmos divergentes entre as fachadas públicas.
library;

import '../../cnpj/cnpj_alfanumerico.dart';
import '../../validator/all_validations.dart';

/// Valida CPF numérico, com ou sem a máscara oficial.
bool isCpf(dynamic value) =>
    value != null && AllValidations.isCpf(value.toString());

/// Valida CNPJ numérico, com ou sem a máscara oficial.
bool isCnpj(dynamic value) =>
    value != null && AllValidations.isCnpj(value.toString());

/// Valida CNPJ numérico ou alfanumérico conforme a regra da Receita Federal.
bool isCnpjAlfa(dynamic value) => CnpjAlfanumerico.isValid(value?.toString());

/// Retorna se [value] é um CPF ou CNPJ numérico válido.
bool isCpfOuCnpj(dynamic value) => isCpf(value) || isCnpj(value);

/// Valida CEP nos formatos aceitos por [AllValidations.isValidBRZip].
bool isCep(dynamic value) =>
    value != null && AllValidations.isValidBRZip(value.toString());

/// Valida o formato de RG aceito pela fachada canônica.
bool isRg(dynamic value) =>
    value != null && AllValidations.isRG(value.toString());

/// Valida placa antiga ou Mercosul após normalizar caixa e espaços externos.
bool isPlaca(dynamic value) =>
    value != null &&
    AllValidations.isValidBrazilianLicensePlate(value.toString());

/// Valida CNH numérica com seus dois dígitos verificadores.
bool isCnh(dynamic value) =>
    value != null && AllValidations.isCnh(value.toString());

/// Valida RENAVAM numérico de 9 a 11 dígitos.
bool isRenavam(dynamic value) =>
    value != null && AllValidations.isRenavam(value.toString());

/// Valida PIS/PASEP com ou sem a máscara oficial.
bool isPisPasep(dynamic value) =>
    value != null && AllValidations.isPisPasep(value.toString());

/// Valida título de eleitor numérico com 12 dígitos.
bool isTituloEleitor(dynamic value) =>
    value != null && AllValidations.isTituloEleitor(value.toString());

/// Valida o número do Cartão Nacional de Saúde.
bool isCns(dynamic value) =>
    value != null && AllValidations.isCns(value.toString());
