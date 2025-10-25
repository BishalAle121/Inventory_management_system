/*
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/providers/storage_providers.dart';
import '../../model/scanned_item_modal.dart';

Future<ListOfScannedDataAndResponseMessage> uploadImageAndScan(WidgetRef ref) async {
  final ImagePicker picker = ImagePicker();
  final MobileScannerController scannerController = MobileScannerController();

  final databaseHelper = ref.read(databaseHelperProvider);

  try {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (image != null) {
      final BarcodeCapture? result = await scannerController.analyzeImage(image.path);

      if (result != null && result.barcodes.isNotEmpty) {
        // Get existing serial numbers from database
        final List<Map<String, dynamic>> existingRecords = await databaseHelper.readData('SerialNumberStoreTable');

        // Extract serial numbers from database records
        // Assuming the column name is 'serialNumber' - adjust if different
        final Set<String> existingSerialNumbers = existingRecords
            .map((record) => record['serialNumber'] as String?)
            .where((serialNumber) => serialNumber != null)
            .cast<String>()
            .toSet();

        // Filter out duplicates - keep only new barcodes
        final List<Barcode> newBarcodes = result.barcodes.where(
              (barcode) => !existingSerialNumbers.contains(barcode.rawValue),
        ).toList();

        if (newBarcodes.isNotEmpty) {
          // Create ScannedItemModal objects for new barcodes
          final List<ScannedItemModal> scannedItems = newBarcodes.map((barcode) {
            return ScannedItemModal(
              serialNumber: barcode.rawValue ?? "",
              format: barcode.type.toString(),
              scannedAt: DateTime.now().toIso8601String(),
            );
          }).toList();

          return ListOfScannedDataAndResponseMessage(
            listOfScannedData: scannedItems,
            responseMessage: "Success: ${newBarcodes.length} new code(s) scanned, "
                "${result.barcodes.length - newBarcodes.length} duplicate(s) filtered",
          );
        } else {
          return ListOfScannedDataAndResponseMessage(
            listOfScannedData: [],
            responseMessage: "Error: All ${result.barcodes.length} scanned code(s) are duplicates",
          );
        }
      } else {
        return ListOfScannedDataAndResponseMessage(
          listOfScannedData: [],
          responseMessage: "Error: No QR code or barcode found in the image",
        );
      }
    } else {
      return ListOfScannedDataAndResponseMessage(
        listOfScannedData: [],
        responseMessage: "Error: No image selected",
      );
    }
  } catch (e) {
    return ListOfScannedDataAndResponseMessage(
      listOfScannedData: [],
      responseMessage: "Error scanning image: $e",
    );
  } finally {
    scannerController.dispose();
  }
}*/
