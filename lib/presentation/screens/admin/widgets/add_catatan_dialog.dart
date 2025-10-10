import 'package:flutter/material.dart';
import '../../../../data/models/report_model.dart';

class AddCatatanDialog extends StatefulWidget {
  final Report report;

  const AddCatatanDialog({super.key, required this.report});

  static void show(BuildContext context, Report report) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AddCatatanDialog(report: report),
    );
  }

  @override
  State<AddCatatanDialog> createState() => _AddCatatanDialogState();
}

class _AddCatatanDialogState extends State<AddCatatanDialog> {
  final TextEditingController _catatanAdminController = TextEditingController();
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    // Pre-fill if admin note already exists
    if (widget.report.catatanAdmin != null) {
      _catatanAdminController.text = widget.report.catatanAdmin!;
    }
  }

  @override
  void dispose() {
    _catatanAdminController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info laporan
                      _buildReportInfo(),

                      const SizedBox(height: 20),

                      // Foto Bukti
                      _buildFotoBukti(),

                      const SizedBox(height: 20),

                      // Kebersihan yang dikerjakan
                      _buildTasksList(),

                      const SizedBox(height: 20),

                      // Catatan Petugas
                      _buildCatatanPetugas(),

                      const SizedBox(height: 20),

                      // Penilaian Kualitas Kerja
                      _buildPenilaianKualitas(),

                      const SizedBox(height: 20),

                      // Catatan Admin
                      _buildCatatanAdmin(),

                      const SizedBox(height: 30),

                      // Tombol Simpan
                      _buildSimpanButton(),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tambah Catatan & Penilaian Admin',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.grey, size: 24),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildReportInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Area : Lantai 1 - ${widget.report.title}    ${widget.report.tanggal}',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildFotoBukti() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foto Bukti',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: widget.report.imagePaths.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.report.imagePaths.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildImagePlaceholder();
                    },
                  ),
                )
              : _buildImagePlaceholder(),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            Icons.camera_alt_outlined,
            size: 30,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildTasksList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kebersihan yang dikerjakan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ...widget.report.tasks
            .map(
              (task) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: task.isCompleted
                            ? const Color(0xFF4CAF50)
                            : Colors.transparent,
                        border: Border.all(
                          color: task.isCompleted
                              ? const Color(0xFF4CAF50)
                              : Colors.grey.shade400,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: task.isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        task.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: task.isCompleted
                              ? Colors.black87
                              : Colors.grey.shade600,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildCatatanPetugas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catatan Petugas',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            widget.report.catatanPetugas ?? 'Tidak ada catatan petugas',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPenilaianKualitas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Penilaian Kualitas Kerja',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _rating = index + 1;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  _rating > index ? Icons.star : Icons.star_border,
                  color: _rating > index ? Colors.amber : Colors.grey.shade400,
                  size: 28,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCatatanAdmin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catatan Admin',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _catatanAdminController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Berikan feedback, saran atau apresiasi',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4CAF50)),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildSimpanButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          _simpanCatatanDanPenilaian();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Simpan Catatan & Penilaian',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _simpanCatatanDanPenilaian() {
    // TODO: Implement save functionality
    print('Simpan catatan: ${_catatanAdminController.text}');
    print('Rating: $_rating');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catatan dan penilaian berhasil disimpan'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );

    Navigator.of(context).pop();
  }
}
