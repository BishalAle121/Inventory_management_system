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
