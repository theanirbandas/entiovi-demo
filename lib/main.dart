import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'FinalReportModel.dart';
import 'predictions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController PAT_WT = TextEditingController();
  final TextEditingController MULT_FETUS = TextEditingController();
  final TextEditingController GAGE_US1 = TextEditingController();
  final TextEditingController GAGE_US2 = TextEditingController();
  final TextEditingController MS1_RESULT = TextEditingController();
  final TextEditingController MS1_GEST = TextEditingController();
  final TextEditingController MS1_MATAGE = TextEditingController();
  final TextEditingController HCG1 = TextEditingController();
  final TextEditingController EST1 = TextEditingController();
  final TextEditingController INHA1 = TextEditingController();
  final TextEditingController RPT_GMETH = TextEditingController();

  final TextEditingController MaternalDOB = TextEditingController();
  final TextEditingController DateDrawn = TextEditingController();
  final TextEditingController DateRecived = TextEditingController();
  final TextEditingController DateTested = TextEditingController();

  final TextEditingController Physician_Name = TextEditingController();
  final TextEditingController PatenLast_Name = TextEditingController();
  final TextEditingController PatenFirst_Name = TextEditingController();
  final TextEditingController External_ID = TextEditingController();
  final TextEditingController Sample_ID = TextEditingController();

  List<Map<String, dynamic>> parameters2age = [];
  List<Map<String, dynamic>> parameters4LabTest = [];

  void callApiService(BuildContext context) async {
    final dio = Dio();
    final apiService = ApiService(dio);

    final request = PredictionRequest(
      PAT_WT: double.tryParse(PAT_WT.text) ?? 0, //154.32,
      // MULT_FETUS: 1,
      // GAGE_US: 20.3,
      // MS1_RESULT: 54,
      // MS1_GEST: 20.39,
      // MS1_MATAGE: 19,
      // HCG1: 10.5,
      // EST1: 4.3,
      // INHA1: 0,
      // RPT_GMETH: "U",
      MULT_FETUS: double.tryParse(MULT_FETUS.text) ?? 0,
      GAGE_US: double.tryParse(GAGE_US2.text.trim().isNotEmpty ? GAGE_US2.text.trim() : GAGE_US1.text.trim()) ?? 0,
      MS1_RESULT: double.tryParse(MS1_RESULT.text) ?? 0,
      MS1_GEST: double.tryParse(MS1_GEST.text) ?? 0,
      MS1_MATAGE: double.tryParse(MS1_MATAGE.text) ?? 0,
      HCG1: double.tryParse(HCG1.text) ?? 0,
      EST1: double.tryParse(EST1.text) ?? 0,
      INHA1: double.tryParse(INHA1.text) ?? 0,
      RPT_GMETH: GAGE_US2.text.trim().isNotEmpty ? 'U' : 'l',
    );

    print(PatenFirst_Name);
    try {
      final response = await apiService.getPrediction(request);
      // response.data[]
      print("Predictions: ${response.data}");

      showDialog(
        context: context,
        builder: (context) => DoctorReportDialog(
          predictions: response,
          Physician_Name: Physician_Name.text,
          patientName: '${PatenFirst_Name.text} ${PatenLast_Name.text}',
          patientDob: MaternalDOB.text,
          patientWeight: double.tryParse(PAT_WT.text) ?? 0,
          hcg: double.tryParse(HCG1.text) ?? 0,
          est1: double.tryParse(EST1.text) ?? 0,
          ms1Result: double.tryParse(MS1_RESULT.text) ?? 0,
        ),
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    parameters2age = [
      {'label2': 'LMP on', 'hint2': 'Enter LMP', 'controller': GAGE_US1, "RPT_GMETH": "l"},
      {'label2': 'U/S', 'hint2': 'Enter U/S', 'controller': GAGE_US2, "RPT_GMETH": "U"},
    ];

    parameters4LabTest = [
      {'label2': 'hCG result', 'hint2': 'Enter your hCG result in iu/ml', 'unit': 'iu/ml', 'controller': HCG1},
      {'label2': 'uE3 result', 'hint2': 'Enter your uE3 result in ng/ml', 'unit': 'ng/ml', 'controller': EST1},
      {'label2': 'INH-A result', 'hint2': 'Enter your INH-A result in gh/ml', 'unit': 'gh/ml', 'controller': INHA1},
      {'label2': 'MS1 result', 'hint2': 'Enter your MS1 result in gh/ml', 'unit': 'gh/ml', 'controller': MS1_RESULT},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Professional Layout Inspired by Windows 11',
      theme: ThemeData(
        primaryColor: Colors.blueAccent, // Light grey background
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Segoe UI', fontSize: 16, color: Colors.black87),
          titleLarge:
              TextStyle(fontFamily: 'Segoe UI', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueAccent),
          // button: TextStyle(fontFamily: 'Segoe UI', fontSize: 16, fontWeight: FontWeight.bold),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(background: const Color(0xFFF3F4F6))
            .copyWith(secondary: Colors.blueAccent),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFFF3F4F6), // Light grey background
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Container (Form)
                      Flexible(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: FormLayout(
                            physicianName: Physician_Name,
                            patientFirstName: PatenFirst_Name,
                            patientLastName: PatenLast_Name,
                            patientDob: MaternalDOB,
                            weightController: PAT_WT,
                            multFetusController: MULT_FETUS,
                            ms1GestController: MS1_GEST,
                            ms1MatageController: MS1_MATAGE,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      // Right Containers (Age Calculation and Test Results)
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Age Calculation Card
                            Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Age Calculation',
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 16),
                                    // Loop through parameters2age list
                                    ...parameters2age.map((param) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: StylishTextField(
                                          controller: param['controller'],
                                          label: param['label2']!,
                                          hint: param['hint2']!,
                                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Test Results Card
                            Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Test Results',
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 16),
                                    // Loop through parameters4LabTest list
                                    ...parameters4LabTest.map((param) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: StylishTextField(
                                          controller: param['controller'],
                                          label: param['label2']!,
                                          hint: param['hint2']!,
                                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),],
                                        ),
                                      );
                                    }),

                                    // Adding Date Pickers for each test result in one row
                                    const SizedBox(height: 16),
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: DatePickerField(label: 'Test 1 Date')),
                                        SizedBox(width: 8),
                                        Expanded(child: DatePickerField(label: 'Test 2 Date')),
                                        SizedBox(width: 8),
                                        Expanded(child: DatePickerField(label: 'Test 3 Date')),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton.extended(
            onPressed: () {
              callApiService(context);

              // Implement your submission functionality here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Form Submitted!')),
              );
            },
            label: const Text('Submit'),
            icon: const Icon(Icons.send),
            backgroundColor: Colors.blueAccent,
          );
        }),
      ),
    );
  }
}

