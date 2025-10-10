import 'package:flutter/material.dart';
import 'admin_navbar.dart';
import 'widgets/petugas_content.dart';
import 'widgets/area_content.dart';
import 'widgets/pengaturan_content.dart';
import '../../models/report_model.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;
  
  // Sample data - sesuai dengan design asli tapi dengan models baru
  final List<Report> _reports = [
    Report(
      id: 1,
      title: 'Ruang Pengolahan Data',
      petugas: 'Ahmad Suryadi',
      tanggal: '25-08-2025',
      status: ReportStatus.selesai,
      catatanPetugas: 'Pembersihan rutin pagi hari',
      catatanAdmin: 'Pekerjaan baik, area bersih',
      areaId: 1,
      tasks: [
        CleaningTask(id: 1, description: 'Mengepel lantai toilet', isCompleted: true),
        CleaningTask(id: 2, description: 'Membersihkan kloset duduk/jongkok', isCompleted: true),
        CleaningTask(id: 3, description: 'Membersihkan wastafel', isCompleted: true),
      ],
    ),
    Report(
      id: 2,
      title: 'Toilet',
      petugas: 'Siti Aminah',
      tanggal: '25-08-2025',
      status: ReportStatus.menunggu,
      catatanPetugas: 'Pembersihan rutin pagi hari',
      areaId: 2,
      tasks: [
        CleaningTask(id: 4, description: 'Mengepel lantai toilet', isCompleted: false),
        CleaningTask(id: 5, description: 'Membersihkan kloset duduk/jongkok', isCompleted: false),
      ],
    ),
    Report(
      id: 3,
      title: 'Ruang Meeting',
      petugas: 'Ahmad Suryadi',
      tanggal: '24-08-2025',
      status: ReportStatus.selesai,
      catatanPetugas: 'Pembersihan rutin',
      catatanAdmin: 'Bagus',
      areaId: 3,
      tasks: [
        CleaningTask(id: 6, description: 'Membersihkan meja', isCompleted: true),
      ],
    ),
    Report(
      id: 4,
      title: 'Lobby',
      petugas: 'Siti Aminah',
      tanggal: '24-08-2025',
      status: ReportStatus.selesai,
      catatanPetugas: 'Pembersihan rutin',
      catatanAdmin: 'Selesai dengan baik',
      areaId: 4,
      tasks: [
        CleaningTask(id: 7, description: 'Membersihkan lantai', isCompleted: true),
      ],
    ),
    Report(
      id: 5,
      title: 'Dapur',
      petugas: 'Ahmad Suryadi',
      tanggal: '23-08-2025',
      status: ReportStatus.selesai,
      catatanPetugas: 'Pembersihan rutin',
      catatanAdmin: 'Baik',
      areaId: 5,
      tasks: [
        CleaningTask(id: 8, description: 'Membersihkan kompor', isCompleted: true),
      ],
    ),
    Report(
      id: 6,
      title: 'Mushola',
      petugas: 'Siti Aminah',
      tanggal: '23-08-2025',
      status: ReportStatus.selesai,
      catatanPetugas: 'Pembersihan rutin',
      catatanAdmin: 'Sangat bersih',
      areaId: 6,
      tasks: [
        CleaningTask(id: 9, description: 'Membersihkan karpet', isCompleted: true),
      ],
    ),
    Report(
      id: 7,
      title: 'Ruang Rapat',
      petugas: 'Ahmad Suryadi',
      tanggal: '22-08-2025',
      status: ReportStatus.selesai,
      catatanPetugas: 'Pembersihan rutin',
      catatanAdmin: 'Excellent',
      areaId: 7,
      tasks: [
        CleaningTask(id: 10, description: 'Membersihkan whiteboard', isCompleted: true),
      ],
    ),
    Report(
      id: 8,
      title: 'Toilet Lantai 2',
      petugas: 'Siti Aminah',
      tanggal: '22-08-2025',
      status: ReportStatus.selesai,
      catatanPetugas: 'Pembersihan rutin',
      catatanAdmin: 'Bersih',
      areaId: 8,
      tasks: [
        CleaningTask(id: 11, description: 'Membersihkan toilet', isCompleted: true),
      ],
    ),
    Report(
      id: 9,
      title: 'Kantin',
      petugas: 'Ahmad Suryadi',
      tanggal: '21-08-2025',
      status: ReportStatus.menunggu,
      catatanPetugas: 'Menunggu verifikasi',
      areaId: 9,
      tasks: [
        CleaningTask(id: 12, description: 'Membersihkan meja makan', isCompleted: false),
      ],
    ),
    Report(
      id: 10,
      title: 'Ruang Server',
      petugas: 'Siti Aminah',
      tanggal: '21-08-2025',
      status: ReportStatus.menunggu,
      catatanPetugas: 'Menunggu verifikasi',
      areaId: 10,
      tasks: [
        CleaningTask(id: 13, description: 'Membersihkan area server', isCompleted: false),
      ],
    ),
    Report(
      id: 11,
      title: 'Parkir',
      petugas: 'Ahmad Suryadi',
      tanggal: '20-08-2025',
      status: ReportStatus.ditolak,
      catatanPetugas: 'Butuh pembersihan ulang',
      catatanAdmin: 'Tidak sesuai standar',
      areaId: 11,
      tasks: [
        CleaningTask(id: 14, description: 'Membersihkan area parkir', isCompleted: false),
      ],
    ),
    Report(
      id: 12,
      title: 'Gudang',
      petugas: 'Siti Aminah',
      tanggal: '20-08-2025',
      status: ReportStatus.ditolak,
      catatanPetugas: 'Perlu pembersihan tambahan',
      catatanAdmin: 'Masih kotor di beberapa area',
      areaId: 12,
      tasks: [
        CleaningTask(id: 15, description: 'Membersihkan gudang', isCompleted: false),
      ],
    ),
  ];

  // Method untuk menghitung summary statistics yang konsisten
  Map<String, int> get weeklySummary {
    final completed = _reports.where((r) => r.status == ReportStatus.selesai).length;
    final pending = _reports.where((r) => r.status == ReportStatus.menunggu).length;
    final rejected = _reports.where((r) => r.status == ReportStatus.ditolak).length;
    
    return {
      'selesai': completed,      // 7
      'menunggu': pending,       // 3  
      'ditolak': rejected,       // 2
      'total': _reports.length,  // 12
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF5F9),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildContent(),
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
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  boxShadow: const [
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
                    const Flexible(
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
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildLaporanContent();
      case 1:
        return _buildPetugasContent();
      case 2:
        return _buildAreaContent();
      case 3:
        return _buildPengaturanContent();
      default:
        return _buildLaporanContent();
    }
  }

  Widget _buildLaporanContent() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2196F3), // biru
            Color(0xFF4ADE80), // hijau muda
          ],
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // RINGKASAN MINGGU INI
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 16, bottom: 20),
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                            "Ringkasan Mingguan",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD32F2F),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${weeklySummary['total']} Tugas",
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _SummaryItem(count: "${weeklySummary['selesai']}", label: "Selesai", color: const Color(0xFF388E3C)),
                        _SummaryItem(count: "${weeklySummary['menunggu']}", label: "Menunggu", color: const Color(0xFFF39C12)),
                        _SummaryItem(count: "${weeklySummary['ditolak']}", label: "Ditolak", color: const Color(0xFFD32F2F)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // SEARCH DAN LIST LAPORAN
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Laporan Kebersihan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Kelola dan verifikasi laporan dari petugas",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // SEARCH BAR
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Cari Ruangan",
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                        filled: true,
                        fillColor: Colors.grey.shade50,
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
                          borderSide: const BorderSide(color: Color(0xFF2196F3)),
                        ),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // LIST LAPORAN
                  ..._reports.map((report) => _buildReportCard(report)).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(Report report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  report.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(report.status),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(report.status),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${report.petugas} • ${report.tanggal}',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Detail action
                  },
                  child: const Text('Detail'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Beri catatan action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                  ),
                  child: const Text('Beri Catatan'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.selesai:
        return const Color(0xFF388E3C);
      case ReportStatus.menunggu:
        return const Color(0xFFF39C12);
      case ReportStatus.ditolak:
        return const Color(0xFFD32F2F);
    }
  }

  String _getStatusText(ReportStatus status) {
    switch (status) {
      case ReportStatus.selesai:
        return 'Selesai';
      case ReportStatus.menunggu:
        return 'Menunggu';
      case ReportStatus.ditolak:
        return 'Ditolak';
    }
  }

  Widget _buildPetugasContent() {
    return PetugasContentWidget(weeklySummary: weeklySummary);
  }

  Widget _buildAreaContent() {
    return AreaContentWidget(weeklySummary: weeklySummary);
  }

  Widget _buildPengaturanContent() {
    return PengaturanContentWidget(weeklySummary: weeklySummary);
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}