class Maintenance {
  final String? id;
  final String vehicleId;
  final String categoryId;
  final DateTime date;
  final String description;
  final double cost;

  Maintenance({
    this.id,
    required this.vehicleId,
    required this.categoryId,
    required this.date,
    required this.description,
    required this.cost,
  });

  Map<String, dynamic> toMap() {
    return {
      'vehicle_id': vehicleId,
      'category_id': categoryId,
      'date': date.toIso8601String(),
      'description': description,
      'cost': cost,
    };
  }

  factory Maintenance.fromMap(Map<String, dynamic> map) {
    return Maintenance(
      id: map['id'],
      vehicleId: map['vehicle_id'],
      categoryId: map['category_id'],
      date: DateTime.parse(map['date']),
      description: map['description'],
      cost: (map['cost'] as num).toDouble(),
    );
  }
}
