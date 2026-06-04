class FuelEntry {
  final String? id;
  final String vehicleId;
  final DateTime date;
  final double liters;
  final double totalCost;
  final double mileage;

  FuelEntry({
    this.id,
    required this.vehicleId,
    required this.date,
    required this.liters,
    required this.totalCost,
    required this.mileage,
  });

  Map<String, dynamic> toMap() {
    return {
      'vehicle_id': vehicleId,
      'date': date.toIso8601String(),
      'liters': liters,
      'total_cost': totalCost,
      'mileage': mileage,
    };
  }

  factory FuelEntry.fromMap(Map<String, dynamic> map) {
    return FuelEntry(
      id: map['id'],
      vehicleId: map['vehicle_id'],
      date: DateTime.parse(map['date']),
      liters: (map['liters'] as num).toDouble(),
      totalCost: (map['total_cost'] as num).toDouble(),
      mileage: (map['mileage'] as num).toDouble(),
    );
  }
}
