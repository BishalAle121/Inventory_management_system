import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:inventorymanagement/features/shared/data/models/scanned_details_modal.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../domain/entities/scanned_details.dart';
import '../../domain/repositories/i_image_upload_and_scanned_repositories.dart';
import '../data_source/camera_scanner_repositories.dart';
import '../data_source/image_scanner_repositories.dart';
import '../data_source/scanner_local_repositories.dart';

class ScannerRepositoryImpl implements IImageUploadAndScannedRepositories {
  final CameraScannerService cameraScannerService;
  final ImageScannerService imageScannerService;
  final ScannerLocalDataSource localDataSource;

  ScannerRepositoryImpl({
    required this.cameraScannerService,
    required this.imageScannerService,
    required this.localDataSource,
  });

  @override
  Future<Either<String, List<ScannedDetails>>> processCameraBarcodes(
    BarcodeCapture capture,
    Set<String> alreadyScannedCodes,
    Size widgetSize,
    double scanBoxSize,
  ) async {
    try {
      final validBarcodes = cameraScannerService.processBarcodes(
        capture,
        widgetSize,
        scanBoxSize,
      );

      if (validBarcodes.isEmpty) {
        return const Left('No barcodes found in scan area');
      }

      return await _filterAndReturnNewItems(validBarcodes, alreadyScannedCodes);
    } catch (e) {
      return Left('Error processing camera barcodes: $e');
    }
  }

  @override
  Future<Either<String, List<ScannedDetails>>> processImageBarcodes(
    Set<String> alreadyScannedCodes,
  ) async {
    try {
      final scannedItems = await imageScannerService.scanFromGallery();

      if (scannedItems.isEmpty) {
        return const Left('No barcodes found in image');
      }

      return await _filterAndReturnNewItems(scannedItems, alreadyScannedCodes);
    } catch (e) {
      return Left('Error processing image: $e');
    }
  }

  Future<Either<String, List<ScannedDetails>>> _filterAndReturnNewItems(
    List<ScannedDetailsModal> scannedItems,
    Set<String> alreadyScannedCodes,
  ) async {
    final newItems = <ScannedDetails>[];
    final duplicateItems = <String>[];

    for (final item in scannedItems) {
      // Skip if already in current session
      if (alreadyScannedCodes.contains(item.serialNumber)) {
        duplicateItems.add(item.serialNumber);
        continue;
      }

      // Check database for duplicates
      final existsInDb = await localDataSource.checkDuplicateExists(
        item.serialNumber,
      );

      if (!existsInDb) {
        newItems.add(item);
      } else {
        duplicateItems.add(item.serialNumber);
      }
    }

    if (newItems.isEmpty && duplicateItems.isNotEmpty) {
      return Left('All ${duplicateItems.length} code(s) are duplicates');
    }

    final message = duplicateItems.isNotEmpty
        ? '${newItems.length} new, ${duplicateItems.length} duplicate(s) filtered'
        : '${newItems.length} new code(s) scanned';

    return Right(newItems);
  }

  @override
  Future<Either<String, String>> saveScannedItems(
    List<ScannedDetails> items,
  ) async {
    try {
      final models = items
          .map((item) => ScannedDetailsModal.fromJson(item.toJson()))
          .toList();
      final response = await localDataSource.saveItems(models);
      return Right(response);
    } catch (e) {
      return Left('Error saving items: $e');
    }
  }

  @override
  Future<Either<String, Set<String>>> getExistingSerialNumbers() async {
    try {
      final serialNumbers = await localDataSource.getExistingSerialNumbers();
      return Right(serialNumbers);
    } catch (e) {
      return Left('Error fetching serial numbers: $e');
    }
  }

  @override
  Future<bool> deleteItem(ScannedDetails item, Set<String> scannedCodes) async {
    try {
      scannedCodes.remove(item.serialNumber);
      // You could also delete from local DB here if needed
      return true; // successfully deleted
    } catch (e) {
      return false; // deletion failed
    }
  }
}