// Form Widget
class FormLayout extends StatefulWidget {
  final TextEditingController physicianName;
  final TextEditingController patientFirstName;
  final TextEditingController patientLastName;
  final TextEditingController? patientDob;
  final TextEditingController? weightController;
  final TextEditingController? multFetusController;
  final TextEditingController? ms1GestController;
  final TextEditingController? ms1MatageController;

  const FormLayout({
    super.key,
    required this.physicianName,
    required this.patientFirstName,
    required this.patientLastName,
    this.patientDob,
    this.weightController,
    this.multFetusController,
    this.ms1GestController,
    this.ms1MatageController,
  });

  @override
  State<FormLayout> createState() => _FormLayoutState();
}

class _FormLayoutState extends State<FormLayout> {

  void _showDatepicker(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context, 
      firstDate: DateTime.now().subtract(const Duration(days: 365*100)), 
      lastDate: DateTime.now().subtract(const Duration(days: 365*14))
    );

    if (date != null) {
      widget.patientDob?.text = DateFormat('dd-MM-yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StylishTextField(label: 'External ID:'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: StylishTextField(
                label: 'Last name:',
                controller: widget.patientLastName,
              )),
              const SizedBox(width: 16),
              Expanded(
                  child: StylishTextField(
                label: 'First name:',
                controller: widget.patientFirstName,
              )),
            ],
          ),
          const SizedBox(height: 16),
          StylishDropdown(
            label: '1st physician:',
            onChanged: (value) => widget.physicianName.text = value ?? '',
          ),
          const SizedBox(height: 16),
          StylishTextField(
            label: 'Maternal D.O.B:',
            controller: widget.patientDob,
            readOnly: true,
            onTap: () => _showDatepicker(context),
          ),
          const SizedBox(height: 16),
          const StylishDropdown(label: 'Race:'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StylishTextField(
                  controller: widget.weightController,
                  label: 'Weight:',
                  hint: '0',
                  suffix: 'Lbs',
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StylishTextField(
                  controller: widget.multFetusController,
                  label: 'Mult. of preg:',
                  hint: '1',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Column(
            children: [
              StylishCheckbox(label: 'Diabetic'),
              StylishCheckbox(label: 'Smoker'),
              StylishCheckbox(label: 'Family hist ONTD'),
            ],
          ),
          const SizedBox(height: 20),
          Text('Tests to do:', style: Theme.of(context).textTheme.bodyLarge),
          const Row(
            children: [
              StylishCheckbox(label: 'AFP'),
              StylishCheckbox(label: 'hCG'),
              StylishCheckbox(label: 'uE3'),
              StylishCheckbox(label: 'INH-A'),
            ],
          ),
          const SizedBox(height: 16),
          const StylishCheckbox(label: 'Do EDS assessment'),
          const SizedBox(height: 16),
          StylishTextField(
            label: 'MS1 GEST',
            controller: widget.ms1GestController,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),],
          ),
          const SizedBox(height: 16),
          StylishTextField(
            label: 'MS1 MATAGE',
            controller: widget.ms1MatageController,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// Reusable Widgets
class StylishTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? initialValue;
  final String? hint;
  final String? suffix;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool? readOnly;
  final VoidCallback? onTap;

  const StylishTextField({
    super.key,
    this.controller,
    required this.label,
    this.initialValue,
    this.hint,
    this.suffix,
    this.maxLines = 1,
    this.inputFormatters,
    this.readOnly,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                spreadRadius: 0,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: controller,
            initialValue: initialValue,
            maxLines: maxLines,
            inputFormatters: inputFormatters,
            readOnly: readOnly ?? false,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hint,
              suffixText: suffix,
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class StylishDropdown extends StatelessWidget {
  final String label;
  final void Function(String?)? onChanged;

  const StylishDropdown({super.key, required this.label, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                spreadRadius: 0,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
            ),
            items: const [
              DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
              DropdownMenuItem(value: 'Option 2', child: Text('Option 2')),
            ],
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class StylishCheckbox extends StatelessWidget {
  final String label;

  const StylishCheckbox({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: false,
          onChanged: (value) {},
          activeColor: Colors.blueAccent,
        ),
        Text(label),
      ],
    );
  }
}

class DatePickerField extends StatelessWidget {
  final String label;

  const DatePickerField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 0)],
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select date', style: TextStyle(color: Colors.grey)),
                Icon(Icons.calendar_today, color: Colors.blueAccent),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
