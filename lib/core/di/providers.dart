import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../services/dio_client.dart';
import '../../shared/models/vehicle.dart';
import '../../shared/models/fuel_entry.dart';
import '../../shared/models/maintenance.dart';
import '../../shared/models/category_maintenance.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());
final dioClientProvider = Provider<DioClient>((ref) => DioClient());

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

// Vehicles Provider
final vehiclesProvider = StreamProvider<List<Vehicle>>((ref) {
  final service = ref.watch(firestoreServiceProvider);
  return service.streamCollection('vehicles').map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      // Add doc id back for internal referencing
      data['id'] = doc.id;
      // DriverId is implicit in Firestore but we keep it for model compatibility
      data['driver_id'] = 0; 
      return Vehicle.fromMap(data);
    }).toList();
  });
});

// Fuel Entries Provider (filtered by vehicle)
final fuelEntriesProvider = StreamProvider.family<List<FuelEntry>, String>((ref, vehicleId) {
  final service = ref.watch(firestoreServiceProvider);
  return service.streamCollection('fuelEntries').map((snapshot) {
    return snapshot.docs
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return FuelEntry.fromMap(data);
        })
        .where((entry) => entry.vehicleId == vehicleId)
        .toList();
  });
});

// Maintenance Provider
final maintenanceProvider = StreamProvider.family<List<Maintenance>, String>((ref, vehicleId) {
  final service = ref.watch(firestoreServiceProvider);
  return service.streamCollection('maintenances').map((snapshot) {
    return snapshot.docs
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return Maintenance.fromMap(data);
        })
        .where((entry) => entry.vehicleId == vehicleId)
        .toList();
  });
});

// Categories Provider
final categoriesProvider = StreamProvider<List<CategoryMaintenance>>((ref) {
  final service = ref.watch(firestoreServiceProvider);
  return service.streamCollection('categories').map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return CategoryMaintenance.fromMap(data);
    }).toList();
  });
});
