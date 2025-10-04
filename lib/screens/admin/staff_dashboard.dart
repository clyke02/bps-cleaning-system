import 'package:flutter/material.dart';
import 'admin_navbar.dart';

class StaffDashboardPage extends StatefulWidget {
  const StaffDashboardPage({Key? key}) : super(key: key);

  @override
  State<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends State<StaffDashboardPage> {
  int _selectedTab = 1; // Petugas

  @override
  Widget build(BuildContext context) {
    final staffList = [
      {'name': 'Ahmad Suryadi', 'phone': '081234567890'},
      {'name': 'Budi Santoso', 'phone': '081234567890'},
      {'name': 'Siti Aminah', 'phone': '081234567890'},
      {'name': 'Joko Purnomo', 'phone': '081234567890'},
      {'name': 'Adit', 'phone': '081234567890'},
      {'name': 'Jajang', 'phone': '081234567890'},
      {'name': 'Yudi', 'phone': '081234567890'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header / AppBar
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
                // Ringkasan Minggu Ini
                Container(
                  width: double.infinity,
                  // color dihapus agar transparan dan mengikuti gradasi
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
                // Card Manajemen Petugas
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.13),
                              blurRadius: 18,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Manajemen Petugas',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Kelola data petugas kebersihan',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4ADE80), // green
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.add, color: Colors.white, size: 22),
                                      tooltip: 'Tambah',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F6FA),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: staffList.length,
                                separatorBuilder: (context, idx) => const SizedBox(height: 8),
                                itemBuilder: (context, idx) {
                                  final staff = staffList[idx];
                                  final initials = staff['name']!.split(' ').map((e) => e[0]).take(2).join().toUpperCase();
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.06),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                      leading: CircleAvatar(
                                        backgroundColor: const Color(0xFF4ADE80),
                                        radius: 18,
                                        child: Text(
                                          initials,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        staff['name']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                      subtitle: Text(
                                        staff['phone']!,
                                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFFFFD600),
                                              foregroundColor: Colors.black,
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              minimumSize: const Size(0, 26),
                                              elevation: 0,
                                            ),
                                            child: const Text('Edit'),
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF3F4F6),
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.delete_outline, color: Colors.black38, size: 18),
                                              tooltip: 'Hapus',
                                              padding: const EdgeInsets.all(6),
                                              constraints: const BoxConstraints(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 18),
                            // Area kosong bawah agar card tidak mepet
                            Container(
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AdminNavbar(
        currentIndex: _selectedTab,
        onTabSelected: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/admin');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/admin/staff');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/admin/area');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/admin/settings');
          }
        },
      ),
    );
  }
}
