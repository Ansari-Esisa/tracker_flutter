import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/di/providers.dart';
import '../../../shared/models/maintenance.dart';

class AddMaintenanceScreen extends ConsumerStatefulWidget {
  final String vehicleId;
  const AddMaintenanceScreen({super.key, required this.vehicleId});

  @override
  ConsumerState<AddMaintenanceScreen> createState() => _AddMaintenanceScreenState();
}

class _AddMaintenanceScreenState extends ConsumerState<AddMaintenanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();

  Future<void> _save() async {
    if (_formKey.currentState!.validate() && _selectedCategoryId != null) {
      final maintenance = Maintenance(
        vehicleId: widget.vehicleId,
        categoryId: _selectedCategoryId!,
        date: _selectedDate,
        description: _descriptionController.text,
        cost: double.parse(_costController.text),
      );

      final service = ref.read(firestoreServiceProvider);
      await service.addDocument('maintenances', maintenance.toMap());
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Maintenance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              categoriesAsync.when(
                data: (categories) {
                  return DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: categories.map((c) {
                      return DropdownMenuItem(value: c.id, child: Text(c.name));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedCategoryId = val),
                    validator: (v) => v == null ? 'Required' : null,
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, st) => Text('Error loading categories: $e'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(labelText: 'Cost (€)'),
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
