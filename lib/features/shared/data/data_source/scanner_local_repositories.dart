import 'package:inventorymanagement/features/shared/data/models/scanned_details_modal.dart';

import '../../../../core/utils/local_storage/sqlite_manager/database_helper.dart';

class ScannerLocalDataSource {
  final DatabaseHelper _databaseHelper;
  static const String _tableName = 'SerialNumberStoreTable';

  ScannerLocalDataSource({DatabaseHelper? databaseHelper})
    : _databaseHelper = databaseHelper ?? DatabaseHelper();

  Future<Set<String>> getExistingSerialNumbers() async {
    try {
      final List<Map<String, dynamic>> records = await _databaseHelper.readData(
        _tableName,
      );

      return records
          .map((record) => record['serialNumber'] as String?)
          .where((serialNumber) => serialNumber != null)
          .cast<String>()
          .toSet();
    } catch (e) {
      throw Exception('Error reading serial numbers: $e');
    }
  }

  Future<String> saveItems(List<ScannedDetailsModal> items) async {
    try {
      final dataList = items.map((item) => item.toJson()).toList();
      final response = await _databaseHelper.insertDataList(
        _tableName,
        dataList,
      );
      return response;
    } catch (e) {
      throw Exception('Error saving to database: $e');
    }
  }

  Future<bool> checkDuplicateExists(String serialNumber) async {
    try {
      final List<Map<String, dynamic>> rawData = await _databaseHelper.readData(
        _tableName,
      );
      return rawData.any((row) => row['serialNumber'] == serialNumber);
    } catch (e) {
      throw Exception('Error checking duplicate: $e');
    }
  }
}
