import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/providers.dart';

class MaintenanceListScreen extends ConsumerWidget {
  final String vehicleId;
  const MaintenanceListScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maintenanceAsync = ref.watch(maintenanceProvider(vehicleId));
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance History')),
      body: maintenanceAsync.when(
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(child: Text('No maintenance records found.'));
          }
          return categoriesAsync.when(
            data: (categories) {
              return ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  final category = categories.firstWhere(
                    (c) => c.id == entry.categoryId,
                    orElse: () => throw Exception('Category not found'),
                  );

                  return ListTile(
                    leading: const Icon(Icons.build, color: Colors.blue),
                    title: Text('${category.name}: ${entry.cost.toStringAsFixed(2)} €'),
                    subtitle: Text('${DateFormat('yyyy-MM-dd').format(entry.date)}\n${entry.description}'),
                    isThreeLine: true,
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error loading categories: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/vehicles/$vehicleId/maintenance/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
