/// Catálogos públicos dos meses em português do Brasil.
class AllValidationsGetMonth {
  /// Meses de janeiro a dezembro.
  ///
  /// A lista permanece mutável por compatibilidade e deve ser tratada pelos
  /// consumidores como somente leitura.
  static List<String> listMonths = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  /// Associa cada nome de mês ao número de 1 a 12.
  static Map<String, int> mapMonths = const {
    'Janeiro': 1,
    'Fevereiro': 2,
    'Março': 3,
    'Abril': 4,
    'Maio': 5,
    'Junho': 6,
    'Julho': 7,
    'Agosto': 8,
    'Setembro': 9,
    'Outubro': 10,
    'Novembro': 11,
    'Dezembro': 12
  };
}
