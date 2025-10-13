import 'package:flutter/material.dart';
import '../controllers/area_controller.dart';

class AreaAddDialog extends StatefulWidget {
  final AreaController controller;
  
  const AreaAddDialog({
    super.key,
    required this.controller,
  });

  @override
  State<AreaAddDialog> createState() => _AreaAddDialogState();
}

class _AreaAddDialogState extends State<AreaAddDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Area Baru'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Area *',
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan nama area',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama area harus diisi';
                  }
                  if (value.trim().length < 3) {
                    return 'Nama area minimal 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan deskripsi area (opsional)',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty && value.trim().length < 10) {
                    return 'Deskripsi minimal 10 karakter';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
          ),
          child: const Text('Tambah Area'),
        ),
      ],
    );
  }

  void _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();
      
      final success = await widget.controller.addArea(name, description);
      
      if (mounted) {
        Navigator.pop(context);
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Area berhasil ditambahkan'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menambahkan area'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}