/// Utilitários de data e hora para o contexto brasileiro.
///
/// Todos os métodos operam sobre [DateTime] do Dart — sem dependência
/// do pacote `intl`. Padrão de exibição: `DD/MM/AAAA`.
class BrData {
  BrData._();

  // ════════════════════════════════════════════════════════════════════════════
  // Formatação
  // ════════════════════════════════════════════════════════════════════════════

  /// Formata uma data → `'DD/MM/AAAA'`.
  ///
  /// Exemplo: `BrData.format(DateTime(2026, 7, 1))` → `'01/07/2026'`.
  static String format(DateTime dt) =>
      '${_pad(dt.day)}/${_pad(dt.month)}/${dt.year}';

  /// Formata uma data → `'MM/AAAA'`.
  static String formatMonthYear(DateTime dt) => '${_pad(dt.month)}/${dt.year}';

  /// Formata uma data → `'DD/MM'`.
  static String formatDayMonth(DateTime dt) =>
      '${_pad(dt.day)}/${_pad(dt.month)}';

  /// Formata a hora → `'HH:MM:SS'`.
  static String formatTime(DateTime dt) =>
      '${_pad(dt.hour)}:${_pad(dt.minute)}:${_pad(dt.second)}';

  /// Formata a hora → `'HH:MM'`.
  static String formatTimeShort(DateTime dt) =>
      '${_pad(dt.hour)}:${_pad(dt.minute)}';

  // ════════════════════════════════════════════════════════════════════════════
  // Parse
  // ════════════════════════════════════════════════════════════════════════════

  /// Converte `'DD/MM/AAAA'` → [DateTime] (hora zerada).
  ///
  /// Lança [FormatException] se a string não estiver no formato esperado
  /// ou representar uma data inválida (ex.: `'31/02/2024'`).
  static DateTime parse(String date) {
    if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(date)) {
      throw FormatException('Data inválida (esperado DD/MM/AAAA): $date');
    }
    final parts = date.split('/');
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    _assertDateValid(day, month, year, date);
    return DateTime(year, month, day);
  }

  /// Converte `'DD/MM/AAAA HH:MM'` → [DateTime].
  ///
  /// Lança [FormatException] se a string estiver fora do formato esperado.
  static DateTime parseWithTime(String dateTime) {
    if (!RegExp(r'^\d{2}/\d{2}/\d{4} \d{2}:\d{2}$').hasMatch(dateTime)) {
      throw FormatException(
          'Data/hora inválida (esperado DD/MM/AAAA HH:MM): $dateTime');
    }
    final pieces = dateTime.split(' ');
    final dt = parse(pieces[0]);
    final timeParts = pieces[1].split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    if (hour > 23 || minute > 59) {
      throw FormatException('Hora inválida: ${pieces[1]}');
    }
    return DateTime(
      dt.year,
      dt.month,
      dt.day,
      hour,
      minute,
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // Validação
  // ════════════════════════════════════════════════════════════════════════════

  /// Valida uma string de data no formato `'DD/MM/AAAA'`.
  ///
  /// Retorna `false` para datas inexistentes (ex.: `'31/02/2024'`).
  static bool validate(String date) {
    try {
      if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(date)) return false;
      final parts = date.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      if (month < 1 || month > 12) return false;
      if (day < 1 || day > _daysInMonth(year, month)) return false;
      return true;
    } catch (_) {
      return false;
    }
  }

  // ════════════════════════════════════════════════════════════════════════════
  // Privado
  // ════════════════════════════════════════════════════════════════════════════

  static String _pad(int n) => n.toString().padLeft(2, '0');

  static int _daysInMonth(int year, int month) {
    if (month == 2) {
      final leap = (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
      return leap ? 29 : 28;
    }
    const days = [0, 31, 0, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return days[month];
  }

  static void _assertDateValid(int day, int month, int year, String raw) {
    if (month < 1 || month > 12) {
      throw FormatException('Mês inválido em: $raw');
    }
    if (day < 1 || day > _daysInMonth(year, month)) {
      throw FormatException('Dia inválido em: $raw');
    }
  }
}
