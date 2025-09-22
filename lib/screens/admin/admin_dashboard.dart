import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFF4CAF50),
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
      body: const AdminDashboardBody(),
    );
  }
}

class AdminDashboardBody extends StatelessWidget {
  const AdminDashboardBody({super.key});

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
                colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.admin_panel_settings, size: 40, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  'Selamat Datang, Admin!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Panel Kontrol Administrator',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Menu Grid untuk Admin
          const Text(
            'Menu Administrasi',
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
                'Manajemen User',
                Icons.people,
                Colors.blue,
                () {
                  // TODO: Navigate to user management
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur Manajemen User - Coming Soon'),
                    ),
                  );
                },
              ),
              _buildMenuCard(
                context,
                'Laporan Kebersihan',
                Icons.assessment,
                Colors.orange,
                () {
                  // TODO: Navigate to cleaning reports
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur Laporan Kebersihan - Coming Soon'),
                    ),
                  );
                },
              ),
              _buildMenuCard(
                context,
                'Jadwal Cleaning',
                Icons.schedule,
                Colors.purple,
                () {
                  // TODO: Navigate to cleaning schedule
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur Jadwal Cleaning - Coming Soon'),
                    ),
                  );
                },
              ),
              _buildMenuCard(
                context,
                'Pengaturan',
                Icons.settings,
                Colors.grey,
                () {
                  // TODO: Navigate to settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur Pengaturan - Coming Soon'),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Statistics Cards (Template untuk worker)
          const Text(
            'Statistik',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total User',
                  '25',
                  Icons.people,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Laporan Hari Ini',
                  '8',
                  Icons.today,
                  Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Pending Tasks',
                  '3',
                  Icons.pending,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Completed',
                  '12',
                  Icons.check_circle,
                  Colors.green,
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

  Widget _buildStatCard(
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
