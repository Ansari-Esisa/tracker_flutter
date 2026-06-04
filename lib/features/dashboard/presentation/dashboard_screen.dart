import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../shared/models/vehicle.dart';
import '../../../core/di/providers.dart';

// Providers for filtered data
final driverVehiclesProvider = StreamProvider<List<Vehicle>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  
  return Stream.fromFuture(ref.watch(vehiclesProvider.future)).asyncExpand((vehicles) {
    // In a real app, we'd filter by user.uid
    // For now, returning all vehicles as placeholder logic
    return Stream.value(vehicles);
  });
});

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  DateTimeRange? _selectedDateRange;

  @override
  Widget build(BuildContext context) {
    final vehiclesAsync = ref.watch(driverVehiclesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: _selectedDateRange,
              );
              if (picked != null) {
                setState(() => _selectedDateRange = picked);
              }
            },
          ),
        ],
      ),
      body: vehiclesAsync.when(
        data: (vehicles) {
          if (vehicles.isEmpty) {
            return const Center(child: Text('Aucun véhicule trouvé.'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(driverVehiclesProvider),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildDriverVehicles(vehicles),
                const SizedBox(height: 24),
                _buildExpenseDistribution(),
                const SizedBox(height: 24),
                _buildFuelConsumptionStats(vehicles),
                const SizedBox(height: 24),
                _buildMaintenanceHistory(vehicles),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
    );
  }

  Widget _buildDriverVehicles(List<Vehicle> vehicles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mes Véhicules', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return Card(
                child: Container(
                  width: 160,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${vehicle.make} ${vehicle.model}', 
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(vehicle.plateNumber, style: const TextStyle(color: Colors.grey)),
                      Text('${vehicle.year}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseDistribution() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Dépenses du Mois', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: Colors.blue,
                      value: 70,
                      title: '70%',
                      radius: 50,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      badgeWidget: const Text('Gasoil'),
                      badgePositionPercentageOffset: 1.3,
                    ),
                    PieChartSectionData(
                      color: Colors.orange,
                      value: 30,
                      title: '30%',
                      radius: 50,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      badgeWidget: const Text('Maintenance'),
                      badgePositionPercentageOffset: 1.3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFuelConsumptionStats(List<Vehicle> vehicles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Consommation de Gasoil', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...vehicles.map((v) => _FuelStatCard(vehicle: v)),
      ],
    );
  }

  Widget _buildMaintenanceHistory(List<Vehicle> vehicles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Historique de Maintenance', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...vehicles.map((v) => _MaintenanceList(vehicle: v, range: _selectedDateRange)),
      ],
    );
  }
}

class _FuelStatCard extends ConsumerWidget {
  final Vehicle vehicle;
  const _FuelStatCard({required this.vehicle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fuelAsync = ref.watch(fuelEntriesProvider(vehicle.id!));

    return fuelAsync.when(
      data: (entries) {
        final now = DateTime.now();
        final monthlyEntries = entries.where((e) => e.date.month == now.month && e.date.year == now.year);
        
        double totalLiters = 0;
        double totalCost = 0;
        for (var e in monthlyEntries) {
          totalLiters += e.liters;
          totalCost += e.totalCost;
        }

        return Card(
          child: ListTile(
            title: Text('${vehicle.make} ${vehicle.model}'),
            subtitle: Text('${totalLiters.toStringAsFixed(1)} L | ${totalCost.toStringAsFixed(2)} €'),
            trailing: const Icon(Icons.local_gas_station, color: Colors.blue),
          ),
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text('Erreur: $e'),
    );
  }
}

class _MaintenanceList extends ConsumerWidget {
  final Vehicle vehicle;
  final DateTimeRange? range;
  const _MaintenanceList({required this.vehicle, this.range});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maintenanceAsync = ref.watch(maintenanceProvider(vehicle.id!));

    return maintenanceAsync.when(
      data: (maintenances) {
        var filtered = maintenances;
        if (range != null) {
          filtered = maintenances.where((m) => 
            m.date.isAfter(range!.start.subtract(const Duration(days: 1))) && 
            m.date.isBefore(range!.end.add(const Duration(days: 1)))
          ).toList();
        }

        if (filtered.isEmpty) return const SizedBox.shrink();

        return ExpansionTile(
          title: Text('Maintenance: ${vehicle.make} ${vehicle.model}'),
          children: filtered.map((m) => ListTile(
            leading: const Icon(Icons.build, size: 20),
            title: Text(m.description),
            subtitle: Text(DateFormat('dd/MM/yyyy').format(m.date)),
            trailing: Text('${m.cost.toStringAsFixed(2)} €', style: const TextStyle(fontWeight: FontWeight.bold)),
          )).toList(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}
