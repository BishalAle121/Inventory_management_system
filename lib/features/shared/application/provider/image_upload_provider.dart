import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/network_providers.dart';
import '../../domain/entities/scanned_details.dart';
import '../../domain/repositories/i_image_upload_and_scanned_repositories.dart';
import '../state/image_upload_state.dart';

final imageUploadProvider =
    StateNotifierProvider<ImageUploadNotifier, ImageScannerState>((ref) {
      final repo = ref.watch(imageUploadAndScannedRepositoryProvider);
      return ImageUploadNotifier(repo);
    });

class ImageUploadNotifier extends StateNotifier<ImageScannerState> {
  final IImageUploadAndScannedRepositories _repository;

  ImageUploadNotifier(this._repository) : super(const ImageScannerInitial());

  /// Step 1: Pick image from gallery
  Future<void> pickImageAndScan(Set<String> alreadyScannedCodes) async {
    state = const ImageScannerPickingImage();

    try {
      // Step 2: Simulate image picking (replace with your actual picker logic)
      final String imagePath = await _pickImageFromGallery();

      // Step 3: Update UI to "Analyzing"
      state = ImageScannerAnalyzing(imagePath: imagePath);

      // Step 4: Process the image for barcodes
      final result = await _repository.processImageBarcodes(
        alreadyScannedCodes,
      );

      // Step 5: Show success or error
      state = result.fold(
        (error) => ImageScannerError(error),
        (scannedItems) => ImageUploadData(
          scannedItems: scannedItems,
          scannedCodes: alreadyScannedCodes,
          isLoading: false,
        ),
      );
    } catch (e) {
      state = ImageScannerError('Failed to pick or analyze image: $e');
    }
  }

  /// Save items
  Future<void> saveScannedItems(List<ScannedDetails> items) async {
    state = const ImageUploadLoading();

    final result = await _repository.saveScannedItems(items);

    state = result.fold(
      (error) => ImageScannerError(error),
      (message) => ImageScannerSuccess(message),
    );
  }

  /// Delete item
  Future<void> deleteItem(ScannedDetails item, Set<String> scannedCodes) async {
    state = const ImageUploadLoading();

    final deletedResult = await _repository.deleteItem(item, scannedCodes);

    state = ImageUploadDeleted(
      deletedResult,
      message: deletedResult ? 'Deleted' : 'Delete failed',
    );
  }

  /// Dummy function to simulate picking an image
  Future<String> _pickImageFromGallery() async {
    await Future.delayed(const Duration(seconds: 1));
    return 'path/to/picked_image.jpg';
  }
}
