import 'package:flutter/material.dart';
import 'admin_navbar.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  // Dummy data laporan
  List<Map<String, dynamic>> laporanList = [
    {
      'title': 'Toilet Lantai 1',
      'status': 'Selesai',
      'statusColor': Colors.green,
      'petugas': 'Budi Santoso',
      'tanggal': '25-08-2025',
      'catatanPetugas': 'Sudah dibersihkan dan dicek',
      'isApproved': true,
    },
    {
      'title': 'Ruang Rapat',
      'status': 'Menunggu',
      'statusColor': Colors.orange,
      'petugas': 'Siti Aminah',
      'tanggal': '25-08-2025',
      'catatanPetugas': 'Akan dibersihkan siang',
      'isApproved': false,
    },
    {
      'title': 'Lobby Utama',
      'status': 'Menunggu',
      'statusColor': Colors.orange,
      'petugas': 'Joko Purnomo',
      'tanggal': '25-08-2025',
      'catatanPetugas': 'Perlu alat tambahan',
      'isApproved': false,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header / AppBar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0D000000), // 5% black
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left: Logo, Title, Subtitle
                  Image.asset(
                    'assets/logo.png',
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'BPS Sukabumi',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Sistem Kebersihan',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            height: 1.1,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26, width: 1.1),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person_outline, size: 18, color: Colors.black87),
                        const SizedBox(width: 6),
                        Text(
                          'Bambang',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Color(0xFFBDBDBD)),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Keluar'),
                  ),
                ],
              ),
            ),
            // Blue background for summary section (match 'Laporan Kebersihan')
            Container(
              width: double.infinity,
              color: const Color(0xFF00C6FB), // blue like 'Laporan Kebersihan'
              padding: const EdgeInsets.only(top: 24, bottom: 32),
              child: Center(
                child: Container(
                  width: 420,
                  constraints: const BoxConstraints(maxWidth: 500),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.13),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Ringkasan Minggu ini",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.5,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: Color(0xFFD32F2F),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "12 Tugas",
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Dikerjakan
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "2",
                                  style: TextStyle(
                                    color: Color(0xFFF39C12),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Dikerjakan",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Selesai
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "7",
                                  style: TextStyle(
                                    color: Color(0xFF388E3C),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Selesai",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Section: Laporan Kebersihan
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  children: [
                    // Section title
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 6, top: 2),
                      child: Text(
                        'Laporan Kebersihan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    // Search bar
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Cari Ruangan',
                                border: InputBorder.none,
                                isDense: true,
                                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Daftar laporan
                    ...laporanList.asMap().entries.map((entry) {
                      final i = entry.key;
                      final laporan = entry.value;
                      return _ReportCard(
                        title: laporan['title'],
                        status: laporan['status'],
                        statusColor: laporan['statusColor'],
                        petugas: laporan['petugas'],
                        tanggal: laporan['tanggal'],
                        catatanPetugas: laporan['catatanPetugas'],
                        isApproved: laporan['isApproved'],
                        onUpdate: (data) {
                          setState(() {
                            laporanList[i] = {
                              ...laporanList[i],
                              'status': data['status'],
                              'statusColor': data['statusColor'],
                              'isApproved': data['isApproved'],
                            };
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.13),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: AdminNavbar(
          currentIndex: 0,
          onTabSelected: (index) {
            // TODO: Implement navigation for each tab
          },
        ),
      ),
    );
  }
}

class _ReportCard extends StatefulWidget {
  final String title;
  final String status;
  final Color statusColor;
  final String petugas;
  final String tanggal;
  final String catatanPetugas;
  final String? catatanAdmin = null;
  final bool isApproved;
  final String? imagePath = null;
  final Function(Map<String, dynamic>) onUpdate;

  const _ReportCard({
    required this.title,
    required this.status,
    required this.statusColor,
    required this.petugas,
    required this.tanggal,
    required this.catatanPetugas,
  // this.catatanAdmin,
    required this.isApproved,
  // this.imagePath,
    required this.onUpdate,
  });

  @override
  State<_ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<_ReportCard> {
  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(ctx),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: widget.imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.imagePath!,
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.5,
                    ),
                  )
                : const SizedBox(
                    width: 200,
                    height: 200,
                    child: Center(
                      child: Text(
                        'Tidak ada foto',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
  void _updateData({
    String? status,
    Color? statusColor,
    bool? isApproved,
    String? catatanAdmin,
  }) {
    widget.onUpdate({
      "title": widget.title,
      "status": status ?? widget.status,
      "statusColor": statusColor ?? widget.statusColor,
      "petugas": widget.petugas,
      "tanggal": widget.tanggal,
      "catatanPetugas": widget.catatanPetugas,
      "catatanAdmin": catatanAdmin ?? adminNote,
      "isApproved": isApproved ?? widget.isApproved,
      "imagePath": widget.imagePath,
    });
  }

  void _beriCatatan() async {
    final controller = TextEditingController();
    String? result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Beri Catatan Admin"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Tulis catatan..."),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: const Text("Simpan")),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        adminNote = result;
      });
      _updateData(isApproved: widget.isApproved, catatanAdmin: result);
    }
  }
  String? adminNote;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = screenWidth - 32; // 16px margin left/right
    final double imageWidth = screenWidth < 400 ? 120 : 140;
    final double imageHeight = screenWidth < 400 ? 75 : 90;
    final double buttonHeight = 32;
    final double buttonFontSize = 13;
    final double downloadButtonWidth = screenWidth < 400 ? 130 : 150;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        margin: EdgeInsets.zero,
        child: Container(
          width: cardWidth,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title, Status, Detail (all in one row)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(widget.petugas,
                            style: const TextStyle(fontSize: 13, color: Colors.black87)),
                        Text(widget.tanggal,
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.status,
                              style: TextStyle(
                                color: widget.statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(0, buttonHeight),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              side: const BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            child: const Text("Detail", style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Body: Image + Notes
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image (large, rectangular)
                  Column(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          _showImageDialog();
                        },
                        child: Container(
                          height: imageHeight,
                          width: imageWidth,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade100,
                          ),
                          child: widget.imagePath != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(widget.imagePath!, fit: BoxFit.cover),
                                )
                              : const Center(
                                  child: Icon(Icons.camera_alt, size: 28, color: Colors.grey),
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Klik Untuk Memperbesar",
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  // Notes and Actions
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Catatan Petugas:", style: TextStyle(fontSize: 12, color: Colors.black54)),
                        Text(widget.catatanPetugas, style: TextStyle(fontSize: 13)),
                        if (adminNote != null && adminNote!.trim().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text("Catatan Admin:", style: TextStyle(fontSize: 12, color: Colors.black54)),
                          Text(adminNote!, style: TextStyle(fontSize: 13)),
                        ],
                        // Tombol Setujui & Tolak selalu muncul jika status Menunggu
                        if (widget.status == "Menunggu") ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                flex: 1,
                                child: SizedBox(
                                  height: buttonHeight,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        adminNote = adminNote; // keep admin note
                                      });
                                      _updateData(
                                        status: "Selesai",
                                        statusColor: Colors.green,
                                        isApproved: true,
                                      );
                                    },
                                    icon: const Icon(Icons.check, size: 16),
                                    label: const Text("Setujui"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      textStyle: TextStyle(fontSize: buttonFontSize, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                flex: 1,
                                child: SizedBox(
                                  height: buttonHeight,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        adminNote = adminNote;
                                      });
                                      _updateData(
                                        status: "Tidak Setuju",
                                        statusColor: Colors.red,
                                        isApproved: false,
                                      );
                                    },
                                    icon: const Icon(Icons.close, size: 16),
                                    label: const Text("Tolak"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      textStyle: TextStyle(fontSize: buttonFontSize, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 130,
                          height: buttonHeight,
                          child: OutlinedButton.icon(
                            onPressed: _beriCatatan,
                            icon: const Icon(Icons.chat_bubble_outline, size: 15),
                            label: const Text("Beri Catatan"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              side: const BorderSide(color: Color(0xFFBDBDBD)),
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: downloadButtonWidth,
                              height: buttonHeight,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.download, size: 15),
                                label: const Text("Download Laporan"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
// ...existing code...
  }
// ...existing code...
