class Vehicle {
  final String? id;
  final String? driverId;
  final String make;
  final String model;
  final String plateNumber;
  final int year;

  Vehicle({
    this.id,
    this.driverId,
    required this.make,
    required this.model,
    required this.plateNumber,
    required this.year,
  });

  Map<String, dynamic> toMap() {
    return {
      'make': make,
      'model': model,
      'plate_number': plateNumber,
      'year': year,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'],
      driverId: map['driver_id']?.toString(),
      make: map['make'],
      model: map['model'],
      plateNumber: map['plate_number'],
      year: map['year'],
    );
  }
}
