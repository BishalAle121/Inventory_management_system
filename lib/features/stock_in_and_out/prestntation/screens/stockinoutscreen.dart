import 'package:flutter/material.dart';

class StockInOutScreen extends StatefulWidget {
  const StockInOutScreen({super.key});

  @override
  State<StockInOutScreen> createState() => _StockInOutScreenState();
}

class _StockInOutScreenState extends State<StockInOutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock In and Out'),
      ),
      body: const Center(
        child: Text('Stock In and Out Screen Content'),
      ),
    );
  }
}
