import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

class PDFService {
  static Future<pw.Document> generateWeeklyReportPDF({
    required Map<String, dynamic> weeklyData,
  }) async {
    final pdf = pw.Document();

    // Load BPS Logo
    Uint8List? logoBytes;
    try {
      final ByteData logoData = await rootBundle.load(
        'assets/images/bpsLogo.png',
      );
      logoBytes = logoData.buffer.asUint8List();
    } catch (e) {
      print('Logo not found: $e');
    }

    final period = weeklyData['period'];
    final summary = weeklyData['summary'];
    final assignments = weeklyData['assignments'] as List;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return [
            // Header dengan Logo
            _buildHeader(logoBytes, period),
            pw.SizedBox(height: 20),

            // Summary
            _buildSummary(summary),
            pw.SizedBox(height: 20),

            // Tabel Laporan Mingguan
            _buildWeeklyAssignmentsTable(assignments),

            pw.SizedBox(height: 30),

            // Footer
            _buildFooter(),
          ];
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeader(
    Uint8List? logoBytes,
    Map<String, dynamic> period,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Logo
        if (logoBytes != null)
          pw.Container(
            width: 60,
            height: 60,
            child: pw.Image(pw.MemoryImage(logoBytes)),
          ),
        pw.SizedBox(width: 20),

        // Header Text
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'BPS KOTA SUKABUMI',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
              pw.Text(
                'Sistem Manajemen Kebersihan',
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'LAPORAN KEBERSIHAN MINGGUAN',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                period['period_text'],
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
              ),
              pw.Text(
                '${period['start_date']} s/d ${period['end_date']}',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
              ),
            ],
          ),
        ),

        // Tanggal Export
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'Tanggal Export:',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
            pw.Text(
              _formatDate(DateTime.now()),
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildSummary(Map<String, dynamic> summary) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'RINGKASAN MINGGUAN',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              _buildSummaryItem(
                'Total Assignment',
                summary['total_assignments'].toString(),
                PdfColors.blue,
              ),
              pw.SizedBox(width: 25),
              _buildSummaryItem(
                'Selesai',
                summary['completed'].toString(),
                PdfColors.green,
              ),
              pw.SizedBox(width: 25),
              _buildSummaryItem(
                'Pending',
                summary['pending'].toString(),
                PdfColors.orange,
              ),
              pw.SizedBox(width: 25),
              _buildSummaryItem(
                'Terlewat',
                summary['missed'].toString(),
                PdfColors.red,
              ),
              pw.SizedBox(width: 25),
              _buildSummaryItem(
                'Tingkat Selesai',
                '${summary['completion_rate']}%',
                PdfColors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(
    String label,
    String value,
    PdfColor color,
  ) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }

  static pw.Widget _buildWeeklyAssignmentsTable(List assignments) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'DAFTAR ASSIGNMENT MINGGUAN',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 10),

        if (assignments.isEmpty)
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            alignment: pw.Alignment.center,
            child: pw.Text(
              'Tidak ada data assignment',
              style: pw.TextStyle(color: PdfColors.grey600),
            ),
          )
        else
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            columnWidths: {
              0: const pw.FlexColumnWidth(0.7), // No
              1: const pw.FlexColumnWidth(2.5), // Petugas
              2: const pw.FlexColumnWidth(2.5), // Area
              3: const pw.FlexColumnWidth(2), // Tanggal
              4: const pw.FlexColumnWidth(1.5), // Status
              5: const pw.FlexColumnWidth(2), // Waktu Selesai
            },
            children: [
              // Header
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey100),
                children: [
                  _buildTableCell('No', isHeader: true),
                  _buildTableCell('Petugas', isHeader: true),
                  _buildTableCell('Area', isHeader: true),
                  _buildTableCell('Tanggal', isHeader: true),
                  _buildTableCell('Status', isHeader: true),
                  _buildTableCell('Waktu Selesai', isHeader: true),
                ],
              ),

              // Data Rows
              ...assignments.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> assignment = entry.value;

                return pw.TableRow(
                  children: [
                    _buildTableCell((index + 1).toString()),
                    _buildTableCell(assignment['user']['name'] ?? '-'),
                    _buildTableCell(assignment['area']['name'] ?? '-'),
                    _buildTableCell(
                      _formatDate(
                        DateTime.parse(assignment['assignment_date']),
                      ),
                    ),
                    _buildTableCell(
                      _getStatusText(assignment['status']),
                      color: _getStatusColor(assignment['status']),
                    ),
                    _buildTableCell(
                      assignment['report'] != null
                          ? _formatDateTime(
                              DateTime.parse(
                                assignment['report']['created_at'],
                              ),
                            )
                          : '-',
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
      ],
    );
  }

  static pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    PdfColor? color,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 9 : 8,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color ?? (isHeader ? PdfColors.black : PdfColors.grey800),
        ),
        textAlign: isHeader ? pw.TextAlign.center : pw.TextAlign.left,
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'Generated by BPS Cleaning System',
          style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
        ),
        pw.Text(
          'Dicetak pada ${_formatDateTime(DateTime.now())}',
          style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
        ),
      ],
    );
  }

  static String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'completed':
        return 'Selesai';
      case 'missed':
        return 'Terlewat';
      default:
        return status;
    }
  }

  static PdfColor _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return PdfColors.orange;
      case 'completed':
        return PdfColors.green;
      case 'missed':
        return PdfColors.red;
      default:
        return PdfColors.grey;
    }
  }

  static String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  static String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Method untuk menyimpan PDF ke storage
  static Future<String> savePDF(pw.Document pdf, String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  // Method untuk share PDF
  static Future<void> sharePDF(pw.Document pdf, String filename) async {
    await Printing.sharePdf(bytes: await pdf.save(), filename: '$filename.pdf');
  }

  // Method untuk print PDF
  static Future<void> printPDF(pw.Document pdf, String title) async {
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: title,
    );
  }
}
