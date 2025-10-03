import 'package:flutter/material.dart';
import 'staff_management/staff_dashboard.dart';
import 'area_management/area_dashboard.dart';
import 'settings/settings_dashboard.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int tabIndex = 0;

  final List<Map<String, dynamic>> reportData = [
    {
      "title": "Ruang Pengolahan Data",
      "status": "Selesai",
      "statusColor": Colors.green,
      "petugas": "Budi Santoso",
      "tanggal": "25-08-2025",
      "catatanPetugas": "Pembersihan rutin pagi hari",
      "catatanAdmin": "Pekerjaan baik, area bersih",
      "isApproved": true,
      "imagePath": null, // kosong → tampil icon kamera
    },
    {
      "title": "Toilet",
      "status": "Menunggu",
      "statusColor": Colors.orange,
      "petugas": "Budi Santoso",
      "tanggal": "25-08-2025",
      "catatanPetugas": "Pembersihan rutin pagi hari",
      "catatanAdmin": null,
      "isApproved": false,
      "imagePath": null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ====== APP BAR ======
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 16,
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 30, errorBuilder: (_, __, ___) {
              return const Icon(Icons.dataset, color: Colors.blue);
            }),
            const SizedBox(width: 8),
            const Text(
              "BPS Sukabumi\nSistem Kebersihan",
              style: TextStyle(color: Colors.black, fontSize: 14, height: 1.2),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              const Icon(Icons.person, color: Colors.black87),
              const SizedBox(width: 6),
              const Text("Bambang",
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () {},
                child: const Text("Keluar", style: TextStyle(color: Colors.red)),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),

      // ====== BODY ======
      body: Column(
        children: [
          // ringkasan
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Ringkasan Minggu ini",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "12 Tugas",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _SummaryItem(color: Colors.orange, value: "2", label: "Dilewatkan"),
                    _SummaryItem(color: Colors.green, value: "7", label: "Selesai"),
                    _SummaryItem(color: Colors.red, value: "3", label: "Pending"),
                  ],
                ),
              ],
            ),
          ),

          // isi tab
          Expanded(
            child: IndexedStack(
              index: tabIndex,
              children: [
                _buildReportTab(),
                const StaffDashboard(),
                const AreaDashboard(),
                const SettingsDashboard(),
              ],
            ),
          ),
        ],
      ),

      // ====== BOTTOM NAV ======
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabIndex,
        onTap: (i) => setState(() => tabIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.article), label: "Laporan"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Petugas"),
          BottomNavigationBarItem(icon: Icon(Icons.home_work), label: "Area"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Pengaturan"),
        ],
      ),
    );
  }

  Widget _buildReportTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Laporan Kebersihan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Cari Ruangan",
              filled: true,
              fillColor: const Color(0xFFF6F7F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: reportData.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final r = reportData[i];
                return _ReportCard(
                  title: r["title"],
                  status: r["status"],
                  statusColor: r["statusColor"],
                  petugas: r["petugas"],
                  tanggal: r["tanggal"],
                  catatanPetugas: r["catatanPetugas"],
                  catatanAdmin: r["catatanAdmin"],
                  isApproved: r["isApproved"],
                  imagePath: r["imagePath"],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ====== Ringkasan Item ======
class _SummaryItem extends StatelessWidget {
  final Color color;
  final String value;
  final String label;
  const _SummaryItem({required this.color, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// ====== Kartu Laporan ======
class _ReportCard extends StatelessWidget {
  final String title;
  final String status;
  final Color statusColor;
  final String petugas;
  final String tanggal;
  final String catatanPetugas;
  final String? catatanAdmin;
  final bool isApproved;
  final String? imagePath;

  const _ReportCard({
    required this.title,
    required this.status,
    required this.statusColor,
    required this.petugas,
    required this.tanggal,
    required this.catatanPetugas,
    this.catatanAdmin,
    required this.isApproved,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(petugas,
                        style: const TextStyle(fontSize: 13, color: Colors.black87)),
                    Text(tanggal,
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            status.toLowerCase() == "selesai"
                                ? Icons.check_circle
                                : Icons.error_outline,
                            size: 14,
                            color: statusColor,
                          ),
                          const SizedBox(width: 4),
                          Text(status,
                              style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        minimumSize: const Size(0, 32),
                      ),
                      child:
                          const Text("Detail", style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Body
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(imagePath!,
                              fit: BoxFit.cover, width: 130, height: 100),
                        )
                      : const Icon(Icons.camera_alt,
                          size: 40, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Catatan Petugas: $catatanPetugas",
                          style: const TextStyle(fontSize: 13)),
                      Text("Catatan Admin: ${catatanAdmin ?? "-"}",
                          style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 12),

            // Tombol aksi
            if (!isApproved) ...[
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.check, size: 14),
                    label: const Text("Setujui"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.close, size: 14),
                    label: const Text("Tolak"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text("Beri Catatan"),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text("Download Laporan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
