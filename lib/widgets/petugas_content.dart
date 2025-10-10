import 'package:flutter/material.dart';

class PetugasContent extends StatefulWidget {
  const PetugasContent({super.key});

  @override
  State<PetugasContent> createState() => _PetugasContentState();
}

class _PetugasContentState extends State<PetugasContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Data dummy petugas
  List<Map<String, dynamic>> petugasData = [
    {
      "nama": "Budi Santoso",
      "area": "Ruang Pengolahan Data",
      "status": "Aktif",
      "statusColor": Colors.green,
      "jadwal": "Senin - Jumat",
      "phone": "081234567890",
    },
    {
      "nama": "Siti Rahayu", 
      "area": "Ruang Server",
      "status": "Aktif",
      "statusColor": Colors.green,
      "jadwal": "Senin - Jumat",
      "phone": "081234567891",
    },
    {
      "nama": "Ahmad Wijaya",
      "area": "Ruang Meeting",
      "status": "Cuti",
      "statusColor": Colors.orange,
      "jadwal": "Senin - Jumat", 
      "phone": "081234567892",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter data berdasarkan search query
    final filteredData = petugasData.where((petugas) {
      final query = _searchQuery.toLowerCase();
      final nama = petugas["nama"].toString().toLowerCase();
      final area = petugas["area"].toString().toLowerCase();
      return nama.contains(query) || area.contains(query);
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
                          "Data Petugas",
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
                          color: Color(0xFF388E3C),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${petugasData.length} Orang",
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
                        count: "${petugasData.where((p) => p['status'] == 'Aktif').length}",
                        label: "Aktif",
                        color: const Color(0xFF388E3C),
                      ),
                      _SummaryItem(
                        count: "${petugasData.where((p) => p['status'] == 'Cuti').length}",
                        label: "Cuti",
                        color: const Color(0xFFF39C12),
                      ),
                      _SummaryItem(
                        count: "${petugasData.where((p) => p['status'] == 'Non-Aktif').length}",
                        label: "Non-Aktif",
                        color: const Color(0xFFD32F2F),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // SEARCH DAN LIST PETUGAS
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Manajemen Petugas",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                "Kelola data dan jadwal petugas kebersihan",
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
                          hintText: 'Cari Petugas',
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

        // LIST PETUGAS
        ...filteredData.map((petugas) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: _PetugasCard(
              nama: petugas["nama"],
              area: petugas["area"],
              status: petugas["status"],
              statusColor: petugas["statusColor"],
              jadwal: petugas["jadwal"],
              phone: petugas["phone"],
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

class _PetugasCard extends StatelessWidget {
  final String nama;
  final String area;
  final String status;
  final Color statusColor;
  final String jadwal;
  final String phone;

  const _PetugasCard({
    required this.nama,
    required this.area,
    required this.status,
    required this.statusColor,
    required this.jadwal,
    required this.phone,
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
                const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  area,
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
                  jadwal,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  phone,
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