// dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventorymanagement/features/shared/application/state/camera_scanner_state.dart';
import '../../../../core/providers/network_providers.dart';
import '../../data/data_source/camera_scanner_repositories.dart';
import '../../data/data_source/image_scanner_repositories.dart';
import '../../data/data_source/scanner_local_repositories.dart';
import '../../domain/entities/scanned_details.dart';
import '../../domain/repositories/i_image_upload_and_scanned_repositories.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';

final cameraScannerProvider =
    StateNotifierProvider<CameraScannerNotifier, CameraScannerState>((ref) {
      final repo = ref.watch(imageUploadAndScannedRepositoryProvider);
      return CameraScannerNotifier(repo);
    });

final scannerLocalDataSourceProvider = Provider<ScannerLocalDataSource>((ref) {
  return ScannerLocalDataSource();
});

final cameraScannerServiceProvider = Provider<CameraScannerService>((ref) {
  return CameraScannerService();
});

final imageScannerServiceProvider = Provider<ImageScannerService>((ref) {
  return ImageScannerService();
});

class CameraScannerNotifier extends StateNotifier<CameraScannerState> {
  final IImageUploadAndScannedRepositories _repository;

  CameraScannerNotifier(this._repository) : super(const CameraScannerInitial());

  Future<void> processCameraBarcodes(
    BarcodeCapture capture,
    Set<String> alreadyScannedCodes,
    Size widgetSize,
    double scanBoxSize,
  ) async {
    state = const CameraScannerLoading();

    final result = await _repository.processCameraBarcodes(
      capture,
      alreadyScannedCodes,
      widgetSize,
      scanBoxSize,
    );

    state = result.fold(
      (error) => CameraScannerError(error),
      (scannedItems) => CameraScannerData(
        scannedItems: scannedItems,
        scannedCodes: alreadyScannedCodes,
        isLoading: false,
      ),
    );
  }

  Future<void> saveScannedItems(List<ScannedDetails> items) async {
    state = const CameraScannerLoading();

    final result = await _repository.saveScannedItems(items);

    state = result.fold(
      (error) => CameraScannerError(error),
      (message) => CameraScannerSuccess(message),
    );
  }

  Future<void> deleteItem(ScannedDetails item, Set<String> scannedCodes) async {
    state = const CameraScannerLoading();

    final deletedResult = await _repository.deleteItem(item, scannedCodes);
    // assume repository returns `bool` or `Future<bool>`; adjust if it returns different shape
    state = CameraScannerItemDeleted(
      deletedResult,
      message: deletedResult ? 'Deleted' : 'Delete failed',
    );
  }
}
