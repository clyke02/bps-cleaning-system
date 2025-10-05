import 'package:flutter/material.dart';
import 'admin_navbar.dart';

class SettingsDashboardPage extends StatefulWidget {
  const SettingsDashboardPage({Key? key}) : super(key: key);

  @override
  State<SettingsDashboardPage> createState() => _SettingsDashboardPageState();
}

class _SettingsDashboardPageState extends State<SettingsDashboardPage> {
  int _selectedIndex = 3;

  final TextEditingController _jamBukaController =
      TextEditingController(text: "07.30");
  final TextEditingController _jamTutupController =
      TextEditingController(text: "16.00");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF2196F3),
                Color(0xFF4ADE80),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER (disamakan area_dashboard)
                Container(
                  padding:
                      const EdgeInsets.only(left: 14, right: 9, top: 10, bottom: 10),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.10),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
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
                                    border:
                                        Border.all(color: Colors.black87, width: 1.3),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.person_outline,
                                        size: 18, color: Colors.black87),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 10),
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

                // RINGKASAN MINGGU INI
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 24, bottom: 32),
                  child: Center(
                    child: Container(
                      width: 420,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(18),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Color(0xFFD32F2F),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "12 Tugas",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              _SummaryItem(
                                count: "2",
                                label: "menunggu",
                                color: Color(0xFFF39C12),
                              ),
                              _SummaryItem(
                                count: "7",
                                label: "Selesai",
                                color: Color(0xFF388E3C),
                              ),
                              _SummaryItem(
                                count: "3",
                                label: "tidak setuju",
                                color: Color(0xFFD32F2F),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // PENGATURAN SISTEM
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
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
                      const Text(
                        "Pengaturan Sistem",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Konfigurasi aplikasi sistem kebersihan BPS Sukabumi",
                        style: TextStyle(
                            fontSize: 13, color: Colors.black54, height: 1.3),
                      ),
                      const SizedBox(height: 20),

                      // JAM KERJA
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.access_time,
                                    color: Colors.orangeAccent),
                                SizedBox(width: 6),
                                Text(
                                  "Jam Kerja",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Jam Buka"),
                                      const SizedBox(height: 4),
                                      TextField(
                                        controller: _jamBukaController,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Jam Tutup"),
                                      const SizedBox(height: 4),
                                      TextField(
                                        controller: _jamTutupController,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
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
                      const SizedBox(height: 18),

                      // EXPORT LAPORAN
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Export Laporan",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.picture_as_pdf),
                                  label: const Text("Export PDF"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    side:
                                        const BorderSide(color: Colors.black12),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon:
                                      const Icon(Icons.table_chart_outlined),
                                  label: const Text("Export Excel"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    side:
                                        const BorderSide(color: Colors.black12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // KEAMANAN
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Keamanan",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.vpn_key),
                              label: const Text("Ganti Password"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 40),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AdminNavbar(
        currentIndex: _selectedIndex,
        onTabSelected: (i) {
          setState(() => _selectedIndex = i);
          if (i == 0) {
            Navigator.pushReplacementNamed(context, '/admin');
          } else if (i == 1) {
            Navigator.pushReplacementNamed(context, '/admin/staff');
          } else if (i == 2) {
            Navigator.pushReplacementNamed(context, '/admin/area');
          } else if (i == 3) {
            Navigator.pushReplacementNamed(context, '/admin/settings');
          }
        },
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String count;
  final String label;
  final Color color;
  const _SummaryItem(
      {required this.count, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
