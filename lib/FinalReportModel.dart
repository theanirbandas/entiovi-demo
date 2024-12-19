import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'predictions.dart';

class DoctorReportDialog extends StatefulWidget {

  final Predictions? predictions;
  final String Physician_Name;
  final String patientName;
  final String patientDob;
  final double? patientWeight;
  final double est1;
  final double hcg;
  final double ms1Result;

  const DoctorReportDialog({super.key,
    this.predictions, 
    required this.Physician_Name,
    this.patientWeight,
    this.patientName = '', required this.patientDob, required this.est1, required this.hcg, required this.ms1Result,
  });

  @override
  State<DoctorReportDialog> createState() => _DoctorReportDialogState();
}

class _DoctorReportDialogState extends State<DoctorReportDialog> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate a 15-second loading period
    Timer(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Doctor\'s Report'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const CircularProgressIndicator(color: Colors.white)
            else
              Column(
                children: [
                  Container(
                    width: 600,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Doctor\'s Report',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          icon: Icons.person,
                          label: 'Doctor\'s Name',
                          value: widget.Physician_Name,
                          // value: widget.Physician_Name,
                        ),
                        _buildDetailRow(
                          icon: Icons.assignment_ind,
                          label: 'Patient Details',
                          value: widget.patientName,
                        ),
                        const Divider(color: Colors.white54),
                        _buildRiskRow('T181 Risk', widget.predictions?.data['T181']?.prediction.toStringAsFixed(0) ?? '', Icons.health_and_safety),
                        _buildRiskRow('ONTD1 Risk', widget.predictions?.data['SLOS1']?.prediction.toStringAsFixed(0) ?? '', Icons.warning),
                        _buildRiskRow('SLOS1 Risk', widget.predictions?.data['MS1']?.prediction.toStringAsFixed(0) ?? '', Icons.error),
                        _buildRiskRow('MS1 Risk', widget.predictions?.data['ONTD1']?.prediction.toStringAsFixed(0) ?? '', Icons.health_and_safety),
                        const SizedBox(height: 16),
                        const Text(
                          'Note: This report is for informational purposes only.',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFancyDownloadButton(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFancyDownloadButton() {
    return InkWell(
      onTap: _downloadReportAsPDF,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Download Report',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadReportAsPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Dr. ${widget.Physician_Name}',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text('Singleton Pregnancy', style: const pw.TextStyle(fontSize: 12)),
                pw.SizedBox(height: 8),
                pw.Divider(),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Patient: ${widget.patientName}', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('Age at EDD is: 30.6 (15-04-2019)', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('Weight: ${widget.patientWeight} Lbs', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('Birth Date: ${widget.patientDob}', style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Drawn (Rec): 13-11-2018', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('Report Date: 20-09-2024', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('Gestational Age: 18.1 weeks', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('By US: 18.1 weeks', style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Divider(),

                pw.Table(
                  border: pw.TableBorder.all(width: 0.5),
                  children: [
                    _buildTableRow('AFP', '${widget.ms1Result} ng/mL', '0.68 MoM'),
                    _buildTableRow('uE3', '${widget.est1} ng/mL', '0.69 MoM'),
                    _buildTableRow('hCG', '${widget.hcg} iu/mL', '0.72 MoM'),
                  ],
                ),
                pw.SizedBox(height: 8),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    _buildRiskBar('AFP MoM', '0.68', PdfColors.green),
                    _buildRiskBar('Down\'s Risk', '1:2200', PdfColors.orange),
                    _buildRiskBar('Trisomy 18 Risk', '<1:5000', PdfColors.green),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Divider(),

                pw.Text(
                  'OPEN NTD RISK ASSESSMENT',
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Risk of open spina bifida is <1:${widget.predictions?.data['T181']?.prediction.toStringAsFixed(0) ?? ''}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'DOWN SYNDROME RISK ASSESSMENT',
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Risk of Down Syndrome using age only is 1:${widget.predictions?.data['SLOS1']?.prediction.toStringAsFixed(0) ?? ''}\nRisk using age and biochemical markers is 1:${widget.predictions?.data['ONTD1']?.prediction.toStringAsFixed(0) ?? ''}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'TRISOMY 18 RISK ASSESSMENT',
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Calculated Risk of trisomy 18 is <1:${widget.predictions?.data['MS1']?.prediction.toStringAsFixed(0) ?? ''}',
                  style: const pw.TextStyle(fontSize: 10),
                ),

                pw.SizedBox(height: 16),
                pw.Text(
                  'Screen Negative',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  '***** AMENDED REPORT *****',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.red,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'patient_report.pdf',
    );
  }

  pw.Widget _buildRiskBar(String label, String value, PdfColor color) {
    return pw.Column(
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 4),
        pw.Container(
          width: 80,
          height: 10,
          color: color,
          alignment: pw.Alignment.center,
          child: pw.Text(value, style: const pw.TextStyle(fontSize: 8, color: PdfColors.white)),
        ),
      ],
    );
  }

  pw.TableRow _buildTableRow(String label, String value1, String value2) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(label, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(value1, style: const pw.TextStyle(fontSize: 10)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(value2, style: const pw.TextStyle(fontSize: 10)),
        ),
      ],
    );
  }


  //**************************************************************************************

  Widget _buildDetailRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskRow(String label, String level, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: _getRiskColor(level)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          Text(
            '1:$level',
            style: TextStyle(
              color: _getRiskColor(level),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRiskColor(String level) {
    switch (level) {
      case 'Low':
        return Colors.green;
      case 'Moderate':
        return Colors.orange;
      case 'High':
        return Colors.red;
      default:
        return Colors.white;
    }
  }
}
