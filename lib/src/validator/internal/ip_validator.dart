/// Valida um endereço IPv6 completo ou comprimido, com zona opcional.
///
/// A zona deve ser informada após um único caractere %, como em
/// fe80::1%eth0. Endereços IPv4 puros não são aceitos, mas a notação IPv4
/// incorporada a IPv6 continua válida.
bool isValidIpv6(String value) {
  if (value.isEmpty) return false;

  final zoneParts = value.split('%');
  if (zoneParts.length > 2 || (zoneParts.length == 2 && zoneParts[1].isEmpty)) {
    return false;
  }

  var address = zoneParts.first;
  if (!address.contains(':')) return false;

  if (address.contains('.')) {
    final lastColon = address.lastIndexOf(':');
    if (lastColon < 0) return false;
    final ipv4 = address.substring(lastColon + 1);
    final octets = ipv4.split('.');
    if (octets.length != 4) return false;
    final parsed = <int>[];
    for (final octet in octets) {
      if (!RegExp(r'^\d{1,3}$').hasMatch(octet)) return false;
      final number = int.parse(octet);
      if (number > 255) return false;
      parsed.add(number);
    }
    final high = ((parsed[0] << 8) | parsed[1]).toRadixString(16);
    final low = ((parsed[2] << 8) | parsed[3]).toRadixString(16);
    address = '${address.substring(0, lastColon)}:$high:$low';
  }

  final compressedParts = address.split('::');
  if (compressedParts.length > 2) return false;

  final hasCompression = compressedParts.length == 2;
  final left = compressedParts.first.isEmpty
      ? <String>[]
      : compressedParts.first.split(':');
  final right = hasCompression && compressedParts.last.isNotEmpty
      ? compressedParts.last.split(':')
      : <String>[];
  final groups = [...left, ...right];

  final validGroup = RegExp(r'^[0-9A-Fa-f]{1,4}$');
  if (groups.any((group) => !validGroup.hasMatch(group))) return false;

  return hasCompression ? groups.length < 8 : groups.length == 8;
}
