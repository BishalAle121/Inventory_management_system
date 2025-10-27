import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final serialControllerProvider = Provider.family
    .autoDispose<TextEditingController, int>((ref, index) {
      final controller = TextEditingController();
      ref.onDispose(() => controller.dispose());
      return controller;
    });

final descriptionControllerProvider = Provider.family
    .autoDispose<TextEditingController, int>((ref, index) {
      final controller = TextEditingController();
      ref.onDispose(() => controller.dispose());
      return controller;
    });
