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

  const DoctorReportDialog({super.key,
    this.predictions, 
    required this.Physician_Name,
    this.patientName = '',
  });
  @override
  _DoctorReportDialogState createState() => _DoctorReportDialogState();
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
        title: const Text('Doctor’s Report'),
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
                          'Doctor’s Report',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          icon: Icons.person,
                          label: 'Doctor’s Name',
                          value: widget.Physician_Name,
                          // value: widget.Physician_Name,
                        ),
                        _buildDetailRow(
                          icon: Icons.assignment_ind,
                          label: 'Patient Details',
                          value: widget.patientName,
                        ),
                        const Divider(color: Colors.white54),
                        _buildRiskRow('T181 Risk', 'Low', Icons.health_and_safety),
                        _buildRiskRow('ONTD1 Risk', 'Moderate', Icons.warning),
                        _buildRiskRow('SLOS1 Risk', 'High', Icons.error),
                        _buildRiskRow('MS1 Risk', 'Low', Icons.health_and_safety),
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


  ///--------------------------- report PDF   ---------------------------------------------


  // void _downloadReportAsPDF() async {
  //   final pdf = pw.Document();
  //
  //   pdf.addPage(
  //     pw.Page(
  //       pageFormat: PdfPageFormat.a4,
  //       build: (context) {
  //         return pw.Container(
  //           padding: pw.EdgeInsets.all(16),
  //           child: pw.Column(
  //             crossAxisAlignment: pw.CrossAxisAlignment.start,
  //             children: [
  //               // Header Section
  //               pw.Text(
  //                 'Doctor Report',
  //                 style: pw.TextStyle(
  //                   fontSize: 24,
  //                   fontWeight: pw.FontWeight.bold,
  //                   color: PdfColors.blue,
  //                 ),
  //               ),
  //               pw.SizedBox(height: 8),
  //               pw.Divider(),
  //
  //               // Patient Details
  //               pw.Text(
  //                 'Patient: Tiwari, Mrs. Nupur',
  //                 style: pw.TextStyle(fontSize: 14),
  //               ),
  //               pw.Text('Age at EDD: 30.6 (15-04-2019)', style: pw.TextStyle(fontSize: 14)),
  //               pw.Text('Weight: 59 kg', style: pw.TextStyle(fontSize: 14)),
  //               pw.Text('Birth Date: 18-08-1988', style: pw.TextStyle(fontSize: 14)),
  //               pw.Text('Gestational Age: 18.1 weeks', style: pw.TextStyle(fontSize: 14)),
  //               pw.Divider(),
  //
  //               // Risks Section
  //               pw.Row(
  //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   _buildRiskBox('AFP', '43.27 ng/mL', '0.68 MoM'),
  //                   _buildRiskBox('uE3', '1.00 ng/mL', '0.69 MoM'),
  //                   _buildRiskBox('hCG', '21.33 iu/mL', '0.72 MoM'),
  //                 ],
  //               ),
  //               pw.SizedBox(height: 16),
  //               pw.Row(
  //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   _buildRiskSummary('OSB Risk', '<1:5000', PdfColors.green),
  //                   _buildRiskSummary('Down’s Risk', '<1:2200', PdfColors.orange),
  //                   _buildRiskSummary('Trisomy 18 Risk', '<1:5000', PdfColors.red),
  //                 ],
  //               ),
  //               pw.SizedBox(height: 16),
  //               pw.Divider(),
  //
  //               // Risk Assessment Notes
  //               pw.Text(
  //                 'Risk Assessments',
  //                 style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
  //               ),
  //               pw.Text(
  //                 'Open NTD Risk: <1:5000',
  //                 style: pw.TextStyle(fontSize: 14, color: PdfColors.green),
  //               ),
  //               pw.Text(
  //                 'Down Syndrome Risk: Using age only - 1:686\nUsing age and biochemical markers - 1:2200',
  //                 style: pw.TextStyle(fontSize: 14, color: PdfColors.orange),
  //               ),
  //               pw.Text(
  //                 'Trisomy 18 Risk: <1:5000',
  //                 style: pw.TextStyle(fontSize: 14, color: PdfColors.red),
  //               ),
  //               pw.SizedBox(height: 16),
  //
  //               // Footer Note
  //               pw.Text(
  //                 'Note: This report is for informational purposes only.',
  //                 style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  //
  //   // Save or Share PDF
  //   await Printing.sharePdf(
  //     bytes: await pdf.save(),
  //     filename: 'enhanced_doctor_report.pdf',
  //   );
  // }




  // void _downloadReportAsPDF() async {
  //   final pdf = pw.Document();
  //
  //   pdf.addPage(
  //     pw.Page(
  //       pageFormat: PdfPageFormat.a4,
  //       build: (context) {
  //         return pw.Container(
  //           padding: const pw.EdgeInsets.all(16),
  //           child: pw.Column(
  //             crossAxisAlignment: pw.CrossAxisAlignment.start,
  //             children: [
  //               // Header Section
  //               pw.Text(
  //                 'Dr. Shalini Tewari (MBBS, MS)',
  //                 style: pw.TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: pw.FontWeight.bold,
  //                 ),
  //               ),
  //               pw.SizedBox(height: 4),
  //               pw.Text('Singleton Pregnancy', style: pw.TextStyle(fontSize: 14)),
  //               pw.SizedBox(height: 8),
  //               pw.Divider(),
  //
  //               // Patient Details
  //               pw.Row(
  //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   pw.Column(
  //                     crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                     children: [
  //                       pw.Text('Patient: Tiwari, Mrs. Nupur', style: pw.TextStyle(fontSize: 12)),
  //                       pw.Text('Age at EDD is: 30.6 (15-04-2019)', style: pw.TextStyle(fontSize: 12)),
  //                       pw.Text('Weight: 59 kg', style: pw.TextStyle(fontSize: 12)),
  //                       pw.Text('Birth Date: 18-08-1988', style: pw.TextStyle(fontSize: 12)),
  //                     ],
  //                   ),
  //                   pw.Column(
  //                     crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                     children: [
  //                       pw.Text('Drawn (Rec): 13-11-2018', style: pw.TextStyle(fontSize: 12)),
  //                       pw.Text('Report Date: 20-09-2024', style: pw.TextStyle(fontSize: 12)),
  //                       pw.Text('Gestational Age: 18.1 weeks', style: pw.TextStyle(fontSize: 12)),
  //                       pw.Text('By US: 18.1 weeks', style: pw.TextStyle(fontSize: 12)),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               pw.SizedBox(height: 8),
  //               pw.Divider(),
  //
  //               // Risk Factors Table
  //               pw.Table(
  //                 border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
  //                 children: [
  //                   pw.TableRow(
  //                     children: [
  //                       _buildCell('AFP', bold: true),
  //                       _buildCell('43.27 ng/mL'),
  //                       _buildCell('0.68 MoM'),
  //                     ],
  //                   ),
  //                   pw.TableRow(
  //                     children: [
  //                       _buildCell('uE3', bold: true),
  //                       _buildCell('1.00 ng/mL'),
  //                       _buildCell('0.69 MoM'),
  //                     ],
  //                   ),
  //                   pw.TableRow(
  //                     children: [
  //                       _buildCell('hCG', bold: true),
  //                       _buildCell('21.33 iu/mL'),
  //                       _buildCell('0.72 MoM'),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               pw.SizedBox(height: 16),
  //
  //               // Risk Summary Section
  //               pw.Row(
  //                 children: [
  //                   _buildRiskBar('AFP MoM', '0.68', PdfColors.green),
  //                   pw.SizedBox(width: 8),
  //                   _buildRiskBar('Down’s Risk', '1:2200', PdfColors.orange),
  //                   pw.SizedBox(width: 8),
  //                   _buildRiskBar('Trisomy 18 Risk', '<1:5000', PdfColors.green),
  //                 ],
  //               ),
  //               pw.SizedBox(height: 16),
  //
  //               // Risk Assessments Section
  //               pw.Text(
  //                 'Risk Assessments',
  //                 style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
  //               ),
  //               pw.Text('Risk of open spina bifida is <1:5000', style: pw.TextStyle(fontSize: 12)),
  //               pw.Text(
  //                 'Risk of Down Syndrome using age only is 1:686\nRisk using age and biochemical markers is 1:2200',
  //                 style: pw.TextStyle(fontSize: 12),
  //               ),
  //               pw.Text('Calculated Risk of trisomy 18 is <1:5000', style: pw.TextStyle(fontSize: 12)),
  //
  //               pw.SizedBox(height: 16),
  //               pw.Text(
  //                 'Screen Negative',
  //                 style: pw.TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: pw.FontWeight.bold,
  //                   color: PdfColors.green,
  //                 ),
  //               ),
  //               pw.SizedBox(height: 8),
  //               pw.Text(
  //                 '***** AMENDED REPORT *****',
  //                 style: pw.TextStyle(
  //                   fontSize: 12,
  //                   fontWeight: pw.FontWeight.bold,
  //                   color: PdfColors.red,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  //
  //   // Save or Share PDF
  //   await Printing.sharePdf(
  //     bytes: await pdf.save(),
  //     filename: 'patient_report.pdf',
  //   );
  // }
