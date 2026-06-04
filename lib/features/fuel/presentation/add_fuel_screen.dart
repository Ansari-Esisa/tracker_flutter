import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/di/providers.dart';
import '../../../shared/models/fuel_entry.dart';

class AddFuelScreen extends ConsumerStatefulWidget {
  final String vehicleId;
  const AddFuelScreen({super.key, required this.vehicleId});

  @override
  ConsumerState<AddFuelScreen> createState() => _AddFuelScreenState();
}

class _AddFuelScreenState extends ConsumerState<AddFuelScreen> {
  final _formKey = GlobalKey<FormState>();
  final _litersController = TextEditingController();
  final _totalCostController = TextEditingController();
  final _mileageController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final entry = FuelEntry(
        vehicleId: widget.vehicleId,
        date: _selectedDate,
        liters: double.parse(_litersController.text),
        totalCost: double.parse(_totalCostController.text),
        mileage: double.parse(_mileageController.text),
      );

      final service = ref.read(firestoreServiceProvider);
      await service.addDocument('fuelEntries', entry.toMap());
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Fuel Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _litersController,
                decoration: const InputDecoration(labelText: 'Liters'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _totalCostController,
                decoration: const InputDecoration(labelText: 'Total Cost (€)'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _mileageController,
                decoration: const InputDecoration(labelText: 'Mileage (km)'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              ListTile(
                title: Text('Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
