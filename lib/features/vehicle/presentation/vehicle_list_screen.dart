import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/providers.dart';

class VehicleListScreen extends ConsumerWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Vehicles')),
      body: vehiclesAsync.when(
        data: (vehicles) {
          if (vehicles.isEmpty) {
            return const Center(child: Text('No vehicles found. Add your first one!'));
          }
          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.directions_car, size: 40),
                  title: Text('${vehicle.make} ${vehicle.model}'),
                  subtitle: Text('Plate: ${vehicle.plateNumber} | Year: ${vehicle.year}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.local_gas_station, color: Colors.green),
                        onPressed: () => context.push('/vehicles/${vehicle.id}/fuel'),
                        tooltip: 'Fuel History',
                      ),
                      IconButton(
                        icon: const Icon(Icons.build, color: Colors.blue),
                        onPressed: () => context.push('/vehicles/${vehicle.id}/maintenance'),
                        tooltip: 'Maintenance History',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/vehicles/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
