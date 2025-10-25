import 'package:image_picker/image_picker.dart';
import 'package:inventorymanagement/features/shared/data/models/scanned_details_modal.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerService {
  final ImagePicker _picker;
  final MobileScannerController _scannerController;

  ScannerService({
    ImagePicker? picker,
    MobileScannerController? scannerController,
  }) : _picker = picker ?? ImagePicker(),
       _scannerController = scannerController ?? MobileScannerController();

  Future<List<ScannedDetailsModal>> scanFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image == null) {
        throw Exception('No image selected');
      }

      final BarcodeCapture? result = await _scannerController.analyzeImage(
        image.path,
      );

      if (result == null || result.barcodes.isEmpty) {
        throw Exception('No QR code or barcode found in the image');
      }

      return result.barcodes.map((barcode) {
        return ScannedDetailsModal(
          serialNumber: barcode.rawValue ?? "",
          format: barcode.type.toString(),
          scannedAt: DateTime.now().toIso8601String(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Error scanning image: $e');
    } finally {
      _scannerController.dispose();
    }
  }
}
