import 'package:flutter/material.dart';
import '../controllers/area_controller.dart';
import '../../../../../../shared/widgets/custom_snackbar.dart';

class TambahAreaDialog extends StatefulWidget {
  final AreaController controller;
  final Area? area;

  const TambahAreaDialog({super.key, required this.controller, this.area});

  @override
  State<TambahAreaDialog> createState() => _TambahAreaDialogState();
}

class _TambahAreaDialogState extends State<TambahAreaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _namaAreaController = TextEditingController();
  final _nomorRuanganController = TextEditingController();
  final _keteranganController = TextEditingController();

  String? _selectedLantai;
  final List<String> _lantaiOptions = ['1', '2'];

  final List<String> _kebersihanList = [];

  @override
  void initState() {
    super.initState();
    if (widget.area != null) {
      _namaAreaController.text = widget.area!.name;
      _selectedLantai = widget.area!.lantai;
      _nomorRuanganController.text = widget.area!.nomorRuangan;
      _kebersihanList.addAll(widget.area!.kebersihan);
      _keteranganController.text = widget.area!.keterangan;
    }
  }

  @override
  void dispose() {
    _namaAreaController.dispose();
    _nomorRuanganController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.area == null ? 'Tambah Area Baru' : 'Edit Area',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.close, color: Colors.black54, size: 24),
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Area
                      const Text(
                        'Nama Area',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _namaAreaController,
                        decoration: InputDecoration(
                          hintText: 'Masukan Nama Lengkap',
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama area tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Lantai dan No. Ruangan
                      Row(
                        children: [
                          // Lantai
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Lantai',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: _selectedLantai,
                                  hint: Text('Pilih Lantai', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                  items: _lantaiOptions.map((String lantai) {
                                    return DropdownMenuItem<String>(value: lantai, child: Text(lantai));
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedLantai = newValue;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Pilih lantai';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),

                          // No. Ruangan
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'No. Ruangan',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _nomorRuanganController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Pilih Nomor',
                                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Nomor tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Kebersihan yang dikerjakan
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Kebersihan yang dikerjakan',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                          ),
                          GestureDetector(
                            onTap: _addKebersihanItem,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                              child: const Icon(Icons.add, color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // List Kebersihan
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _kebersihanList.isEmpty
                            ? Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Icon(Icons.cleaning_services_outlined, size: 48, color: Colors.grey[400]),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Belum ada item kebersihan',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Klik tombol + untuk menambah item',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: List.generate(_kebersihanList.length, (index) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      border: index < _kebersihanList.length - 1
                                          ? Border(bottom: BorderSide(color: Colors.grey[200]!))
                                          : null,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF4CAF50),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            _kebersihanList[index],
                                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => _removeKebersihanItem(index),
                                          child: const Icon(Icons.close, color: Colors.red, size: 20),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                      ),
                      const SizedBox(height: 16),

                      // Keterangan
                      const Text(
                        'Keterangan',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _keteranganController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Tulis Keterangan...',
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(
                            widget.area == null ? 'Tambah Area' : 'Simpan Area',
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addKebersihanItem() {
    showDialog(
      context: context,
      builder: (context) {
        String newItem = '';
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.7), // Dark overlay
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: double.maxFinite,
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white, // Background dialog
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.cleaning_services, color: Color(0xFF4CAF50)),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Tambah Item Kebersihan',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(32, 32)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Input Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Aktivitas Kebersihan',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: (value) {
                        newItem = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Contoh: Kuras Ember, Pel Lantai, dll...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      autofocus: true,
                      maxLines: 2,
                      minLines: 1,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (newItem.trim().isNotEmpty) {
                            setState(() {
                              _kebersihanList.add(newItem.trim());
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        child: const Text('Tambah', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeKebersihanItem(int index) {
    setState(() {
      _kebersihanList.removeAt(index);
    });
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      bool success;

      if (widget.area == null) {
        success = await widget.controller.addArea(
          _namaAreaController.text.trim(),
          _selectedLantai!,
          _nomorRuanganController.text.trim(),
          List.from(_kebersihanList),
          _keteranganController.text.trim(),
        );
      } else {
        success = await widget.controller.updateArea(
          widget.area!.id,
          _namaAreaController.text.trim(),
          _selectedLantai!,
          _nomorRuanganController.text.trim(),
          List.from(_kebersihanList),
          _keteranganController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.of(context).pop();

        if (success) {
          CustomSnackbar.showSuccess(
            title: 'Berhasil',
            message: 'Area berhasil ${widget.area == null ? 'ditambahkan' : 'diupdate'}!',
          );
        } else {
          CustomSnackbar.showError(title: 'Error', message: 'Gagal memproses area');
        }
      }
    }
  }
}
