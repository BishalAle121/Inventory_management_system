import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventorymanagement/core/providers/storage_providers.dart';
import 'package:inventorymanagement/features/shared/data/models/scanned_details_modal.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

Future<bool> imageUploadAndScan(BuildContext context, WidgetRef ref) async {
  final dbProvider = ref.read(databaseHelperProvider);
  final ImagePicker picker = ImagePicker();
  final MobileScannerController scannerController = MobileScannerController();

  try {
    // Pick image from gallery
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (image == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error: No image selected"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }

    // Analyze image for barcodes
    final BarcodeCapture? result = await scannerController.analyzeImage(
      image.path,
    );

    if (result == null || result.barcodes.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error: No QR code or barcode found in the image"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }

    // Get all existing serial numbers from DB
    final List<Map<String, dynamic>> existingRecords = await dbProvider
        .readData('SerialNumberStoreTable');

    final Set<String> existingSerialNumbers = existingRecords
        .map((record) => record['serialNumber'] as String?)
        .where((sn) => sn != null)
        .cast<String>()
        .toSet();

    // Filter new barcodes (avoid duplicates)
    final List<Barcode> newBarcodes = result.barcodes
        .where((barcode) => !existingSerialNumbers.contains(barcode.rawValue))
        .toList();

    if (newBarcodes.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "All ${result.barcodes.length} scanned code(s) are duplicates.",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }

    // Convert barcodes to your model
    final List<ScannedDetailsModal> scannedItems = newBarcodes.map((barcode) {
      return ScannedDetailsModal(
        serialNumber: barcode.rawValue ?? "",
        format: barcode.type.toString(),
        scannedAt: DateTime.now().toIso8601String(),
      );
    }).toList();

    // Insert into DB
    final List<Map<String, dynamic>> codeMaps = scannedItems
        .map((item) => item.toJson())
        .toList();

    final dbResponse = await dbProvider.insertDataList(
      "SerialNumberStoreTable",
      codeMaps,
    );

    // Show success message
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "✅ ${scannedItems.length} new code(s) scanned.\n$dbResponse",
          ),
          backgroundColor: Colors.green,
        ),
      );
    }

    return true; // ✅ Success - data was added
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error scanning image: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
    return false;
  } finally {
    scannerController.dispose();
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:inventorymanagement/core/providers/storage_providers.dart';
// import 'package:inventorymanagement/features/shared/data/models/scanned_details_modal.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
//
// Future<void> imageUploadAndScan(BuildContext context, WidgetRef ref) async {
//   final dbProvider = ref.read(databaseHelperProvider);
//   final ImagePicker picker = ImagePicker();
//   final MobileScannerController scannerController = MobileScannerController();
//
//   try {
//     // Pick image from gallery
//     final XFile? image = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 100,
//     );
//
//     if (image == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Error: No image selected"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     // Analyze image for barcodes
//     final BarcodeCapture? result = await scannerController.analyzeImage(
//       image.path,
//     );
//
//     if (result == null || result.barcodes.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Error: No QR code or barcode found in the image"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     // Get all existing serial numbers from DB
//     final List<Map<String, dynamic>> existingRecords = await dbProvider
//         .readData('SerialNumberStoreTable');
//
//     final Set<String> existingSerialNumbers = existingRecords
//         .map((record) => record['serialNumber'] as String?)
//         .where((sn) => sn != null)
//         .cast<String>()
//         .toSet();
//
//     // Filter new barcodes (avoid duplicates)
//     final List<Barcode> newBarcodes = result.barcodes
//         .where((barcode) => !existingSerialNumbers.contains(barcode.rawValue))
//         .toList();
//
//     if (newBarcodes.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             "All ${result.barcodes.length} scanned code(s) are duplicates.",
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     // Convert barcodes to your model
//     final List<ScannedDetailsModal> scannedItems = newBarcodes.map((barcode) {
//       return ScannedDetailsModal(
//         serialNumber: barcode.rawValue ?? "",
//         format: barcode.type.toString(),
//         scannedAt: DateTime.now().toIso8601String(),
//       );
//     }).toList();
//
//     // Insert into DB
//     final List<Map<String, dynamic>> codeMaps = scannedItems
//         .map((item) => item.toJson())
//         .toList();
//
//     final dbResponse = await dbProvider.insertDataList(
//       "SerialNumberStoreTable",
//       codeMaps,
//     );
//
//     // Show success message
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           "✅ ${scannedItems.length} new code(s) scanned.\n$dbResponse",
//         ),
//         backgroundColor: Colors.green,
//       ),
//     );
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Error scanning image: $e"),
//         backgroundColor: Colors.red,
//       ),
//     );
//   } finally {
//     scannerController.dispose();
//   }
// }

/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/provider/image_upload_provider.dart';
import '../../application/state/image_upload_state.dart';

class ImageScannerScreen extends ConsumerWidget {
  const ImageScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imageUploadProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Image Scanner')),
      body: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              ref
                  .read(imageUploadProvider.notifier)
                  .pickImageAndScan(<String>{});
            },
            icon: const Icon(Icons.image),
            label: const Text('Select Image & Scan'),
          ),
          const SizedBox(height: 20),
          Expanded(child: _buildScannedList(state, ref)),
        ],
      ),
    );
  }

  Widget _buildScannedList(ImageScannerState state, WidgetRef ref) {
    if (state is ImageUploadLoading ||
        state is ImageScannerPickingImage ||
        state is ImageScannerAnalyzing) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ImageScannerError) {
      return Center(child: Text('Error: ${state.message}'));
    }

    if (state is ImageUploadData) {
      final items = state.scannedItems;
      final codes = state.scannedCodes;

      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.serialNumber),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                ref.read(imageUploadProvider.notifier).deleteItem(item, codes);
              },
            ),
          );
        },
      );
    }

    return const Center(child: Text('Pick an image to scan'));
  }
}
*/
