import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/fuel_entry.dart';

// Mock Data for Demo
final mockFuelEntries = [
  FuelEntry(id: 'f1', vehicleId: 'v1', date: DateTime.now().subtract(const Duration(days: 1)), liters: 25.0, totalCost: 250.0, mileage: 120500.0),
  FuelEntry(id: 'f2', vehicleId: 'v1', date: DateTime.now().subtract(const Duration(days: 15)), liters: 20.0, totalCost: 200.0, mileage: 120000.0),
  FuelEntry(id: 'f3', vehicleId: 'v2', date: DateTime.now().subtract(const Duration(days: 5)), liters: 45.0, totalCost: 450.0, mileage: 45000.0),
];

class FuelListScreen extends ConsumerWidget {
  final String vehicleId;
  const FuelListScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Filter mock data by vehicleId for demo
    final entries = mockFuelEntries.where((e) => e.vehicleId == vehicleId).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Fuel History (Demo Mode)')),
      body: entries.isEmpty
          ? const Center(child: Text('No fuel entries found.'))
          : ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return ListTile(
                  leading: const Icon(Icons.local_gas_station, color: Colors.green),
                  title: Text('${entry.liters.toStringAsFixed(2)} L | ${entry.totalCost.toStringAsFixed(2)} MAD'),
                  subtitle: Text('${DateFormat('yyyy-MM-dd').format(entry.date)} | ${entry.mileage.toStringAsFixed(0)} km'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/vehicles/$vehicleId/fuel/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
