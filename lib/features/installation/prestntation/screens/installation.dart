import 'package:flutter/material.dart';

import '../widgets/installation_widget.dart';

class Installation extends StatefulWidget {
  const Installation({super.key});

  @override
  State<Installation> createState() => _InstallationState();
}

class _InstallationState extends State<Installation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Installation'),
      ),
      body: const Center(
        child: HomeScreenWidget(),
      ),
    );
  }
}
