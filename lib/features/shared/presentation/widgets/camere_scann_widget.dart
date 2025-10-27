import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../shared/application/state/camera_scanner_state.dart';
import '../../../shared/domain/entities/scanned_details.dart';
import '../../application/provider/camera_scann_provider.dart';

class CameraScannerScreen extends ConsumerStatefulWidget {
  const CameraScannerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CameraScannerScreen> createState() =>
      _CameraScannerScreenState();
}

class _CameraScannerScreenState extends ConsumerState<CameraScannerScreen> {
  late MobileScannerController _controller;
  final Set<String> _alreadyScannedCodes = {};
  final List<ScannedDetails> scannedList = [];

  bool _isTorchOn = false;
  final double _scanBoxSize = 390.0;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.unrestricted,
      facing: CameraFacing.back,
      torchEnabled: false,
      formats: [BarcodeFormat.all],
      detectionTimeoutMs: 500,
    );
  }

  void _toggleTorch() {
    _controller.toggleTorch();
    setState(() {
      _isTorchOn = !_isTorchOn;
    });
  }

  void _onBarcodeDetected(BarcodeCapture capture, BoxConstraints constraints) {
    final notifier = ref.read(cameraScannerProvider.notifier);
    notifier.processCameraBarcodes(
      capture,
      _alreadyScannedCodes,
      Size(constraints.maxWidth, constraints.maxHeight),
      _scanBoxSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cameraScannerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Scanner'),
        actions: [
          IconButton(
            icon: Icon(_isTorchOn ? Icons.flash_on : Icons.flash_off),
            onPressed: _toggleTorch,
            color: _isTorchOn ? Colors.yellow : Colors.grey,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              MobileScanner(
                controller: _controller,
                fit: BoxFit.cover,
                onDetect: (capture) => _onBarcodeDetected(capture, constraints),
                errorBuilder: (context, error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      Text(error.errorDetails?.message ?? 'Unknown error'),
                      ElevatedButton(
                        onPressed: () => _controller.start(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              _buildScanAreaOverlay(constraints),
              _buildScannedList(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScanAreaOverlay(BoxConstraints constraints) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipPath(
            clipper: _ScanAreaClipper(_scanBoxSize),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
          ),
        ),
        Positioned(
          top:
              (constraints.maxHeight - _scanBoxSize) / 2 -
              constraints.maxHeight * 0.2,
          left: (constraints.maxWidth - _scanBoxSize) / 2,
          child: Container(
            width: _scanBoxSize,
            height: _scanBoxSize,
            color: Colors.transparent,
            child: CustomPaint(painter: _CornerPainter()),
          ),
        ),
      ],
    );
  }

  Widget _buildScannedList(CameraScannerState state) {
    if (state is CameraScannerData) {
      final items = state.scannedItems;
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        height: 200,
        width: 400,
        child: Container(
          color: Colors.black54,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, index) {
              final item = items[index];
              return ListTile(
                title: Text(
                  item.serialNumber,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => ref
                      .read(cameraScannerProvider.notifier)
                      .deleteItem(item, state.scannedCodes),
                ),
              );
            },
          ),
        ),
      );
    }

    if (state is CameraScannerLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is CameraScannerError) {
      return Center(child: Text('Error: ${state.message}'));
    }

    return const SizedBox.shrink();
  }
}

/// Clipper to blur outside scan box
class _ScanAreaClipper extends CustomClipper<Path> {
  final double size;
  _ScanAreaClipper(this.size);

  @override
  Path getClip(Size screenSize) {
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, screenSize.width, screenSize.height));
    final rect = Rect.fromLTWH(
      (screenSize.width - size) / 2,
      (screenSize.height - size) / 2 - screenSize.height * 0.2,
      size,
      size,
    );
    path.addRect(rect);
    return Path.combine(PathOperation.difference, path, Path()..addRect(rect));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Draw blue corners
class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const corner = 20.0;

    // Top-left
    canvas.drawLine(Offset(0, 0), Offset(corner, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, corner), paint);

    // Top-right
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - corner, 0),
      paint,
    );
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, corner), paint);

    // Bottom-left
    canvas.drawLine(Offset(0, size.height), Offset(corner, size.height), paint);
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - corner),
      paint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - corner, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - corner),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
