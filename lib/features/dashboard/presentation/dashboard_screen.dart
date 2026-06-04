import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// We will implement specific dashboard providers later
final dashboardStatsProvider = Provider((ref) {
  // Mock or placeholder for now
  return {
    'totalExpenses': 0.0,
  };
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text('Total Expenses', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text('${stats['totalExpenses']?.toStringAsFixed(2)} €', 
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(child: Text('More stats coming soon with Riverpod!')),
        ],
      ),
    );
  }
}
