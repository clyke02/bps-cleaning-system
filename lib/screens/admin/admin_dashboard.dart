
import 'package:flutter/material.dart';
import 'staff_dashboard.dart';
import 'area_dashboard.dart';
import 'settings_dashboard.dart';
import 'admin_navbar.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedIndex = 0;
  List<Map<String, dynamic>> reportData = [
    {
      "title": "Ruang Pengolahan Data",
      "status": "Selesai",
      "statusColor": Colors.green,
      "petugas": "Budi Santoso",
      "tanggal": "25-08-2025",
      "catatanPetugas": "Pembersihan rutin pagi hari",
      "catatanAdmin": "Pekerjaan baik, area bersih",
      "isApproved": true,
      "imagePath": null, 
    },
    {
      "title": "Toilet",
      "status": "Menunggu",
      "statusColor": Colors.orange,
      "petugas": "Siti Aminah",
      "tanggal": "25-08-2025",
      "catatanPetugas": "Pembersihan rutin pagi hari",
      "catatanAdmin": null,
      "isApproved": false,
      "imagePath": null,
    },
  ];

  void updateStatus(int index, String newStatus, Color newColor, bool isApproved) {
    setState(() {
      reportData[index]["status"] = newStatus;
      reportData[index]["statusColor"] = newColor;
      reportData[index]["isApproved"] = isApproved;
    });
  }

  void updateCatatan(int index, String catatan) {
    setState(() {
      reportData[index]["catatanAdmin"] = catatan;
    });
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/admin');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/admin/staff');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/admin/area');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/admin/settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF5F9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header mirip staff_dashboard
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo dan judul
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 54,
                        height: 54,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'BPS Sukabumi',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              color: Colors.black,
                              letterSpacing: 0.1,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Sistem Kebersihan',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              height: 1.1,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Profile dan tombol keluar
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 120),
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black87, width: 1.3),
                              ),
                              child: const Center(
                                child: Icon(Icons.person_outline, size: 18, color: Colors.black87),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Bambang',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                  letterSpacing: 0.1,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black12,
                                      blurRadius: 1,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Color(0xFFBDBDBD)),
                          ),
                          elevation: 1,
                        ),
                        child: const Text('Keluar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Konten utama scrollable
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF4ADE80), Color(0xFF2196F3)],
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Ringkasan Minggu Ini (identik staff_dashboard)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 24, bottom: 32),
                      child: Center(
                        child: Container(
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
                                  const Expanded(
                                    child: Text(
                                      "Ringkasan Minggu ini",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                        decorationThickness: 2,
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
                                  // Menunggu
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "2",
                                          style: TextStyle(
                                            color: Color(0xFFF39C12),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "menunggu",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
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
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "Selesai",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Tidak Setuju
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "3",
                                          style: TextStyle(
                                            color: Color(0xFFD32F2F),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "tidak setuju",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
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
                    // Section Title & Search (tanpa card putih, sesuai gambar)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Laporan Kebersihan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Kelola dan pantau laporan dari petugas",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              shadows: [Shadow(color: Colors.black26, blurRadius: 2, offset: Offset(0,1))],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.10),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Icon(Icons.search, color: Colors.grey, size: 22),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (value) {
                                      setState(() {
                                        _searchQuery = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Cari Ruangan',
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Card Laporan
                    ...reportData.where((r) {
                      final query = _searchQuery.toLowerCase();
                      final title = r["title"].toString().toLowerCase();
                      final petugas = r["petugas"].toString().toLowerCase();
                      return title.contains(query) || petugas.contains(query);
                    }).map((r) {
                      int i = reportData.indexOf(r);
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        child: _ReportCard(
                          index: i,
                          title: r["title"],
                          status: r["status"],
                          statusColor: r["statusColor"],
                          petugas: r["petugas"],
                          tanggal: r["tanggal"],
                          catatanPetugas: r["catatanPetugas"],
                          catatanAdmin: r["catatanAdmin"],
                          isApproved: r["isApproved"] ?? false,
                          imagePath: r["imagePath"],
                          onStatusChange: updateStatus,
                          onCatatanChange: updateCatatan,
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AdminNavbar(
        currentIndex: _selectedIndex,
        onTabSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminDashboardPage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const StaffDashboardPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AreaDashboardPage()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SettingsDashboardPage()),
            );
          }
        },
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final int index;
  final String title;
  final String status;
  final Color statusColor;
  final String petugas;
  final String tanggal;
  final String catatanPetugas;
  final String? catatanAdmin;
  final bool isApproved;
  final String? imagePath;
  final Function(int, String, Color, bool) onStatusChange;
  final Function(int, String) onCatatanChange;

  const _ReportCard({
    required this.index,
    required this.title,
    required this.status,
    required this.statusColor,
    required this.petugas,
    required this.tanggal,
    required this.catatanPetugas,
    required this.catatanAdmin,
    required this.isApproved,
    required this.imagePath,
    required this.onStatusChange,
    required this.onCatatanChange,
  });

  void _beriCatatan(BuildContext context) async {
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
          ElevatedButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text("Simpan")),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      onCatatanChange(index, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // header
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(petugas, style: const TextStyle(fontSize: 13, color: Colors.black87)),
              Text(tanggal, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ]),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 32)),
                child: const Text("Detail", style: TextStyle(fontSize: 12)),
              ),
            ])
          ]),
          const SizedBox(height: 12),

          // body
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Gambar lebih besar di kiri
            Container(
              width: 130,
              height: 100,
              child: GestureDetector(
                onTap: (imagePath?.isNotEmpty == true)
                    ? () {
                        showDialog(
                          context: context,
                          builder: (ctx) => Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: const EdgeInsets.all(16),
                            child: InteractiveViewer(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  imagePath!,
                                  fit: BoxFit.contain,
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  height: MediaQuery.of(context).size.height * 0.6,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    : null,
                child: Container(
                  height: 100,
                  width: 130,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
          child: (imagePath?.isNotEmpty == true)
            ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(imagePath!, fit: BoxFit.cover))
            : const Center(child: Icon(Icons.camera_alt, size: 32, color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Catatan Petugas: $catatanPetugas", style: const TextStyle(fontSize: 13)),
                  if (catatanAdmin != null)
                    Text("Catatan Admin: $catatanAdmin", style: const TextStyle(fontSize: 13)),
                  if (status == 'Menunggu') ...[
                    const SizedBox(height: 8),
                    Row(children: [
                      ElevatedButton.icon(
                        onPressed: () => onStatusChange(index, "Selesai", Colors.green, true),
                        icon: const Icon(Icons.check, size: 14),
                        label: const Text("Setujui"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () => onStatusChange(index, "Tidak Setuju", Colors.red, false),
                        icon: const Icon(Icons.close, size: 14),
                        label: const Text("Tolak"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => _beriCatatan(context),
                      icon: const Icon(Icons.chat_bubble_outline, size: 16),
                      label: const Text("Beri Catatan"),
                    ),
                  ]
                  else ...[
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => _beriCatatan(context),
                      icon: const Icon(Icons.chat_bubble_outline, size: 16),
                      label: const Text("Beri Catatan"),
                    ),
                  ]
                ],
              ),
            )
          ]),
          const SizedBox(height: 12),

          // action row
          Row(
            children: [
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 16),
                label: const Text("Download Laporan"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
