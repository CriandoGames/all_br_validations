/// Funções puras usadas pelo [BrZod]. Todas delegam às regras canônicas do
/// pacote, evitando algoritmos divergentes entre as fachadas públicas.
library;

import '../../cnpj/cnpj_alfanumerico.dart';
import '../../validator/all_validations.dart';

bool isCpf(dynamic value) =>
    value != null && AllValidations.isCpf(value.toString());

bool isCnpj(dynamic value) =>
    value != null && AllValidations.isCnpj(value.toString());

bool isCnpjAlfa(dynamic value) => CnpjAlfanumerico.isValid(value?.toString());

bool isCpfOuCnpj(dynamic value) => isCpf(value) || isCnpj(value);

bool isCep(dynamic value) =>
    value != null && AllValidations.isValidBRZip(value.toString());

bool isRg(dynamic value) =>
    value != null && AllValidations.isRG(value.toString());

bool isPlaca(dynamic value) =>
    value != null &&
    AllValidations.isValidBrazilianLicensePlate(value.toString());

bool isCnh(dynamic value) =>
    value != null && AllValidations.isCnh(value.toString());

bool isRenavam(dynamic value) =>
    value != null && AllValidations.isRenavam(value.toString());

bool isPisPasep(dynamic value) =>
    value != null && AllValidations.isPisPasep(value.toString());

bool isTituloEleitor(dynamic value) =>
    value != null && AllValidations.isTituloEleitor(value.toString());

bool isCns(dynamic value) =>
    value != null && AllValidations.isCns(value.toString());
