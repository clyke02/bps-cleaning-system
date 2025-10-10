import 'package:flutter/material.dart';
import 'admin_navbar.dart';
import 'widgets/laporan_content.dart';
import 'widgets/petugas_content.dart';
import 'widgets/area_content.dart';
import 'widgets/pengaturan_content.dart';
import 'data/sample_report_data.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF5F9),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildContent()),
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
                        child: Icon(
                          Icons.person_outline,
                          size: 18,
                          color: Colors.black87,
                        ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 0,
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
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
        return LaporanContentWidget(
          weeklySummary: SampleReportData.weeklySummary,
        );
      case 1:
        return PetugasContentWidget(
          weeklySummary: SampleReportData.weeklySummary,
        );
      case 2:
        return AreaContentWidget(weeklySummary: SampleReportData.weeklySummary);
      case 3:
        return PengaturanContentWidget(
          weeklySummary: SampleReportData.weeklySummary,
        );
      default:
        return LaporanContentWidget(
          weeklySummary: SampleReportData.weeklySummary,
        );
    }
  }
}
