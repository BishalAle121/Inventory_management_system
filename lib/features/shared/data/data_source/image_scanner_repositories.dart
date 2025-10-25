import 'package:image_picker/image_picker.dart';
import 'package:inventorymanagement/features/shared/data/models/scanned_details_modal.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ImageScannerService {
  final ImagePicker _picker;
  MobileScannerController? _scannerController;

  ImageScannerService({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  Future<List<ScannedDetailsModal>> scanFromGallery() async {
    _scannerController?.dispose();
    _scannerController = MobileScannerController();

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image == null) {
        throw Exception('No image selected');
      }

      final BarcodeCapture? result = await _scannerController!.analyzeImage(
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
      _scannerController?.dispose();
      _scannerController = null;
    }
  }

  void dispose() {
    _scannerController?.dispose();
    _scannerController = null;
  }
}
