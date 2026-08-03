import 'package:all_br_validations/all_br_validations.dart';
import 'package:test/test.dart';

void main() {
  group('Contract.isNotNullOrEmpty aceita dynamic com segurança', () {
    final cases = <(dynamic, bool)>[
      (null, false),
      ('', false),
      (<dynamic>[], false),
      (<dynamic, dynamic>{}, false),
      (123, true),
      (true, true),
      (const Object(), true),
      ('texto', true),
      (<int>[1], true),
      (<String, int>{'a': 1}, true),
    ];

    for (final entry in cases) {
      test('valor ${entry.$1} tem validade esperada', () {
        final contract = Contract();
        expect(
          () => contract.isNotNullOrEmpty(entry.$1, 'value', 'obrigatório'),
          returnsNormally,
        );
        expect(contract.isValid, entry.$2);
      });
    }
  });
}
