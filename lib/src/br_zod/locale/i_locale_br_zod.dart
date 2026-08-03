/// Interface de mensagens de erro do [BrZod].
///
/// Implemente esta interface para criar um locale customizado:
/// ```dart
/// class MyLocale implements ILocaleBrZod {
///   @override
///   String get required => 'Campo obrigatório';
///   // ...
/// }
///
/// BrZod(locale: MyLocale()).required().email().build
/// ```
abstract interface class ILocaleBrZod {
  // ── Genéricas ──────────────────────────────────────────────
  /// Mensagem para campo obrigatório ausente ou vazio.
  String get required;

  /// Mensagem para endereço de e-mail inválido.
  String get email;

  /// Mensagem para telefone inválido.
  String get phone;

  /// Mensagem para valores que deveriam ser iguais.
  String get equals;

  /// Mensagem padrão de validação customizada.
  String get custom;

  /// Mensagem de campo opcional cujo valor informado é inválido.
  String get optional;

  /// Mensagem para data inexistente ou em formato não aceito.
  String get invalidDate;

  /// Mensagem para valor de tipo ou coerção incompatível.
  String get invalidType;

  /// Mensagem para texto menor que [n] caracteres.
  String min(int n);

  /// Mensagem para texto maior que [n] caracteres.
  String max(int n);

  /// Mensagem para data que deve ocorrer depois de [date].
  String minDate(DateTime date);

  /// Mensagem para data que deve ocorrer antes de [date].
  String maxDate(DateTime date);

  // ── Segurança ───────────────────────────────────────────────
  /// Mensagem para senha fora da política configurada.
  String get password;

  /// Mensagem para UUID inválido.
  String get uuid;

  /// Mensagem para URL inválida.
  String get url;

  /// Mensagem para endereço IPv4 inválido.
  String get ipv4;

  /// Mensagem para endereço IPv6 inválido.
  String get ipv6;

  /// Mensagem para valor incompatível com uma expressão regular.
  String get regex;

  // ── Documentos BR ──────────────────────────────────────────
  /// Mensagem para CPF inválido.
  String get cpf;

  /// Mensagem para CNPJ numérico inválido.
  String get cnpj;

  /// Mensagem para CNPJ alfanumérico inválido.
  String get cnpjAlfa;

  /// Mensagem para valor que não seja CPF nem CNPJ numérico.
  String get cpfCnpj;

  /// Mensagem para CEP inválido.
  String get cep;

  /// Mensagem para RG inválido.
  String get rg;

  /// Mensagem para placa veicular brasileira inválida.
  String get placa;

  /// Mensagem para CNH inválida.
  String get cnh;

  /// Mensagem para RENAVAM inválido.
  String get renavam;

  /// Mensagem para PIS/PASEP inválido.
  String get pisPasep;

  /// Mensagem para título de eleitor inválido.
  String get tituloEleitor;

  /// Mensagem para número do Cartão Nacional de Saúde inválido.
  String get cns;
}
