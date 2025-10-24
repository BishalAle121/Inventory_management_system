// lib/home_screen/scanned_items_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/components/component_serialnumber_discription_photo.dart';
import '../../../shared/providers/serial_and_description_provider.dart';


class ScannedItemsList extends ConsumerWidget {
  final void Function(String) onDelete;

  const ScannedItemsList({Key? key, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scannedList = ref.watch(scannedItemsProvider);

    if (scannedList.isEmpty) {
      return const Center(child: Text("No Scanned Data found"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: scannedList.length,
      itemBuilder: (context, index) {
        final item = scannedList[index];
        final serialController = TextEditingController(text: item.serialNumber);
        final descController =
        TextEditingController(text: item.productDescription ?? "");

        descController.addListener(() {
          ref.read(scannedItemsProvider.notifier).updateDescription(index, descController.text);
        });

        return ComponentSerialnumberDiscriptionPhoto(
          showDelete: true,
          serialController: serialController,
          descriptionController: descController,
          onDelete: () {
            ref.read(scannedItemsProvider.notifier).removeItem(item.serialNumber);onDelete(item.serialNumber);
          },
          serialValidator: (_) =>
          serialController.text.trim().isEmpty ? "Serial cannot be empty" : null,
          descriptionValidator: (_) =>
          descController.text.trim().isEmpty ? "Description cannot be empty" : null,
        );
      },
    );
  }
}
