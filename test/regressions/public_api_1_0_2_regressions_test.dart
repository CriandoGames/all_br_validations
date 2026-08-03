import 'dart:io';

import 'package:all_br_validations/all_br_validations.dart';
import 'package:test/test.dart';

void main() {
  test('validadores públicos não registram conteúdo de mapas', () {
    final source =
        File('lib/src/validator/all_validations.dart').readAsStringSync();

    expect(source, isNot(contains("import 'dart:developer'")));
    expect(source, isNot(contains('developer.log')));
  });

  group('coleções mutáveis são apenas caracterizadas para versão futura', () {
    test('CnpjAlfanumerico.validChars é mutável', () {
      final backup = List<String>.of(CnpjAlfanumerico.validChars);
      try {
        CnpjAlfanumerico.validChars.clear();
        expect(CnpjAlfanumerico.validChars, isEmpty);
      } finally {
        CnpjAlfanumerico.validChars.addAll(backup);
      }
    });

    test('AllValidationsGetMonth.listMonths é mutável', () {
      final backup = List<String>.of(AllValidationsGetMonth.listMonths);
      try {
        AllValidationsGetMonth.listMonths.clear();
        expect(AllValidationsGetMonth.listMonths, isEmpty);
      } finally {
        AllValidationsGetMonth.listMonths.addAll(backup);
      }
    });

    test('ValidationNotifiable.notifications expõe a lista interna', () {
      final notifiable = ValidationNotifiable();
      notifiable.addNotifications(
        ValidationNotification(property: 'field', message: 'invalid'),
      );
      expect(notifiable.isValid, isFalse);

      notifiable.notifications.clear();
      expect(notifiable.isValid, isTrue);
    });
  });
}
