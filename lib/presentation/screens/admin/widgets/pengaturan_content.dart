import 'package:flutter/material.dart';
import '../../../../shared/widgets/ringkasan_widget.dart';

class PengaturanContentWidget extends StatefulWidget {
  final Map<String, int>? weeklySummary;

  const PengaturanContentWidget({Key? key, this.weeklySummary})
    : super(key: key);

  @override
  State<PengaturanContentWidget> createState() =>
      _PengaturanContentWidgetState();
}

class _PengaturanContentWidgetState extends State<PengaturanContentWidget> {
  @override
  Widget build(BuildContext context) {
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ringkasan Mingguan Card
            RingkasanWidget(
              weeklySummary:
                  widget.weeklySummary ??
                  {'total': 12, 'selesai': 7, 'menunggu': 3, 'ditolak': 2},
            ),

            // Pengaturan Sistem Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pengaturan Sistem",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Konfigurasi pengaturan untuk administrator BPS Sukabumi",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Jam Kerja Section
                  _buildSettingsCard(
                    title: 'Jam Kerja',
                    children: [
                      _buildTimeSelector('Jam Kerja', '07:30', '18:00'),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Export Laporan Section
                  _buildSettingsCard(
                    title: 'Export Laporan',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildExportButton(
                              'Export PDF',
                              Icons.picture_as_pdf,
                              Colors.red,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildExportButton(
                              'Export Excel',
                              Icons.table_chart,
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Keamanan Section
                  _buildSettingsCard(
                    title: 'Keamanan',
                    children: [
                      _buildSecurityButton('Ganti Password', Colors.red),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTimeSelector(String label, String startTime, String endTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(startTime, style: const TextStyle(fontSize: 14)),
                    const Icon(Icons.access_time, size: 20, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(endTime, style: const TextStyle(fontSize: 14)),
                    const Icon(Icons.access_time, size: 20, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExportButton(String label, IconData icon, Color color) {
    return OutlinedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label - Coming Soon'),
            backgroundColor: color,
          ),
        );
      },
      icon: Icon(icon, color: color, size: 20),
      label: Text(label, style: TextStyle(color: color, fontSize: 12)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildSecurityButton(String label, Color color) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label - Coming Soon'),
              backgroundColor: color,
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
