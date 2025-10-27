// dart
import 'dart:math';

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
    try {
      final barcodes = capture.barcodes;
      final imageSize = capture.size;

      // 🔹 Start with existing scanned items if already in data state
      final currentItems = state is CameraScannerData
          ? List<ScannedDetails>.from((state as CameraScannerData).scannedItems)
          : <ScannedDetails>[];

      for (final barcode in barcodes) {
        final corners = barcode.corners;
        if (corners.isEmpty) continue;

        final captureData = barcode.rawValue;
        final format = barcode.format.name.toUpperCase();
        if (captureData == null || captureData.isEmpty) continue;

        // ✅ Skip duplicates
        if (alreadyScannedCodes.contains(captureData)) continue;

        // Build rect from corners
        final imageRect = _rectFromCorners(corners);

        // Map rect into widget coordinates
        final mappedRect = _mapImageRectToWidgetRect(
          imageRect,
          imageSize,
          widgetSize,
          fit: BoxFit.cover,
        );

        // Define scan box
        final scanRect = Rect.fromLTWH(
          (widgetSize.width - scanBoxSize) / 2,
          (widgetSize.height - scanBoxSize) / 2 - widgetSize.height * 0.2,
          scanBoxSize,
          scanBoxSize,
        );

        // ✅ Check overlap and add if valid
        if (scanRect.overlaps(mappedRect) ||
            scanRect.contains(mappedRect.center) ||
            mappedRect.overlaps(scanRect)) {

          alreadyScannedCodes.add(captureData);

          final scannedItem = ScannedDetails(
            serialNumber: captureData,
            qr_or_bar_code_format: format,
            scannedAt: DateTime.now().toString(),
          );

          // ✅ Add new item to existing list
          currentItems.insert(0, scannedItem);
        }
      }

      if (currentItems.isNotEmpty) {
        state = CameraScannerData(
          scannedItems: currentItems,
          scannedCodes: alreadyScannedCodes,
          isLoading: false,
        );
      }
    } catch (e) {
      state = CameraScannerError("Error reading barcodes: $e");
    }
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



Rect _rectFromCorners(List<Offset> corners) {
  final left = corners.map((c) => c.dx).reduce((a, b) => a < b ? a : b);
  final top = corners.map((c) => c.dy).reduce((a, b) => a < b ? a : b);
  final right = corners.map((c) => c.dx).reduce((a, b) => a > b ? a : b);
  final bottom = corners.map((c) => c.dy).reduce((a, b) => a > b ? a : b);
  return Rect.fromLTRB(left, top, right, bottom);
}

Rect _mapImageRectToWidgetRect(
    Rect imageRect,
    Size imageSize,
    Size widgetSize, {
      BoxFit fit = BoxFit.contain,
    }) {
  final scaleX = widgetSize.width / imageSize.width;
  final scaleY = widgetSize.height / imageSize.height;
  final scale = fit == BoxFit.cover ? max(scaleX, scaleY) : min(scaleX, scaleY);
  return Rect.fromLTRB(
    imageRect.left * scale,
    imageRect.top * scale,
    imageRect.right * scale,
    imageRect.bottom * scale,
  );
}
