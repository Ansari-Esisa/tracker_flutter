import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../shared/models/vehicle.dart';
import '../../../shared/models/maintenance.dart';

// Mock Data for Demo
final mockVehicles = [
  Vehicle(id: 'v1', make: 'Toyota', model: 'Corolla', plateNumber: '12345|A|1', year: 2020),
  Vehicle(id: 'v2', make: 'Dacia', model: 'Duster', plateNumber: '67890|B|2', year: 2022),
];

final mockMaintenances = [
  Maintenance(id: 'm1', vehicleId: 'v1', categoryId: 'cat1', date: DateTime.now().subtract(const Duration(days: 2)), description: 'Vidange moteur', cost: 150.0),
  Maintenance(id: 'm2', vehicleId: 'v1', categoryId: 'cat2', date: DateTime.now().subtract(const Duration(days: 10)), description: 'Remplacement filtre', cost: 50.0),
  Maintenance(id: 'm3', vehicleId: 'v2', categoryId: 'cat1', date: DateTime.now().subtract(const Duration(days: 5)), description: 'Révision générale', cost: 100.0),
];

// Mocked Providers for Demo
final driverVehiclesProvider = Provider<List<Vehicle>>((ref) => mockVehicles);

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  DateTimeRange? _selectedDateRange;

  @override
  Widget build(BuildContext context) {
    final vehicles = ref.watch(driverVehiclesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard (Demo Mode)'),
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
      body: RefreshIndicator(
        onRefresh: () async => {},
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
            Text('Dépenses du Mois (1000 MAD)', style: Theme.of(context).textTheme.titleMedium),
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
                      value: 700,
                      title: '700 MAD',
                      radius: 50,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      badgeWidget: const Text('Gasoil (70%)'),
                      badgePositionPercentageOffset: 1.4,
                    ),
                    PieChartSectionData(
                      color: Colors.orange,
                      value: 300,
                      title: '300 MAD',
                      radius: 50,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      badgeWidget: const Text('Maint. (30%)'),
                      badgePositionPercentageOffset: 1.4,
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
        ...vehicles.map((v) => Card(
          child: ListTile(
            title: Text('${v.make} ${v.model}'),
            subtitle: const Text('45.0 L | 450.00 MAD'),
            trailing: const Icon(Icons.local_gas_station, color: Colors.blue),
          ),
        )),
      ],
    );
  }

  Widget _buildMaintenanceHistory(List<Vehicle> vehicles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Historique de Maintenance', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...vehicles.map((v) {
          final filtered = mockMaintenances.where((m) => m.vehicleId == v.id).toList();
          return ExpansionTile(
            title: Text('Maintenance: ${v.make} ${v.model}'),
            children: filtered.map((m) => ListTile(
              leading: const Icon(Icons.build, size: 20),
              title: Text(m.description),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(m.date)),
              trailing: Text('${m.cost.toStringAsFixed(2)} MAD', style: const TextStyle(fontWeight: FontWeight.bold)),
            )).toList(),
          );
        }),
      ],
    );
  }
}
