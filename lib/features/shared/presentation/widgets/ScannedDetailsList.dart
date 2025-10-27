import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/component_serialnumber_discription_photo.dart';
import '../../data/models/scanned_details_modal.dart';
import '../../providers/serial_and_description_provider.dart';

class ScannedItemsList extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    if (scannedList.isEmpty) {
      return const Center(child: Text("No Scanned Data found"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: scannedList.length,
      itemBuilder: (context, index) {
        final serialController = ref.watch(serialControllerProvider(index));
        final descriptionController = ref.watch(
          descriptionControllerProvider(index),
        );

        // Notify parent when description changes
        descriptionController.addListener(() {
          if (onDescriptionsChanged != null) {
            final allDescriptions = List.generate(
              scannedList.length,
              (i) => ref.read(descriptionControllerProvider(i)).text.trim(),
            );
            onDescriptionsChanged!(allDescriptions);
          }
        });

        return ComponentSerialnumberDiscriptionPhoto(
          serialController: serialController,
          descriptionController: descriptionController,
          onDelete: () => onDelete(scannedList[index].serialNumber),
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
