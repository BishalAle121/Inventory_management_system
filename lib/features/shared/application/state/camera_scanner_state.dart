import '../../domain/entities/scanned_details.dart';

abstract class CameraScannerState {
  const CameraScannerState();
}

class CameraScannerInitial extends CameraScannerState {
  const CameraScannerInitial();
}

// dart
class CameraScannerLoading extends CameraScannerState {
  const CameraScannerLoading();
} // dart

class CameraScannerError extends CameraScannerState {
  final String message;
  const CameraScannerError(this.message);
} // dart

class CameraScannerSuccess extends CameraScannerState {
  final String message;
  const CameraScannerSuccess(this.message);
}

class CameraScannerData extends CameraScannerState {
  final List<ScannedDetails> scannedItems;
  final Set<String> scannedCodes;
  final bool isLoading;

  const CameraScannerData({
    required this.scannedItems,
    required this.scannedCodes,
    this.isLoading = false,
  });
}

class CameraScannerItemDeleted extends CameraScannerState {
  final bool deleted;
  final String? message;
  const CameraScannerItemDeleted(this.deleted, {this.message});
}
