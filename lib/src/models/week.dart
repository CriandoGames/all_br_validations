/// Catálogos de dias úteis e dias da semana em português do Brasil.
class AllValidationsGetWeek {
  /// Dias úteis por extenso, de segunda a sexta-feira.
  static const List<String> listWorkDays = [
    'Segunda-Feira',
    'Terça-Feira',
    'Quarta-Feira',
    'Quinta-Feira',
    'Sexta-Feira',
  ];

  /// Numeração dos dias úteis, com segunda-feira igual a 1.
  static Map<String, int> mapWorkDays = const {
    'Segunda-Feira': 1,
    'Terça-Feira': 2,
    'Quarta-Feira': 3,
    'Quinta-Feira': 4,
    'Sexta-Feira': 5,
  };

  /// Formas abreviadas dos dias úteis, de segunda a sexta.
  ///
  /// A lista permanece mutável por compatibilidade.
  static List<String> listWorkDaysAbvr = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
  ];

  /// Numeração das formas abreviadas de dias úteis.
  static Map<String, int> mapWorkDaysAbvr = const {
    'Segunda': 1,
    'Terça': 2,
    'Quarta': 3,
    'Quinta': 4,
    'Sexta': 5,
  };

  /// Semana por extenso iniciada na segunda-feira.
  static const List<String> listDaysWeek = [
    'Segunda-Feira',
    'Terça-Feira',
    'Quarta-Feira',
    'Quinta-Feira',
    'Sexta-Feira',
    'Sábado',
    'Domingo'
  ];

  /// Semana abreviada iniciada na segunda-feira.
  static const List<String> listDaysWeekAbvr = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo'
  ];

  /// Numeração da semana por extenso iniciada no domingo.
  static Map<String, int> mapDaysWeekOrdered = const {
    'Domingo': 1,
    'Segunda-Feira': 2,
    'Terça-Feira': 3,
    'Quarta-Feira': 4,
    'Quinta-Feira': 5,
    'Sexta-Feira': 6,
    'Sábado': 7,
  };

  /// Semana abreviada iniciada no domingo.
  ///
  /// Diferentemente de [listDaysWeek], esta lista segue a ordenação dominical
  /// e permanece mutável por compatibilidade.
  static List<String> listDaysWeekOrdered = [
    'Domingo',
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
  ];

  /// Numeração da semana abreviada iniciada no domingo.
  static Map<String, int> mapDaysWeekOrderAbvr = const {
    'Domingo': 1,
    'Segunda': 2,
    'Terça': 3,
    'Quarta': 4,
    'Quinta': 5,
    'Sexta': 6,
    'Sábado': 7,
  };
}
