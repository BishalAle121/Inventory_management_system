// dart
import '../../application/state/camera_scanner_state.dart';
import '../../domain/entities/scanned_details.dart';

class CameraScannerData extends CameraScannerState {
  final List<ScannedDetails> scannedItems;
  final Set<String> scannedCodes;
  final bool isTorchOn;
  final bool isAutoFocusEnabled;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const CameraScannerData({
    required this.scannedItems,
    required this.scannedCodes,
    required this.isTorchOn,
    required this.isAutoFocusEnabled,
    required this.isLoading,
    this.errorMessage,
    this.successMessage,
  });

  CameraScannerData copyWith({
    List<ScannedDetails>? scannedItems,
    Set<String>? scannedCodes,
    bool? isTorchOn,
    bool? isAutoFocusEnabled,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return CameraScannerData(
      scannedItems: scannedItems ?? this.scannedItems,
      scannedCodes: scannedCodes ?? this.scannedCodes,
      isTorchOn: isTorchOn ?? this.isTorchOn,
      isAutoFocusEnabled: isAutoFocusEnabled ?? this.isAutoFocusEnabled,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
