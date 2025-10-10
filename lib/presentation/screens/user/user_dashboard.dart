import 'package:flutter/material.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy list aktivitas
    final List<Map<String, String>> aktivitasList = [
      {"title": "Ruang Pengolahan Data", "floor": "Lantai 1", "room": "R.012", "date": "25-08-2025"},
      {"title": "Toilet", "floor": "Lantai 1", "room": "R.013", "date": "25-08-2025"},
      {"title": "Mushola", "floor": "Lantai 1", "room": "R.014", "date": "25-08-2025"},
      {"title": "Ruang Server & IT", "floor": "Lantai 2", "room": "R.021", "date": "25-08-2025"},
      {"title": "Dapur", "floor": "Lantai 1", "room": "R.015", "date": "25-08-2025"},
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                // Bagian kiri (logo + judul)
                Expanded(
                  child: Row(
                    children: [
                      Image.asset("assets/images/logo.png", height: 40),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("BPS Sukabumi",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text("Sistem Kebersihan",
                              style: TextStyle(fontSize: 11, color: Colors.black54)),
                        ],
                      ),
                    ],
                  ),
                ),

                // Bagian kanan (notif + profil + nama + logout)
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔔 Notifikasi
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/notifikasi');
                        },
                        icon: const Icon(Icons.notifications, color: Colors.black87),
                      ),

                      // 👤 Logo profil jadi tombol
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                        child: Image.asset(
                          "assets/images/profile.png",
                          height: 28,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // 📝 Nama User
                      Flexible(
                        child: Text(
                          "Bambang Firman Fatoni",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // 🚪 Tombol Keluar pakai icon
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        icon: const Icon(Icons.logout, color: Colors.red),
                        tooltip: "Keluar",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00FF87), Color(0xFF0077FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Header text
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Text(
                    "Selamat Datang, Bambang Firman Fatoni!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Pilih menu di bawah untuk mulai bekerja",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Card Aktivitas Terbaru
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Aktivitas Terbaru",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: Colors.grey, thickness: 0.5),
                    const SizedBox(height: 8),

                    // Scroll hanya di dalam container putih
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: aktivitasList.length,
                          itemBuilder: (context, index) {
                            final item = aktivitasList[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(item: item),
                                  ),
                                );
                              },
                              child: _buildAktivitasCard(
                                item['title']!,
                                "${item['floor']}   ${item['room']}   ${item['date']}",
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 6,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        currentIndex: 0,
        onTap: (index) {},
        items: [
          BottomNavigationBarItem(
              icon: Image.asset("assets/images/home.png", height: 22), label: "Home"),
          BottomNavigationBarItem(
              icon: Image.asset("assets/images/laporan.png", height: 22), label: "Laporan Darurat"),
          const BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
          BottomNavigationBarItem(
              icon: Image.asset("assets/images/setting.png", height: 22), label: "Setting"),
        ],
      ),
    );
  }

  // Card aktivitas putih dengan shadow
  Widget _buildAktivitasCard(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }
}

// 🔹 Halaman Detail
class DetailPage extends StatelessWidget {
  final Map<String, String> item;
  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['title'] ?? 'Detail'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama Ruangan: ${item['title']}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Lantai: ${item['floor']}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Nomor Ruangan: ${item['room']}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Tanggal: ${item['date']}", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
