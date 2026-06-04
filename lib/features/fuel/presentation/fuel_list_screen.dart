import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/providers.dart';

class FuelListScreen extends ConsumerWidget {
  final String vehicleId;
  const FuelListScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fuelEntriesAsync = ref.watch(fuelEntriesProvider(vehicleId));

    return Scaffold(
      appBar: AppBar(title: const Text('Fuel History')),
      body: fuelEntriesAsync.when(
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(child: Text('No fuel entries found.'));
          }
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return ListTile(
                leading: const Icon(Icons.local_gas_station, color: Colors.green),
                title: Text('${entry.liters.toStringAsFixed(2)} L | ${entry.totalCost.toStringAsFixed(2)} €'),
                subtitle: Text('${DateFormat('yyyy-MM-dd').format(entry.date)} | ${entry.mileage.toStringAsFixed(0)} km'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/vehicles/$vehicleId/fuel/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
