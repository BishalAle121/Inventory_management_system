import 'package:inventorymanagement/features/shared/domain/entities/scanned_details.dart';

class ScannedDetailsModal extends ScannedDetails {
  ScannedDetailsModal({
    String? scannedId,
    required String serialNumber,
    required String format,
    required String scannedAt,
  }) : super(
         id: scannedId,
         serialNumber: serialNumber,
         qr_or_bar_code_format: format,
         scannedAt: scannedAt,
       );

  // ✅ Factory constructor to read data from SQLite/API JSON
  factory ScannedDetailsModal.fromJson(Map<String, dynamic> json) {
    return ScannedDetailsModal(
      scannedId: json['id']?.toString(), // SQLite PK NEWID or API ID
      serialNumber: json['serialNumber'] ?? "", // Matches your column/key
      format: json['scanned_type'] ?? "", // Matches your column/key
      scannedAt:
          json['scannedAt']?.toString() ?? "", // Store timestamp as String
    );
  }

  // ✅ Convert model to Map for inserting into SQLite / sending to API
  Map<String, dynamic> toJson() {
    return {
      'serialNumber': serialNumber,
      'scanned_type': qr_or_bar_code_format,
      'scannedAt': scannedAt,
    };
  }
}
