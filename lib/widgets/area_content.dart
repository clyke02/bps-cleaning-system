import 'package:flutter/material.dart';

class AreaContent extends StatefulWidget {
  const AreaContent({super.key});

  @override
  State<AreaContent> createState() => _AreaContentState();
}

class _AreaContentState extends State<AreaContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Data dummy area
  List<Map<String, dynamic>> areaData = [
    {
      "nama": "Ruang Pengolahan Data",
      "petugas": "Budi Santoso",
      "status": "Bersih",
      "statusColor": Colors.green,
      "lastCleaned": "2 jam yang lalu",
      "schedule": "Setiap 4 jam",
    },
    {
      "nama": "Ruang Server",
      "petugas": "Siti Rahayu",
      "status": "Sedang Dibersihkan",
      "statusColor": Colors.blue,
      "lastCleaned": "Sedang berlangsung",
      "schedule": "Setiap 6 jam",
    },
    {
      "nama": "Ruang Meeting A",
      "petugas": "Ahmad Wijaya",
      "status": "Perlu Dibersihkan",
      "statusColor": Colors.orange,
      "lastCleaned": "5 jam yang lalu",
      "schedule": "Setiap 4 jam",
    },
    {
      "nama": "Ruang Meeting B",
      "petugas": "Ahmad Wijaya", 
      "status": "Bersih",
      "statusColor": Colors.green,
      "lastCleaned": "1 jam yang lalu",
      "schedule": "Setiap 4 jam",
    },
    {
      "nama": "Toilet Lantai 1",
      "petugas": "Budi Santoso",
      "status": "Perlu Dibersihkan",
      "statusColor": Colors.red,
      "lastCleaned": "8 jam yang lalu",
      "schedule": "Setiap 2 jam",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter data berdasarkan search query
    final filteredData = areaData.where((area) {
      final query = _searchQuery.toLowerCase();
      final nama = area["nama"].toString().toLowerCase();
      final petugas = area["petugas"].toString().toLowerCase();
      return nama.contains(query) || petugas.contains(query);
    }).toList();

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // RINGKASAN
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
                          "Manajemen Area",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Color(0xFF2196F3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${areaData.length} Area",
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _SummaryItem(
                        count: "${areaData.where((a) => a['status'] == 'Bersih').length}",
                        label: "Bersih",
                        color: const Color(0xFF388E3C),
                      ),
                      _SummaryItem(
                        count: "${areaData.where((a) => a['status'] == 'Perlu Dibersihkan').length}",
                        label: "Perlu",
                        color: const Color(0xFFF39C12),
                      ),
                      _SummaryItem(
                        count: "${areaData.where((a) => a['status'] == 'Sedang Dibersihkan').length}",
                        label: "Proses",
                        color: const Color(0xFF2196F3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // SEARCH DAN LIST AREA
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Monitoring Area",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                "Pantau status kebersihan seluruh area",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  shadows: [Shadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1))],
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
                          hintText: 'Cari Area',
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

        // LIST AREA
        ...filteredData.map((area) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: _AreaCard(
              nama: area["nama"],
              petugas: area["petugas"],
              status: area["status"],
              statusColor: area["statusColor"],
              lastCleaned: area["lastCleaned"],
              schedule: area["schedule"],
            ),
          );
        }).toList(),

        const SizedBox(height: 80), // Space for bottom nav
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const _SummaryItem({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class _AreaCard extends StatelessWidget {
  final String nama;
  final String petugas;
  final String status;
  final Color statusColor;
  final String lastCleaned;
  final String schedule;

  const _AreaCard({
    required this.nama,
    required this.petugas,
    required this.status,
    required this.statusColor,
    required this.lastCleaned,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  petugas,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "Dibersihkan: $lastCleaned",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.schedule_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "Jadwal: $schedule",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}