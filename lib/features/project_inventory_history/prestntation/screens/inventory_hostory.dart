import 'package:flutter/material.dart';

class InventoryHistory extends StatefulWidget {
  const InventoryHistory({super.key});

  @override
  State<InventoryHistory> createState() => _InventoryHistoryState();
}

class _InventoryHistoryState extends State<InventoryHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Installation History'),
      ),
      body: const Center(
        child: Text('Installation HistoryContent'),
      ),
    );
  }
}
