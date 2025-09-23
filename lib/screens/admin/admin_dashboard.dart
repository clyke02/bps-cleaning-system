import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Dummy data laporan
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
        "imagePath": "https://picsum.photos/400/200",
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
        "imagePath": "https://picsum.photos/400/201",
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF53F383), Color(0xFF0080FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Image.asset(
                "assets/logo.png", // ✅ logo dari assets
                height: 40,
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                const Icon(Icons.account_circle,
                    color: Colors.black, size: 28), // ✅ ikon profil
                const SizedBox(width: 6),
                const Text(
                  "Bambang",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Keluar"),
                ),
                const SizedBox(width: 8),
              ],
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ---------- Ringkasan Minggu Ini ----------
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 5)
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
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "12 Tugas",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _SummaryItem(
                          color: Colors.orange, value: "2", label: "Dikerjakan"),
                      _SummaryItem(
                          color: Colors.green, value: "7", label: "Selesai"),
                      _SummaryItem(
                          color: Colors.red, value: "3", label: "Pending"),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- Tab Menu ----------
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: const [
                  Expanded(child: _TabButton(title: "Laporan", isActive: true)),
                  Expanded(child: _TabButton(title: "Petugas")),
                  Expanded(child: _TabButton(title: "Area")),
                  Expanded(child: _TabButton(title: "Pengaturan")),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- Container Laporan Kebersihan ----------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 5)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Laporan Kebersihan",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Cari Ruangan",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 0),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🔹 Daftar ReportCard pakai ListView.builder
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reportData.length,
                    itemBuilder: (context, index) {
                      final report = reportData[index];
                      return _ReportCard(
                        title: report["title"],
                        status: report["status"],
                        statusColor: report["statusColor"],
                        petugas: report["petugas"],
                        tanggal: report["tanggal"],
                        catatanPetugas: report["catatanPetugas"],
                        catatanAdmin: report["catatanAdmin"],
                        isApproved: report["isApproved"],
                        imagePath: report["imagePath"],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ---------- Sub Widget ----------
//
class _SummaryItem extends StatelessWidget {
  final Color color;
  final String value;
  final String label;

  const _SummaryItem(
      {required this.color, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isActive;
  const _TabButton({required this.title, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.grey.shade200 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.black : Colors.grey)),
      ),
    );
  }
}

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
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Header ----------
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 2),
                      Text(petugas,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black87)),
                      const SizedBox(height: 2),
                      Text(tanggal,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 32),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                      ),
                      child:
                          const Text("Detail", style: TextStyle(fontSize: 12)),
                    )
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ---------- Body (foto + catatan) ----------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto responsif + klik bisa zoom
                Container(
                  height: 120,
                  width: screenWidth * 0.35,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  backgroundColor: Colors.black,
                                  insetPadding: EdgeInsets.zero,
                                  child: InteractiveViewer(
                                    panEnabled: true,
                                    minScale: 0.5,
                                    maxScale: 4,
                                    child: Image.network(
                                      imagePath!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Image.network(
                              imagePath!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : const Center(
                          child: Icon(Icons.camera_alt,
                              size: 40, color: Colors.grey),
                        ),
                ),

                const SizedBox(width: 12),

                // Catatan di kanan
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Catatan Petugas: $catatanPetugas",
                          style: const TextStyle(fontSize: 13)),
                      if (catatanAdmin != null) ...[
                        const SizedBox(height: 4),
                        Text("Catatan Admin: $catatanAdmin",
                            style: const TextStyle(fontSize: 13)),
                      ],
                      const SizedBox(height: 12),

                      // ✅ Tombol Setujui / Tolak sejajar
                      if (!isApproved) ...[
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                ),
                                child: const Text(
                                  "Setujui",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                ),
                                child: const Text(
                                  "Tolak",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],

                      ElevatedButton.icon(
                        onPressed: () {},
                        icon:
                            const Icon(Icons.chat_bubble_outline, size: 16),
                        label: const Text("Beri Catatan"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ---------- Footer ----------
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 16),
                label: const Text("Download Laporan"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
