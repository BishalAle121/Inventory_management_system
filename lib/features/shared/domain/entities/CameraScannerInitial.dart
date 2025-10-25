// dart
import '../../application/state/camera_scanner_state.dart';
import '../../domain/entities/scanned_details.dart';

class CameraScannerInitial extends CameraScannerState {
  final List<ScannedDetails> scannedItems;
  final Set<String> scannedCodes;
  final bool isTorchOn;
  final bool isAutoFocusEnabled;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const CameraScannerInitial({
    this.scannedItems = const [],
    this.scannedCodes = const {},
    this.isTorchOn = false,
    this.isAutoFocusEnabled = true,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });
}
