import 'package:all_result/all_result.dart';

import '../notifications/notifiable.dart';
import 'all_validations.dart';
import 'internal/email_validator.dart';

/// Conjunto fluente de validações que adicionam [ValidationNotification].
///
/// Cada método mantém a instância encadeável e adiciona [message] associada a
/// [property] quando sua condição não é satisfeita.
class ContractValidations extends ValidationNotifiable {
  /// Cria uma cadeia de validações sem notificações iniciais.
  ContractValidations();

  /// Notifica quando [value] é verdadeiro.
  ContractValidations isFalse(bool value, String property, String message) {
    if (value) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }
    return this;
  }

  /// Notifica quando [password] não cumpre a política forte legada.
  ///
  /// A política exige 8 a 99 caracteres sem espaços, maiúscula, minúscula,
  /// dígito e símbolo. String vazia recebe uma mensagem específica.
  ContractValidations isStrongPassword(
      String password, String property, String message) {
    // Verifica se a senha é nula ou vazia
    if (password.isEmpty) {
      addNotifications(ValidationNotification(
          property: property, message: 'A senha não pode estar vazia.'));
      return this;
    }

    // Delega à regra canônica compartilhada.
    if (!AllValidations.isStrongPassword(password)) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Notifica quando [url] não possui esquema HTTP, HTTPS ou FTP válido.
  ContractValidations isURL(String url, String property, String message) {
    if (!AllValidations.isURL(url)) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }
    return this;
  }

  /// Notifica quando [phone] não é celular nem telefone fixo com DDD válido.
  ContractValidations isPhoneNumber(
      String phone, String property, String message) {
    if (!AllValidations.isBrazilianCellPhone(phone) &&
        !AllValidations.isBrazilianLandline(phone)) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }
    return this;
  }

  /// Notifica quando [zip] não é um CEP em um dos três formatos aceitos.
  ContractValidations isValidBRZip(
      String zip, String property, String message) {
    // Alinhado com AllValidations.isValidBRZip / BrZod().cep() para manter
    // consistência entre as três APIs (mesmos 3 formatos aceitos).
    if (!AllValidations.isValidBRZip(zip)) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }
    return this;
  }

  /// Notifica quando [value] não é um UUID válido.
  ContractValidations isUUID(String value, String property, String message) {
    if (!AllValidations.isUUID(value)) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }
    return this;
  }

  /// Notifica quando [value], sem pontuação e caixa, não é palíndromo.
  ContractValidations isPalindrome(
      String value, String property, String message) {
    String cleanedValue = value.replaceAll(RegExp(r'[\W_]+'), '').toLowerCase();
    String reversedValue = cleanedValue.split('').reversed.join();
    if (cleanedValue != reversedValue) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }
    return this;
  }

  /// Executa [validator] e notifica quando ele retorna `false`.
  ContractValidations customValidation(
      bool Function() validator, String property, String message) {
    if (!validator()) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }
    return this;
  }

  /// Notifica quando [value] não pertence a [enumValues].
  ContractValidations isEnum<T>(
      dynamic value, List<T> enumValues, String property, String message) {
    if (!enumValues.contains(value)) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }
    return this;
  }

  /// Notifica quando [startDate] não ocorre antes de [endDate].
  ContractValidations isBefore(
      DateTime startDate, DateTime endDate, String property, String message) {
    if (!startDate.isBefore(endDate)) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }
    return this;
  }

  /// Notifica quando [list] já contém [value].
  ContractValidations isUnique(
      dynamic value, List<dynamic> list, String property, String message) {
    if (list.contains(value)) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }
    return this;
  }

  /// Notifica quando [value] é falso.
  ContractValidations isTrue(bool value, String property, String message) =>
      isFalse(!value, property, message);

  /// Notifica se [value] NÃO for maior que [comparer].
  ContractValidations isGreaterThan(
      dynamic value, dynamic comparer, String property, String message) {
    final comparison = _compareValues(value, comparer);
    if (comparison == null) {
      addNotifications(
          ValidationNotification(property: property, message: message));
      return this;
    }

    if (comparison <= 0) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Notifica se [value] NÃO for maior ou igual a [comparer].
  ContractValidations isGreaterOrEqualsThan(
      dynamic value, dynamic comparer, String property, String message) {
    final comparison = _compareValues(value, comparer);
    if (comparison == null) {
      addNotifications(
          ValidationNotification(property: property, message: message));
      return this;
    }

    if (comparison < 0) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Notifica se [value] NÃO for menor que [comparer].
  ContractValidations isLowerThan(
      dynamic value, dynamic comparer, String property, String message) {
    final comparison = _compareValues(value, comparer);
    if (comparison == null) {
      addNotifications(
          ValidationNotification(property: property, message: message));
      return this;
    }

    if (comparison >= 0) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Notifica se [value] NÃO for menor ou igual a [comparer].
  ContractValidations isLowerOrEqualsThan(
      dynamic value, dynamic comparer, String property, String message) {
    final comparison = _compareValues(value, comparer);
    if (comparison == null) {
      addNotifications(
          ValidationNotification(property: property, message: message));
      return this;
    }

    if (comparison > 0) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Notifica se [value] NÃO for igual a [comparer].
  ContractValidations areEquals(
      dynamic value, dynamic comparer, String property, String message) {
    if (_rejectMismatchedDateTimeTypes([value, comparer], property, message)) {
      return this;
    }

    if (value is DateTime && comparer is DateTime) {
      if (!value.isAtSameMomentAs(comparer)) {
        addNotifications(
            ValidationNotification(property: property, message: message));
      }
      return this;
    }

    if (value != comparer) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Notifica se [value] FOR igual a [comparer].
  ContractValidations areNotEquals(
      dynamic value, dynamic comparer, String property, String message) {
    if (_rejectMismatchedDateTimeTypes([value, comparer], property, message)) {
      return this;
    }

    if (value is DateTime && comparer is DateTime) {
      if (value.isAtSameMomentAs(comparer)) {
        addNotifications(
            ValidationNotification(property: property, message: message));
      }
      return this;
    }

    if (value == comparer) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Notifica se [value] NÃO estiver entre [from] e [into] (inclusivo).
  ContractValidations isBetween(dynamic value, dynamic from, dynamic into,
      String property, String message) {
    final lowerComparison = _compareValues(value, from);
    final upperComparison = _compareValues(value, into);
    if (lowerComparison == null || upperComparison == null) {
      addNotifications(
          ValidationNotification(property: property, message: message));
      return this;
    }

    if (lowerComparison < 0 || upperComparison > 0) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  int? _compareValues(dynamic left, dynamic right) {
    if (left is num && right is num) {
      return left.compareTo(right);
    }

    if (left is DateTime && right is DateTime) {
      return left.compareTo(right);
    }

    return null;
  }

  bool _rejectMismatchedDateTimeTypes(
    List<dynamic> values,
    String property,
    String message,
  ) {
    final hasDateTime = values.any((value) => value is DateTime);
    final allDateTime = values.every((value) => value is DateTime);
    if (!hasDateTime || allDateTime) return false;

    addNotifications(
      ValidationNotification(property: property, message: message),
    );
    return true;
  }

  /// Notifica quando [value] é nulo.
  ///
  /// O nome histórico é preservado por compatibilidade.
  ContractValidations isNullOrNullable(
      dynamic value, String property, String message) {
    if (value == null) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Notifica quando [val] é nulo ou uma string, mapa ou iterável vazio.
  ///
  /// Tipos sem conceito de vazio, como números e booleanos, são válidos e não
  /// provocam chamadas dinâmicas.
  ContractValidations isNotNullOrEmpty(
      dynamic val, String property, String message) {
    final isEmpty = val == null ||
        (val is String && val.isEmpty) ||
        (val is Iterable && val.isEmpty) ||
        (val is Map && val.isEmpty);
    if (isEmpty) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Notifica quando a string [val] está vazia.
  ContractValidations isNullOrEmpty(
      String val, String property, String message) {
    if (val.isEmpty) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Notifica quando [val] está vazio ou tem menos de [min] caracteres.
  ContractValidations hasMinLen(
      String val, int min, String property, String message) {
    if (val.isEmpty || val.length < min) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Notifica quando [val] está vazio ou tem mais de [max] caracteres.
  ContractValidations hasMaxLen(
      String val, int max, String property, String message) {
    if (val.isEmpty || val.length > max) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Notifica quando [val] está vazio ou seu tamanho difere de [len].
  ContractValidations hasLen(
      String val, int len, String property, String message) {
    if (val.isEmpty || val.length != len) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Notifica quando [val] não contém [text].
  ContractValidations contains(
      String val, String text, String property, String message) {
    if (!val.contains(text)) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Notifica quando [text] não contém exclusivamente dígitos ASCII.
  ContractValidations isDigit(String text, String property, String message) {
    // Verifica se o texto contém apenas dígitos
    final numeric = RegExp(r'^\d+$');
    if (!numeric.hasMatch(text)) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Se [text] não estiver vazio, exige ao menos [min] caracteres.
  ContractValidations hasMinLengthIfNotNullOrEmpty(
      String text, int min, String property, String message) {
    if (text.isNotEmpty && text.length < min) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Se [text] não estiver vazio, permite no máximo [max] caracteres.
  ContractValidations hasMaxLengthIfNotNullOrEmpty(
      String text, int max, String property, String message) {
    if (text.isNotEmpty && text.length > max) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Se [text] não estiver vazio, exige exatamente [len] caracteres.
  ContractValidations hasExactLengthIfNotNullOrEmpty(
      String text, int len, String property, String message) {
    if (text.isNotEmpty && text.length != len) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Notifica quando [email] não é um endereço de e-mail válido.
  ContractValidations isEmail(String email, String property, String message) {
    if (!isAllowedEmail(email)) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Notifica quando [cpf] não é um CPF numérico válido.
  ContractValidations isValidCPF(String cpf, String property, String message) {
    if (!AllValidations.isCpf(cpf)) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  /// Notifica quando [cnpj] não é um CNPJ numérico válido.
  ContractValidations isValidCNPJ(
      String cnpj, String property, String message) {
    if (!AllValidations.isCnpj(cnpj)) {
      addNotifications(
          ValidationNotification(property: property, message: message));
    }

    return this;
  }

  // ── Result integration ────────────────────────────────────────────────────

  /// Converte o contrato em um [Result] com a lista completa de erros.
  ///
  /// ```dart
  /// Contract()
  ///   .requires()
  ///   .isEmail(email, 'email', 'E-mail inválido')
  ///   .toResult(dto);
  /// ```
  @override
  Result<List<ValidationNotification>, T> toResult<T>(T value) {
    if (isValid) return Result.success(value);
    return Result.failure(List.unmodifiable(notifications));
  }

  /// Converte o contrato em um [Result] com apenas a **primeira** notificação
  /// como erro — útil quando se quer tratar um erro por vez.
  Result<ValidationNotification, T> toResultFirst<T>(T value) {
    if (isValid) return Result.success(value);
    return Result.failure(notifications.first);
  }

  /// Versão assíncrona de [toResult] — útil quando [value] é produzido por
  /// uma função async (ex: parsing, lookup em cache).
  ///
  /// ```dart
  /// final result = await contract.toResultAsync(() => fetchUser(id));
  /// ```
  Future<Result<List<ValidationNotification>, T>> toResultAsync<T>(
    Future<T> Function() valueFn,
  ) async {
    if (!isValid) return Result.failure(List.unmodifiable(notifications));
    return Result.success(await valueFn());
  }
}
