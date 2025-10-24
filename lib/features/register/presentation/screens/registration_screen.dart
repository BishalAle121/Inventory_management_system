import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/registration_form.dart';

class RegistrationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center( // Centers content both vertically and horizontally
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400), // Optional: set max width
            child: RegistrationForm(),
          ),
        ),
      ),
    );
  }
}
