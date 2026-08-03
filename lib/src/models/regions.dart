/// Catálogo das cinco regiões geográficas brasileiras.
class AllValidationsGetRegions {
  /// Cria um acesso ao catálogo de regiões por compatibilidade legada.
  ///
  /// O catálogo é estático e pode ser consultado sem instanciar a classe.
  AllValidationsGetRegions();

  /// Regiões em ordem alfabética.
  static const List<String> listRegions = [
    'Centro-Oeste',
    'Nordeste',
    'Norte',
    'Sudeste',
    'Sul'
  ];
}
