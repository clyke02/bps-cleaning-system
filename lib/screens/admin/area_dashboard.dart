import 'package:flutter/material.dart';
import 'admin_navbar.dart';

class AreaDashboardPage extends StatefulWidget {
  const AreaDashboardPage({Key? key}) : super(key: key);

  @override
  State<AreaDashboardPage> createState() => _AreaDashboardPageState();
}

class _AreaDashboardPageState extends State<AreaDashboardPage> {
  int _selectedIndex = 2;
  final List<Map<String, String>> areaList = [
    {"name": "Ruang Rapat"},
    {"name": "Toilet"},
    {"name": "Dapur"},
    {"name": "Mushola"},
    {"name": "Lobby Utama"},
    {"name": "Ruang Meeting"},
  ];

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
                // Header
                Container(
                  padding: const EdgeInsets.only(left: 14, right: 9, top: 10, bottom: 10),
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
                            onPressed: () {},
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

                // Ringkasan Minggu Ini
                Container(
                  width: double.infinity,
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
                                  color: const Color(0xFFD32F2F),
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
                                  children: const [
                                    Text(
                                      "2",
                                      style: TextStyle(
                                        color: Color(0xFFF39C12),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 2),
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
                                  children: const [
                                    Text(
                                      "7",
                                      style: TextStyle(
                                        color: Color(0xFF388E3C),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 2),
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
                                  children: const [
                                    Text(
                                      "3",
                                      style: TextStyle(
                                        color: Color(0xFFD32F2F),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 2),
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

                // Manajemen Area
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Manajemen Area', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                SizedBox(height: 2),
                                Text('Kelola data Area Kebersihan', style: TextStyle(fontSize: 14, color: Colors.black45)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8, top: 2),
                            child: Material(
                              color: const Color(0xFF4FC3A1),
                              shape: const CircleBorder(),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () {},
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.add, color: Colors.white, size: 28),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: areaList.length,
                        separatorBuilder: (context, i) => const SizedBox(height: 16),
                        itemBuilder: (context, i) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.13),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      areaList[i]["name"]!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFFFD600),
                                          foregroundColor: Colors.black87,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {},
                                        icon: const Icon(Icons.groups, size: 20),
                                        label: const Text('Edit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                      ),
                                      const SizedBox(width: 10),
                                      Material(
                                        color: Colors.transparent,
                                        shape: const CircleBorder(),
                                        child: IconButton(
                                          icon: const Icon(Icons.delete_outline, color: Colors.black87, size: 28),
                                          onPressed: () {},
                                          splashRadius: 22,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
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
