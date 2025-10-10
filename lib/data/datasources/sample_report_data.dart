import '../models/report_model.dart';

class SampleReportData {
  static List<Report> reports = [
    Report(
      id: 1,
      title: 'Ruang Pengolahan Data',
      petugas: 'Ahmad Suryadi',
      tanggal: '25-08-2025',
      status: ReportStatus.selesai,
      catatanPetugas:
          'Pembersihan rutin pagi hari. Semua area sudah dibersihkan dengan baik.',
      catatanAdmin: 'Pekerjaan sangat baik, area terlihat bersih dan rapi.',
      imagePaths: [
        'https://images.unsplash.com/photo-1497366216548-37526070297c?w=300&h=200&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1497366811353-6870744d04b2?w=300&h=200&fit=crop&auto=format',
      ],
      areaId: 1,
      tasks: [
        CleaningTask(id: 1, description: 'Mengepel lantai', isCompleted: true),
        CleaningTask(
          id: 2,
          description: 'Membersihkan meja',
          isCompleted: true,
        ),
        CleaningTask(
          id: 3,
          description: 'Membersihkan komputer dan monitor',
          isCompleted: true,
        ),
        CleaningTask(id: 4, description: 'Menyapu lantai', isCompleted: true),
      ],
    ),
    Report(
      id: 2,
      title: 'Toilet Lantai 2',
      petugas: 'Siti Aminah',
      tanggal: '25-08-2025',
      status: ReportStatus.menunggu,
      catatanPetugas:
          'Pembersihan toilet selesai, namun ada keran yang bocor di wastafel.',
      imagePaths: [
        'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=300&h=200&fit=crop&auto=format',
      ],
      areaId: 2,
      tasks: [
        CleaningTask(
          id: 5,
          description: 'Mengepel lantai toilet',
          isCompleted: true,
        ),
        CleaningTask(
          id: 6,
          description: 'Membersihkan kloset duduk/jongkok',
          isCompleted: true,
        ),
        CleaningTask(
          id: 7,
          description: 'Membersihkan wastafel',
          isCompleted: true,
        ),
        CleaningTask(
          id: 8,
          description: 'Membersihkan cermin',
          isCompleted: true,
        ),
        CleaningTask(
          id: 9,
          description: 'Membersihkan dinding/keramik',
          isCompleted: false,
        ),
        CleaningTask(
          id: 10,
          description: 'Mengosongkan tempat sampah toilet',
          isCompleted: true,
        ),
        CleaningTask(
          id: 11,
          description: 'Mengosongkan tempat sampah toilet',
          isCompleted: true,
        ),
        CleaningTask(
          id: 12,
          description: 'Lainnya: Mengganti ulang sabun cuci tangan',
          isCompleted: false,
        ),
      ],
    ),
  ];

  static Map<String, int> get weeklySummary {
    final completed = reports
        .where((r) => r.status == ReportStatus.selesai)
        .length;
    final pending = reports
        .where((r) => r.status == ReportStatus.menunggu)
        .length;
    final rejected = reports
        .where((r) => r.status == ReportStatus.ditolak)
        .length;

    return {
      'selesai': completed,
      'menunggu': pending,
      'ditolak': rejected,
      'total': reports.length,
    };
  }
}
