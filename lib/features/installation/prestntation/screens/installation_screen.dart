import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/presentation/widgets/camere_scann_widget.dart';
import '../../../shared/presentation/widgets/image_upload_widget.dart';

class InstallationScreen extends ConsumerWidget {
  const InstallationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner Menu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CameraScannerScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Scan with Camera'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(250, 60)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ImageScannerScreen()),
                );
              },
              icon: const Icon(Icons.image),
              label: const Text('Scan from Image'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(250, 60)),
            ),
          ],
        ),
      ),
    );
  }
}
