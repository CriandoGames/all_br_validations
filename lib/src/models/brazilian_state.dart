// ignore_for_file: constant_identifier_names
// Os valores do enum representam siglas oficiais de estados brasileiros (ex: SP, RJ).
// Renomear para lowerCamelCase seria uma breaking change e tornaria as siglas ilegíveis.
/// Unidades federativas identificadas pelas siglas oficiais.
///
/// [Unknown] representa um DDD ausente ou não atribuído.
enum BrazilianState {
  /// Acre.
  AC,

  /// Alagoas.
  AL,

  /// Amapá.
  AP,

  /// Amazonas.
  AM,

  /// Bahia.
  BA,

  /// Ceará.
  CE,

  /// Distrito Federal.
  DF,

  /// Espírito Santo.
  ES,

  /// Goiás.
  GO,

  /// Maranhão.
  MA,

  /// Mato Grosso.
  MT,

  /// Mato Grosso do Sul.
  MS,

  /// Minas Gerais.
  MG,

  /// Pará.
  PA,

  /// Paraíba.
  PB,

  /// Paraná.
  PR,

  /// Pernambuco.
  PE,

  /// Piauí.
  PI,

  /// Rio de Janeiro.
  RJ,

  /// Rio Grande do Norte.
  RN,

  /// Rio Grande do Sul.
  RS,

  /// Rondônia.
  RO,

  /// Roraima.
  RR,

  /// Santa Catarina.
  SC,

  /// São Paulo.
  SP,

  /// Sergipe.
  SE,

  /// Tocantins.
  TO,

  /// Código desconhecido ou sem unidade federativa associada.
  Unknown
}
