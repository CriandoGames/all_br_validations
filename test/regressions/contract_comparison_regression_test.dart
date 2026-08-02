import 'package:all_br_validations/all_br_validations.dart';
import 'package:test/test.dart';

void main() {
  void expectInvalidWithoutThrow(
    Contract contract,
    Object Function() validation,
  ) {
    late Object returned;
    expect(() => returned = validation(), returnsNormally);
    expect(returned, same(contract));
    expect(contract.isValid, isFalse);
    expect(contract.notifications, hasLength(1));
  }

  group('comparadores rejeitam tipos incompatíveis sem lançar', () {
    test('isGreaterThan', () {
      final contract = Contract();
      expectInvalidWithoutThrow(
        contract,
        () => contract.isGreaterThan(
          '10',
          2,
          'value',
          'Tipos incompatíveis',
        ),
      );
    });

    test('isGreaterOrEqualsThan', () {
      final contract = Contract();
      expectInvalidWithoutThrow(
        contract,
        () => contract.isGreaterOrEqualsThan(
          '10',
          2,
          'value',
          'Tipos incompatíveis',
        ),
      );
    });

    test('isLowerThan', () {
      final contract = Contract();
      expectInvalidWithoutThrow(
        contract,
        () => contract.isLowerThan(
          '10',
          2,
          'value',
          'Tipos incompatíveis',
        ),
      );
    });

    test('isLowerOrEqualsThan', () {
      final contract = Contract();
      expectInvalidWithoutThrow(
        contract,
        () => contract.isLowerOrEqualsThan(
          '10',
          2,
          'value',
          'Tipos incompatíveis',
        ),
      );
    });

    test('isBetween com null', () {
      final contract = Contract();
      expectInvalidWithoutThrow(
        contract,
        () => contract.isBetween(
          null,
          1,
          10,
          'value',
          'Valor incompatível',
        ),
      );
    });
  });

  test('compara int e double', () {
    final contract = Contract().isGreaterThan(10, 2.5, 'value', 'Inválido');

    expect(contract.isValid, isTrue);
  });

  test('compara DateTime', () {
    final contract = Contract().isLowerThan(
      DateTime(2026, 1, 1),
      DateTime(2026, 1, 2),
      'date',
      'Data inválida',
    );

    expect(contract.isValid, isTrue);
  });
}