//
//
//
//
//
//   pw.Widget _buildRiskBar(String label, String value, PdfColor color) {
//     return pw.Column(
//       children: [
//         pw.Text(label, style: pw.TextStyle(fontSize: 10)),
//         pw.SizedBox(height: 4),
//         pw.Container(
//           width: 80,
//           height: 10,
//           color: color,
//           alignment: pw.Alignment.center,
//           child: pw.Text(value, style: pw.TextStyle(fontSize: 8, color: PdfColors.white)),
//         ),
//       ],
//     );
//   }
//
//   pw.TableRow _buildTableRow(String label, String value1, String value2) {
//     return pw.TableRow(
//       children: [
//         pw.Padding(
//           padding: const pw.EdgeInsets.all(4),
//           child: pw.Text(label, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
//         ),
//         pw.Padding(
//           padding: const pw.EdgeInsets.all(4),
//           child: pw.Text(value1, style: pw.TextStyle(fontSize: 10)),
//         ),
//         pw.Padding(
//           padding: const pw.EdgeInsets.all(4),
//           child: pw.Text(value2, style: pw.TextStyle(fontSize: 10)),
//         ),
//       ],
//     );
//   }
//
//
//   pw.Widget _buildRiskBar(String label, String value, PdfColor color) {
//     return pw.Column(
//       children: [
//         pw.Text(label, style: pw.TextStyle(fontSize: 12)),
//         pw.SizedBox(height: 4),
//         pw.Container(
//           width: 100,
//           height: 20,
//           color: color,
//           alignment: pw.Alignment.center,
//           child: pw.Text(value, style: pw.TextStyle(fontSize: 10, color: PdfColors.white)),
//         ),
//       ],
//     );
//   }
//
//   pw.Widget _buildCell(String text, {bool bold = false}) {
//     return pw.Padding(
//       padding: const pw.EdgeInsets.all(4),
//       child: pw.Text(
//         text,
//         style: pw.TextStyle(fontSize: 12, fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal),
//       ),
//     );
//   }
//
// // Helper for Risk Box
//   pw.Widget _buildRiskBox(String title, String value, String mom) {
//     return pw.Container(
//       width: 100,
//       padding: pw.EdgeInsets.all(8),
//       decoration: pw.BoxDecoration(
//         color: PdfColors.blueGrey50,
//         borderRadius: pw.BorderRadius.circular(8),
//       ),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             title,
//             style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
//           ),
//           pw.Text(value, style: pw.TextStyle(fontSize: 12)),
//           pw.Text('MoM: $mom', style: pw.TextStyle(fontSize: 12, color: PdfColors.grey)),
//         ],
//       ),
//     );
//   }
//
// // Helper for Risk Summary
//   pw.Widget _buildRiskSummary(String label, String value, PdfColor color) {
//     return pw.Container(
//       padding: pw.EdgeInsets.all(8),
//       child: pw.Row(
//         children: [
//           pw.Container(
//             width: 10,
//             height: 10,
//             decoration: pw.BoxDecoration(
//               color: color,
//               shape: pw.BoxShape.circle,
//             ),
//           ),
//           pw.SizedBox(width: 8),
//           pw.Text(
//             '$label: $value',
//             style: pw.TextStyle(fontSize: 14),
//           ),
//         ],
//       ),
//     );
//   }

  // void _downloadReportAsPDF() async {
  //   final pdf = pw.Document();
  //
  //   pdf.addPage(
  //     pw.Page(
  //       pageFormat: PdfPageFormat.a4,
  //       build: (context) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Text(' Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
  //             pw.SizedBox(height: 16),
  //             pw.Text('Doctor Name: Dr. John Doe'),
  //             pw.Text('Patient Details: Jane Doe, Age 30'),
  //             pw.Divider(),
  //             pw.Text('T181 Risk: Low'),
  //             pw.Text('ONTD1 Risk: Moderate'),
  //             pw.Text('SLOS1 Risk: High'),
  //             pw.Text('MS1 Risk: Low'),
  //             pw.SizedBox(height: 16),
  //             pw.Text(
  //               'Note: This report is for informational purposes only.',
  //               style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  //
  //
  //
  //
  //
  //   await Printing.sharePdf(
  //     bytes: await pdf.save(),
  //     filename: 'doctor_report.pdf',
  //   );
  // }



  // void _downloadReportAsPDF() async {
  //   final pdf = pw.Document();
  //
  //   pdf.addPage(
  //     pw.Page(
  //       pageFormat: PdfPageFormat.a4,
  //       build: (context) {
  //         return pw.Container(
  //           padding: const pw.EdgeInsets.all(16),
  //           child: pw.Column(
  //             crossAxisAlignment: pw.CrossAxisAlignment.start,
  //             children: [
  //               // Header Section
  //               pw.Text(
  //                 'Dr. Shalini Tewari (MBBS, MS)',
  //                 style: pw.TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: pw.FontWeight.bold,
  //                 ),
  //               ),
  //               pw.SizedBox(height: 4),
  //               pw.Text('Singleton Pregnancy', style: pw.TextStyle(fontSize: 12)),
  //               pw.SizedBox(height: 8),
  //               pw.Divider(),
  //
  //               // Patient Details
  //               pw.Row(
  //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   pw.Column(
  //                     crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                     children: [
  //                       pw.Text('Patient: Tiwari, Mrs. Nupur', style: pw.TextStyle(fontSize: 10)),
  //                       pw.Text('Age at EDD is: 30.6 (15-04-2019)', style: pw.TextStyle(fontSize: 10)),
  //                       pw.Text('Weight: 59 kg', style: pw.TextStyle(fontSize: 10)),
  //                       pw.Text('Birth Date: 18-08-1988', style: pw.TextStyle(fontSize: 10)),
  //                     ],
  //                   ),
  //                   pw.Column(
  //                     crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                     children: [
  //                       pw.Text('Drawn (Rec): 13-11-2018', style: pw.TextStyle(fontSize: 10)),
  //                       pw.Text('Report Date: 20-09-2024', style: pw.TextStyle(fontSize: 10)),
  //                       pw.Text('Gestational Age: 18.1 weeks', style: pw.TextStyle(fontSize: 10)),
  //                       pw.Text('By US: 18.1 weeks', style: pw.TextStyle(fontSize: 10)),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               pw.SizedBox(height: 8),
  //               pw.Divider(),
  //
  //               // Table Section
  //               pw.Table(
  //                 border: pw.TableBorder.all(width: 0.5),
  //                 children: [
  //                   _buildTableRow('AFP', '43.27 ng/mL', '0.68 MoM'),
  //                   _buildTableRow('uE3', '1.00 ng/mL', '0.69 MoM'),
  //                   _buildTableRow('hCG', '21.33 iu/mL', '0.72 MoM'),
  //                 ],
  //               ),
  //               pw.SizedBox(height: 8),
  //
  //               // Risk Bar Section
  //               pw.Row(
  //                 mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
  //                 children: [
  //                   _buildRiskBar('AFP MoM', '0.68', PdfColors.green),
  //                   _buildRiskBar('Down’s Risk', '1:2200', PdfColors.orange),
  //                   _buildRiskBar('Trisomy 18 Risk', '<1:5000', PdfColors.green),
  //                 ],
  //               ),
  //               pw.SizedBox(height: 8),
  //               pw.Divider(),
  //
  //               // Risk Assessment Section
  //               pw.Text(
  //                 'OPEN NTD RISK ASSESSMENT',
  //                 style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
  //               ),
  //               pw.Text(
  //                 'Risk of open spina bifida is <1:5000',
  //                 style: pw.TextStyle(fontSize: 10),
  //               ),
  //               pw.SizedBox(height: 8),
  //               pw.Text(
  //                 'DOWN SYNDROME RISK ASSESSMENT',
  //                 style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
  //               ),
  //               pw.Text(
  //                 'Risk of Down Syndrome using age only is 1:686\nRisk using age and biochemical markers is 1:2200',
  //                 style: pw.TextStyle(fontSize: 10),
  //               ),
  //               pw.SizedBox(height: 8),
  //               pw.Text(
  //                 'TRISOMY 18 RISK ASSESSMENT',
  //                 style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
  //               ),
  //               pw.Text(
  //                 'Calculated Risk of trisomy 18 is <1:5000',
  //                 style: pw.TextStyle(fontSize: 10),
  //               ),
  //
  //               pw.SizedBox(height: 16),
  //               pw.Text(
  //                 'Screen Negative',
  //                 style: pw.TextStyle(
  //                   fontSize: 12,
  //                   fontWeight: pw.FontWeight.bold,
  //                   color: PdfColors.green,
  //                 ),
  //               ),
  //               pw.SizedBox(height: 8),
  //               pw.Text(
  //                 '***** AMENDED REPORT *****',
  //                 style: pw.TextStyle(
  //                   fontSize: 12,
  //                   fontWeight: pw.FontWeight.bold,
  //                   color: PdfColors.red,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  //
  //   // Save or Share PDF
  //   await Printing.sharePdf(
  //     bytes: await pdf.save(),
  //     filename: 'patient_report.pdf',
  //   );
  // }
  //
  // pw.Widget _buildRiskBar(String label, String value, PdfColor color) {
  //   return pw.Column(
  //     children: [
  //       pw.Text(label, style: pw.TextStyle(fontSize: 10)),
  //       pw.SizedBox(height: 4),
  //       pw.Container(
  //         width: 80,
  //         height: 10,
  //         color: color,
  //         alignment: pw.Alignment.center,
  //         child: pw.Text(value, style: pw.TextStyle(fontSize: 8, color: PdfColors.white)),
  //       ),
  //     ],
  //   );
  // }
  //
  // pw.TableRow _buildTableRow(String label, String value1, String value2) {
  //   return pw.TableRow(
  //     children: [
  //       pw.Padding(
  //         padding: const pw.EdgeInsets.all(4),
  //         child: pw.Text(label, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
  //       ),
  //       pw.Padding(
  //         padding: const pw.EdgeInsets.all(4),
  //         child: pw.Text(value1, style: pw.TextStyle(fontSize: 10)),
  //       ),
  //       pw.Padding(
  //         padding: const pw.EdgeInsets.all(4),
  //         child: pw.Text(value2, style: pw.TextStyle(fontSize: 10)),
  //       ),
  //     ],
  //   );
  // }




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
                  'Dr. Shalini Tewari (MBBS, MS)',
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
                        pw.Text('Patient: Tiwari, Mrs. Nupur', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('Age at EDD is: 30.6 (15-04-2019)', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('Weight: 59 kg', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('Birth Date: 18-08-1988', style: const pw.TextStyle(fontSize: 10)),
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
                    _buildTableRow('AFP', '43.27 ng/mL', '0.68 MoM'),
                    _buildTableRow('uE3', '1.00 ng/mL', '0.69 MoM'),
                    _buildTableRow('hCG', '21.33 iu/mL', '0.72 MoM'),
                  ],
                ),
                pw.SizedBox(height: 8),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    _buildRiskBar('AFP MoM', '0.68', PdfColors.green),
                    _buildRiskBar('Down’s Risk', '1:2200', PdfColors.orange),
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
                  'Risk of open spina bifida is <1:5000',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'DOWN SYNDROME RISK ASSESSMENT',
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Risk of Down Syndrome using age only is 1:686\nRisk using age and biochemical markers is 1:2200',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'TRISOMY 18 RISK ASSESSMENT',
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Calculated Risk of trisomy 18 is <1:5000',
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
            level,
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
