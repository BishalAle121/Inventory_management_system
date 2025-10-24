
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavNotifier extends StateNotifier<int> {
  BottomNavNotifier() : super(0);

  void setIndex(int idx) => state = idx;
}

final bottomNavProvider = StateNotifierProvider<BottomNavNotifier, int>(
  (ref) => BottomNavNotifier(),
);