import '../../domain/entities/scanned_details.dart';

abstract class ImageScannerState {
  const ImageScannerState();
}

/// Initial state
class ImageScannerInitial extends ImageScannerState {
  const ImageScannerInitial();
}

class ImageUploadLoading extends ImageScannerState {
  const ImageUploadLoading();
}

/// Picking image from gallery
class ImageScannerPickingImage extends ImageScannerState {
  const ImageScannerPickingImage();
}

/// Analyzing picked image
class ImageScannerAnalyzing extends ImageScannerState {
  final String? imagePath;
  const ImageScannerAnalyzing({this.imagePath});
}

class ImageScannerError extends ImageScannerState {
  final String message;
  const ImageScannerError(this.message);
}

class ImageScannerSuccess extends ImageScannerState {
  final String message;
  const ImageScannerSuccess(this.message);
}

/// ✅ The main loaded state after scanning image
class ImageUploadData extends ImageScannerState {
  final List<ScannedDetails> scannedItems;
  final Set<String> scannedCodes;
  final bool isLoading;

  const ImageUploadData({
    required this.scannedItems,
    required this.scannedCodes,
    this.isLoading = false,
  });
}

/// ✅ For deletion result
class ImageUploadDeleted extends ImageScannerState {
  final bool deleted;
  final String? message;
  const ImageUploadDeleted(this.deleted, {this.message});
}
