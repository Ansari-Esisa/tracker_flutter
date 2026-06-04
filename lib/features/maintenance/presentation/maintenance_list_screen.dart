import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/maintenance.dart';
import '../../../shared/models/category_maintenance.dart';

// Mock Data for Demo
final mockMaintenances = [
  Maintenance(id: 'm1', vehicleId: 'v1', categoryId: 'cat1', date: DateTime.now().subtract(const Duration(days: 2)), description: 'Vidange moteur', cost: 150.0),
  Maintenance(id: 'm2', vehicleId: 'v1', categoryId: 'cat2', date: DateTime.now().subtract(const Duration(days: 10)), description: 'Remplacement filtre', cost: 50.0),
  Maintenance(id: 'm3', vehicleId: 'v2', categoryId: 'cat1', date: DateTime.now().subtract(const Duration(days: 5)), description: 'Révision générale', cost: 100.0),
];

final mockCategories = [
  CategoryMaintenance(id: 'cat1', name: 'Moteur'),
  CategoryMaintenance(id: 'cat2', name: 'Filtres'),
];

class MaintenanceListScreen extends ConsumerWidget {
  final String vehicleId;
  const MaintenanceListScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Filter mock data by vehicleId for demo
    final entries = mockMaintenances.where((m) => m.vehicleId == vehicleId).toList();
    final categories = mockCategories;

    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance History (Demo Mode)')),
      body: entries.isEmpty
          ? const Center(child: Text('No maintenance records found.'))
          : ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                final category = categories.firstWhere(
                  (c) => c.id == entry.categoryId,
                  orElse: () => CategoryMaintenance(id: 'unknown', name: 'Inconnu'),
                );

                return ListTile(
                  leading: const Icon(Icons.build, color: Colors.blue),
                  title: Text('${category.name}: ${entry.cost.toStringAsFixed(2)} MAD'),
                  subtitle: Text('${DateFormat('yyyy-MM-dd').format(entry.date)}\n${entry.description}'),
                  isThreeLine: true,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/vehicles/$vehicleId/maintenance/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
