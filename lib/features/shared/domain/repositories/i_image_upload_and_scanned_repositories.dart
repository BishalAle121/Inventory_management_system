import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../entities/scanned_details.dart';

abstract class IImageUploadAndScannedRepositories {
  // Camera scanning
  Future<Either<String, List<ScannedDetails>>> processCameraBarcodes(
    BarcodeCapture capture,
    Set<String> alreadyScannedCodes,
    Size widgetSize,
    double scanBoxSize,
  );

  // Image scanning
  Future<Either<String, List<ScannedDetails>>> processImageBarcodes(
    Set<String> alreadyScannedCodes,
  );

  // Common operations
  Future<Either<String, String>> saveScannedItems(List<ScannedDetails> items);
  Future<Either<String, Set<String>>> getExistingSerialNumbers();
  Future<bool> deleteItem(ScannedDetails item, Set<String> scannedCodes);
}
