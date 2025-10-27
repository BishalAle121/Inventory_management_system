import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventorymanagement/core/utils/local_storage/sqlite_manager/database_helper.dart';

import '../../../../core/providers/storage_providers.dart';
import '../../../shared/data/models/scanned_details_modal.dart';
import '../../../shared/presentation/widgets/ScannedDetailsList.dart';
import '../../../shared/presentation/widgets/camere_scann_widget.dart';
import '../../../shared/presentation/widgets/image_upload_widget.dart';

class InstallationScreen extends ConsumerStatefulWidget {
  const InstallationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<InstallationScreen> createState() => _InstallationScreenState();
}

class _InstallationScreenState extends ConsumerState<InstallationScreen> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<List<String>> _descriptionsNotifier = ValueNotifier([]);
  late final DatabaseHelper _databaseHelperProvider;

  initState() {
    super.initState();
    _databaseHelperProvider = ref.read(databaseHelperProvider);
    _loadScannedData();
  }

  // You can manage scanned data here if needed
  List<ScannedDetailsModal> _scannedItems = [];
  Future<void> _loadScannedData() async {
    final List<Map<String, dynamic>> rawData = await _databaseHelperProvider
        .readData('SerialNumberStoreTable');

    final List<ScannedDetailsModal> allData = rawData
        .map((row) => ScannedDetailsModal.fromJson(row))
        .toList();

    setState(() {
      _scannedItems.clear();
      _scannedItems.addAll(allData);
    });
  }

  Future<void> _deleteScanned(String serialNumber) async {
    await _databaseHelperProvider.deleteData(
      'SerialNumberStoreTable',
      serialNumber,
    );
    _loadScannedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner Menu')),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CameraScannerScreen(),
                      ),
                    ).then((_) {
                      // Optionally reload scanned data after returning
                      // setState(() { _loadScannedData(); });
                    });
                  },
                  child: Column(
                    children: const [
                      Icon(Icons.qr_code, size: 40),
                      SizedBox(height: 8),
                      Text("Scan QR or Bar", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    try {
                      await imageUploadAndScan(context, ref);
                    } catch (e) {
                      print("Error: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error: $e"),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 5),
                        ),
                      );
                    }
                  },
                  child: Column(
                    children: const [
                      Icon(Icons.image_outlined, size: 40),
                      SizedBox(height: 8),
                      Text("Upload Image", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ],
            ),
            ScannedItemsList(
              key: ValueKey(_scannedItems.length),
              formKey: _formKey,
              scannedList: _scannedItems,
              onDelete: _deleteScanned,
              onDescriptionsChanged: (descriptions) {
                _descriptionsNotifier.value = descriptions;
              },
            ),
          ],
        ),
      ),
    );
  }
}
