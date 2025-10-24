// lib/network_services/riverpod_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/scanned_item_modal.dart';

final scannedItemsProvider =
StateNotifierProvider<ScannedItemsNotifier, List<ScannedItemModal>>(
      (ref) => ScannedItemsNotifier(),
);

class ScannedItemsNotifier extends StateNotifier<List<ScannedItemModal>> {
  ScannedItemsNotifier() : super([]);

  void setItems(List<ScannedItemModal> items) => state = items;

  void addItem(ScannedItemModal item) => state = [...state, item];

  void removeItem(String serialNumber) {
    state = state.where((item) => item.serialNumber != serialNumber).toList();
  }

  void updateDescription(int index, String description) {
    final newList = [...state];
    newList[index] = newList[index].copyWith(productDescription: description);
    state = newList;
  }

  void clearItems() => state = [];
}
