import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/component_serialnumber_discription_photo.dart';
import '../../data/models/scanned_details_modal.dart';
import '../../providers/serial_and_description_provider.dart';

class ScannedItemsList extends ConsumerStatefulWidget {
  final List<ScannedDetailsModal> scannedList;
  final Function(String) onDelete;
  final GlobalKey<FormState> formKey;
  final Function(List<String>)? onDescriptionsChanged;

  const ScannedItemsList({
    super.key,
    required this.scannedList,
    required this.onDelete,
    required this.formKey,
    this.onDescriptionsChanged,
  });

  @override
  ConsumerState<ScannedItemsList> createState() => _ScannedItemsListState();
}

class _ScannedItemsListState extends ConsumerState<ScannedItemsList> {
  final Map<int, TextEditingController> _serialControllers = {};
  final Map<int, TextEditingController> _descriptionControllers = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(ScannedItemsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scannedList.length != oldWidget.scannedList.length) {
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    // Dispose old controllers that are no longer needed
    final Set<int> currentIndices = Set.from(
      List.generate(widget.scannedList.length, (i) => i),
    );

    _serialControllers.keys.toList().forEach((index) {
      if (!currentIndices.contains(index)) {
        _serialControllers[index]?.dispose();
        _serialControllers.remove(index);
      }
    });

    _descriptionControllers.keys.toList().forEach((index) {
      if (!currentIndices.contains(index)) {
        _descriptionControllers[index]?.removeListener(
          _notifyDescriptionsChanged,
        );
        _descriptionControllers[index]?.dispose();
        _descriptionControllers.remove(index);
      }
    });

    // Create or update controllers for each item
    for (int i = 0; i < widget.scannedList.length; i++) {
      // Initialize serial controller with the scanned serial number
      if (!_serialControllers.containsKey(i)) {
        _serialControllers[i] = TextEditingController(
          text: widget.scannedList[i].serialNumber,
        );
      } else if (_serialControllers[i]!.text !=
          widget.scannedList[i].serialNumber) {
        _serialControllers[i]!.text = widget.scannedList[i].serialNumber;
      }

      // Initialize description controller
      if (!_descriptionControllers.containsKey(i)) {
        final controller = TextEditingController();
        controller.addListener(_notifyDescriptionsChanged);
        _descriptionControllers[i] = controller;
      }
    }

    _notifyDescriptionsChanged();
  }

  void _notifyDescriptionsChanged() {
    if (widget.onDescriptionsChanged != null) {
      final descriptions = List.generate(
        widget.scannedList.length,
        (i) => _descriptionControllers[i]?.text.trim() ?? '',
      );
      widget.onDescriptionsChanged!(descriptions);
    }
  }

  @override
  void dispose() {
    for (var controller in _serialControllers.values) {
      controller.dispose();
    }
    for (var controller in _descriptionControllers.values) {
      controller.removeListener(_notifyDescriptionsChanged);
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.scannedList.isEmpty) {
      return const Center(child: Text("No Scanned Data found"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: widget.scannedList.length,
      itemBuilder: (context, index) {
        return ComponentSerialnumberDiscriptionPhoto(
          serialController: _serialControllers[index]!,
          descriptionController: _descriptionControllers[index]!,
          onDelete: () =>
              widget.onDelete(widget.scannedList[index].serialNumber),
          serialValidator: (value) => value == null || value.isEmpty
              ? 'Serial number cannot be empty'
              : null,
          descriptionValidator: (value) => value == null || value.isEmpty
              ? 'Description cannot be empty'
              : null,
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../components/component_serialnumber_discription_photo.dart';
// import '../../data/models/scanned_details_modal.dart';
// import '../../providers/serial_and_description_provider.dart';
//
// class ScannedItemsList extends ConsumerWidget {
//   final List<ScannedDetailsModal> scannedList;
//   final Function(String) onDelete;
//   final GlobalKey<FormState> formKey;
//   final Function(List<String>)? onDescriptionsChanged;
//
//   const ScannedItemsList({
//     super.key,
//     required this.scannedList,
//     required this.onDelete,
//     required this.formKey,
//     this.onDescriptionsChanged,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     if (scannedList.isEmpty) {
//       return const Center(child: Text("No Scanned Data found"));
//     }
//
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const ClampingScrollPhysics(),
//       itemCount: scannedList.length,
//       itemBuilder: (context, index) {
//         final serialController = ref.watch(serialControllerProvider(index));
//         final descriptionController = ref.watch(
//           descriptionControllerProvider(index),
//         );
//
//         // Notify parent when description changes
//         descriptionController.addListener(() {
//           if (onDescriptionsChanged != null) {
//             final allDescriptions = List.generate(
//               scannedList.length,
//               (i) => ref.read(descriptionControllerProvider(i)).text.trim(),
//             );
//             onDescriptionsChanged!(allDescriptions);
//           }
//         });
//
//         return ComponentSerialnumberDiscriptionPhoto(
//           serialController: serialController,
//           descriptionController: descriptionController,
//           onDelete: () => onDelete(scannedList[index].serialNumber),
//           serialValidator: (value) => value == null || value.isEmpty
//               ? 'Serial number cannot be empty'
//               : null,
//           descriptionValidator: (value) => value == null || value.isEmpty
//               ? 'Description cannot be empty'
//               : null,
//         );
//       },
//     );
//   }
// }
