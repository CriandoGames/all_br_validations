import 'package:all_br_validations/all_br_validations.dart';
import 'package:test/test.dart';

void main() {
  test('documenta AllValidations e retorno tipado normalizado', () {
    expect(AllValidations.isCpf('529.982.247-25'), isTrue);

    final result = AllValidations.validateCPF(
      '529.982.247-25',
      property: 'cpf',
    );

    expect(result.isSuccess, isTrue);
    expect(result.successValue, '52998224725');
  });

  test('documenta BrData estrito', () {
    final value = DateTime(2026, 7, 15, 9, 5, 3);

    expect(BrData.format(value), '15/07/2026');
    expect(BrData.formatTime(value), '09:05:03');
    expect(BrData.parse('31/12/2026'), DateTime(2026, 12, 31));
    expect(BrData.validate('31/02/2026'), isFalse);
  });

  test('documenta BrFormatter sem confundir formatação e validação', () {
    expect(BrFormatter.formatCpf('52998224725'), '529.982.247-25');
    expect(BrFormatter.stripCnpj('11.222.333/0001-81'), '11222333000181');
    expect(BrFormatter.formatCep('01001000'), '01001-000');
    expect(BrFormatter.formatPhone('11912345678'), '(11) 91234-5678');
    expect(
      BrFormatter.formatPhone('11912345678', ddd: false),
      '91234-5678',
    );
    expect(
      BrFormatter.formatCurrency(1234.5, symbol: false, decimals: 2),
      '1.234,50',
    );
    expect(() => BrFormatter.formatCpf('123'), throwsArgumentError);
  });

  test('documenta BrZod.validate aninhado e execução única', () {
    var calls = 0;
    final result = BrZod.validate(
      data: {
        'user': {'email': 'inválido'},
      },
      params: {
        'user': {
          'email': BrZod().custom(
            (value) {
              calls++;
              return value == 'dev@example.com';
            },
            message: 'E-mail inválido',
          ),
        },
      },
    );

    expect(calls, 1);
    expect(result.isNotValid, isTrue);
    expect(result.errors, {
      'user': {'email': 'E-mail inválido'},
    });
    expect(result.errorList.single, contains('user.email'));
  });

  test('documenta Contract e ValidationResult', () {
    final ValidationResult<String> result = Contract()
        .isEmail('inválido', 'email', 'E-mail inválido')
        .toResult('usuário');

    expect(result.isFailure, isTrue);
    expect(result.failureValue.single.property, 'email');
  });

  test('documenta CNPJ alfanumérico e extensões', () {
    const value = '12ABC34501DE35';

    expect(CnpjAlfanumerico.isValid(value), isTrue);
    expect(CnpjAlfanumerico.format(value), '12.ABC.345/01DE-35');
    expect(
      CnpjAlfanumerico.generate(forceAlphanumeric: true).substring(0, 12),
      contains(RegExp('[A-Z]')),
    );
    expect(() => CnpjAlfanumerico.format('curto'), throwsArgumentError);

    String? blank = '   ';
    List<int>? items;
    bool? enabled;
    expect(blank.isNullOrEmptyWithSpace, isTrue);
    expect(items.isNullOrEmpty, isTrue);
    expect(enabled.isTrue, isFalse);
    expect(enabled.isFalse, isFalse);
  });
}
