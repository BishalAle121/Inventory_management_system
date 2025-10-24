
import 'package:flutter_riverpod/flutter_riverpod.dart';


final repositoryProvider = Provider<GoogleSheetsService>((ref) {
  return GoogleSheetsService();
});

final vendorProvider =
    FutureProvider<List<VendorModel>>((ref) async {
      final repository = ref.read(repositoryProvider);
      return await repository.fetchAllVendor();
    });

final projectProvider = FutureProvider.family<List<ProjectModel>, int>((ref, vendorId) async {
  final repository = ref.read(repositoryProvider);
  return await repository.fetchAllSpecificProjectName(vendorId);
});


// Separate selected states
final selectedVendorProvider = StateProvider<VendorModel?>(
  (ref) => null,
);
final selectedProjectProvider = StateProvider<ProjectModel?>(
  (ref) => null,
);
