/// Regressão: `Constants.ddds` continha códigos de DDD que nunca foram
/// atribuídos pela ANATEL (23, 25, 26, 36, 52, 72, 76 e 78), divergindo do
/// mapa `AllValidations.getStateByDDD` — que já usa a lista correta de 67
/// DDDs — e do exemplo documentado em `doc/pt-BR/AllValidations.md`
/// (`AllValidations.isValidDDD('20')` → `false`, pois 20 não existe).
///
/// Isso fazia `isValidDDD`, `isBrazilianCellPhone`, `isBrazilianLandline` e
/// `BrZod().phone()` aceitarem indevidamente números com DDD inexistente.
library;

import 'package:all_br_validations/all_br_validations.dart';
import 'package:all_br_validations/src/br_zod/validations/generic.dart' as g;
import 'package:test/test.dart';

void main() {
  group('Bug: isValidDDD aceitava DDDs nunca atribuídos pela ANATEL', () {
    const invalidDdds = ['23', '25', '26', '36', '52', '72', '76', '78'];

    for (final ddd in invalidDdds) {
      test('negativo — reproduz o bug: DDD $ddd não existe', () {
        expect(AllValidations.isValidDDD(ddd), isFalse);
      });
    }

    test('consistência — getStateByDDD desconhece os mesmos DDDs', () {
      for (final ddd in invalidDdds) {
        expect(AllValidations.getStateByDDD(ddd), BrazilianState.Unknown,
            reason: 'DDD $ddd não deveria mapear para nenhum estado');
      }
    });

    test('positivo — DDDs reais continuam válidos', () {
      const realDdds = ['11', '21', '24', '27', '31', '47', '61', '85', '99'];
      for (final ddd in realDdds) {
        expect(AllValidations.isValidDDD(ddd), isTrue,
            reason: 'DDD $ddd é real');
      }
    });

    test('celular com DDD inexistente é rejeitado', () {
      // 11 dígitos: DDD 23 (inexistente) + 9 + 8 dígitos.
      expect(AllValidations.isBrazilianCellPhone('23912345678'), isFalse);
    });

    test('fixo com DDD inexistente é rejeitado', () {
      // 10 dígitos: DDD 25 (inexistente) + 8 dígitos.
      expect(AllValidations.isBrazilianLandline('2532345678'), isFalse);
    });

    test('consistência — BrZod generic.isPhone concorda', () {
      expect(g.isPhone('(23) 91234-5678'), isFalse);
      expect(g.isPhone('(11) 91234-5678'), isTrue);
    });
  });
}
