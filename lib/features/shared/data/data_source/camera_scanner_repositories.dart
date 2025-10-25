import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:inventorymanagement/features/shared/data/models/scanned_details_modal.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraScannerService {
  /// Process barcodes from camera capture
  List<ScannedDetailsModal> processBarcodes(
    BarcodeCapture capture,
    Size widgetSize,
    double scanBoxSize,
  ) {
    final barcodes = capture.barcodes;
    final imageSize = capture.size;
    final validBarcodes = <ScannedDetailsModal>[];

    for (final barcode in barcodes) {
      final corners = barcode.corners;
      if (corners.isEmpty) continue;

      final captureData = barcode.rawValue;
      final format = barcode.format.name.toUpperCase();
      if (captureData == null || captureData.isEmpty) continue;

      // Build rect from corners
      final imageRect = _rectFromCorners(corners);

      // Map rect into widget coordinates
      final mappedRect = _mapImageRectToWidgetRect(
        imageRect,
        imageSize,
        widgetSize,
        fit: BoxFit.cover,
      );

      // Match the visual scan area positioning
      final scanRect = Rect.fromLTWH(
        (widgetSize.width - scanBoxSize) / 2,
        (widgetSize.height - scanBoxSize) / 2 - widgetSize.height * 0.2,
        scanBoxSize,
        scanBoxSize,
      );

      // Check if barcode is in scan area
      if (scanRect.overlaps(mappedRect) ||
          scanRect.contains(mappedRect.center) ||
          mappedRect.overlaps(scanRect)) {
        final scannedItem = ScannedDetailsModal(
          serialNumber: captureData,
          format: format,
          scannedAt: DateTime.now().toString(),
        );

        validBarcodes.add(scannedItem);
      }
    }

    return validBarcodes;
  }

  Rect _rectFromCorners(List<Offset> corners) {
    final xs = corners.map((o) => o.dx);
    final ys = corners.map((o) => o.dy);
    final minX = xs.reduce(math.min);
    final maxX = xs.reduce(math.max);
    final minY = ys.reduce(math.min);
    final maxY = ys.reduce(math.max);
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  Rect _mapImageRectToWidgetRect(
    Rect imageRect,
    Size imageSize,
    Size widgetSize, {
    BoxFit fit = BoxFit.cover,
  }) {
    if (imageSize.width == 0 || imageSize.height == 0) {
      return Rect.zero;
    }

    double scale;
    if (fit == BoxFit.cover) {
      scale = math.max(
        widgetSize.width / imageSize.width,
        widgetSize.height / imageSize.height,
      );
    } else {
      scale = math.min(
        widgetSize.width / imageSize.width,
        widgetSize.height / imageSize.height,
      );
    }

    final displayW = imageSize.width * scale;
    final displayH = imageSize.height * scale;

    final dx = (widgetSize.width - displayW) / 2;
    final dy = (widgetSize.height - displayH) / 2;

    return Rect.fromLTRB(
      imageRect.left * scale + dx,
      imageRect.top * scale + dy,
      imageRect.right * scale + dx,
      imageRect.bottom * scale + dy,
    );
  }
}
