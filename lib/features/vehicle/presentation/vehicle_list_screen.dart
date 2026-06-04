import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/vehicle.dart';

// Mock Data for Demo
final mockVehicles = [
  Vehicle(id: 'v1', make: 'Toyota', model: 'Corolla', plateNumber: '12345|A|1', year: 2020),
  Vehicle(id: 'v2', make: 'Dacia', model: 'Duster', plateNumber: '67890|B|2', year: 2022),
];

class VehicleListScreen extends ConsumerWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Using mock data directly for demo
    final vehicles = mockVehicles;

    return Scaffold(
      appBar: AppBar(title: const Text('My Vehicles (Demo Mode)')),
      body: vehicles.isEmpty
          ? const Center(child: Text('No vehicles found. Add your first one!'))
          : ListView.builder(
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
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/vehicles/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
