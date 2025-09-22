import 'package:flutter/material.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const UserDashboardBody(),
    );
  }
}

class UserDashboardBody extends StatelessWidget {
  const UserDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Welcome
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.person, size: 40, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  'Selamat Datang, User!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Panel User BPS Cleaning System',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Menu Grid untuk User
          const Text(
            'Menu User',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildMenuCard(
                context,
                'Lapor Kebersihan',
                Icons.report,
                Colors.red,
                () {
                  // TODO: Navigate to report cleaning
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur Lapor Kebersihan - Coming Soon'),
                    ),
                  );
                },
              ),
              _buildMenuCard(
                context,
                'Riwayat Laporan',
                Icons.history,
                Colors.green,
                () {
                  // TODO: Navigate to report history
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur Riwayat Laporan - Coming Soon'),
                    ),
                  );
                },
              ),
              _buildMenuCard(
                context,
                'Jadwal Tugas',
                Icons.calendar_today,
                Colors.orange,
                () {
                  // TODO: Navigate to task schedule
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur Jadwal Tugas - Coming Soon'),
                    ),
                  );
                },
              ),
              _buildMenuCard(
                context,
                'Profil',
                Icons.account_circle,
                Colors.purple,
                () {
                  // TODO: Navigate to profile
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur Profil - Coming Soon')),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Quick Actions (Template untuk worker)
          const Text(
            'Aksi Cepat',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.add_circle, color: Colors.blue),
              title: const Text('Buat Laporan Baru'),
              subtitle: const Text('Laporkan masalah kebersihan'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to create new report
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur Buat Laporan - Coming Soon'),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green),
              title: const Text('Foto Dokumentasi'),
              subtitle: const Text('Ambil foto untuk laporan'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to camera
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur Kamera - Coming Soon')),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Status Cards
          const Text(
            'Status Anda',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatusCard(
                  'Laporan Dikirim',
                  '5',
                  Icons.send,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatusCard(
                  'Diproses',
                  '2',
                  Icons.hourglass_empty,
                  Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatusCard(
                  'Selesai',
                  '3',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatusCard(
                  'Tugas Hari Ini',
                  '1',
                  Icons.today,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
