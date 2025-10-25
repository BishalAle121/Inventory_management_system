// dart
class ScannedDetails {
  final String? id; // Primary Key or UUID from SQLite/API
  final String serialNumber; // The scanned serial number
  final String qr_or_bar_code_format; // The barcode format (QR, Code128, etc.)
  final String scannedAt; // When it was scanned (as String or ISO timestamp)

  ScannedDetails({
    this.id,
    required this.serialNumber,
    required this.qr_or_bar_code_format,
    required this.scannedAt,
  });

  /// Convert the domain entity to a JSON map for persistence/serialization.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serialNumber': serialNumber,
      'qr_or_bar_code_format': qr_or_bar_code_format,
      'scannedAt': scannedAt,
    };
  }
}
