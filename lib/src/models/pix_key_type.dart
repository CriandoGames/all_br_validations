/// Tipos de chave PIX reconhecidos por `AllValidations.validatePixKey`.
enum PixKeyType {
  /// Cadastro de Pessoa Física.
  cpf,

  /// Cadastro Nacional da Pessoa Jurídica, numérico ou alfanumérico.
  cnpj,

  /// Número de celular brasileiro no formato internacional `+55`.
  phone,

  /// Endereço de e-mail.
  email,

  /// EVP hexadecimal no formato agrupado `8-4-4-4-12` gerado pelo DICT.
  random,
}
