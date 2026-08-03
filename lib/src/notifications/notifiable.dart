import 'dart:developer' as dev;
import 'package:all_result/all_result.dart';

/// Acumula notificações produzidas por validações de contrato.
class ValidationNotifiable {
  late List<ValidationNotification> _notifications;

  /// Lista mutável de notificações acumuladas.
  ///
  /// A referência interna é exposta por compatibilidade; prefira
  /// [addNotifications] e, em [Contract], `clearNotifications()`.
  List<ValidationNotification> get notifications => _notifications;

  /// Cria uma instância sem notificações.
  ValidationNotifiable() {
    _notifications = <ValidationNotification>[];
  }

  /// Adiciona notificações a partir de formatos compatíveis.
  ///
  /// [r] pode ser uma [ValidationNotification], uma lista tipada de
  /// notificações, outro [ValidationNotifiable] ou uma lista dinâmica cujos
  /// dois primeiros itens sejam, respectivamente, propriedade e mensagem.
  /// Outros valores são ignorados.
  void addNotifications<T>(T r) {
    if (r is ValidationNotification) {
      _notifications.add(r);
    } else if (r is List<ValidationNotification>) {
      _notifications.addAll(r);
    } else if (r is ValidationNotifiable) {
      for (final f in r.notifications) {
        ValidationNotification tempNotification =
            ValidationNotification(property: f.property, message: f.message);
        _notifications.add(tempNotification);
      }
    } else if (r is List) {
      if (r.length > 1 && r[0] is String && r[1] is String) {
        _notifications.add(
          ValidationNotification(
              property: r[0] as String, message: r[1] as String),
        );
      }
    }
  }

  /// Imprime todas as mensagens de erro.
  void printMessageErrors() {
    if (_notifications.isEmpty) {
      dev.log('Não existe Erro');
    } else {
      for (var tempNotification in _notifications) {
        dev.log(tempNotification.toString());
      }
    }
  }

  /// `true` quando existe ao menos uma notificação.
  bool get invalid => _notifications.isNotEmpty;

  /// `true` quando nenhuma notificação foi adicionada.
  bool get isValid => !invalid;

  /// Converte o estado de validação em um [Result].
  ///
  /// Retorna [Success] com [value] se não houver notificações, ou
  /// [Failure] com a lista completa de [ValidationNotification].
  ///
  /// ```dart
  /// final result = myNotifiable.toResult(myDto);
  /// result.fold(
  ///   (errors) => print(errors.map((e) => e.message).join(', ')),
  ///   (dto)    => save(dto),
  /// );
  /// ```
  Result<List<ValidationNotification>, T> toResult<T>(T value) {
    if (isValid) return Result.success(value);
    return Result.failure(List.unmodifiable(notifications));
  }
}

/// Descreve uma falha de validação associada a uma propriedade.
class ValidationNotification {
  /// Nome lógico da propriedade inválida.
  final String property;

  /// Mensagem que explica a falha.
  final String message;

  /// Cria uma notificação para [property] com [message].
  ValidationNotification({required this.property, required this.message});

  /// Converte a notificação para um mapa (JSON).
  Map<String, dynamic> toMap() {
    return {
      'property': property,
      'message': message,
    };
  }

  @override
  String toString() => 'Property: $property , Message: $message';
}
