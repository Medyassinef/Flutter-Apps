import 'package:bmi_firebase/data/bmi_record.dart';
import 'package:bmi_firebase/data/firestore_service.dart';
import 'package:bmi_firebase/widgets/bmi_gauge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BmiCalculator extends StatefulWidget {
  const BmiCalculator({super.key});

  @override
  _BmiCalculatorState createState() => _BmiCalculatorState();
}

class _BmiCalculatorState extends State<BmiCalculator> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _info = "Report your data";
  double _bmiValue = 0.0;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _resetFields() {
    _heightController.clear();
    _weightController.clear();
    setState(() {
      _info = AppLocalizations.of(context)!.reportYourData;
      _bmiValue = 0.0;
    });
  }

  Future<void> _calculate() async {
    if (_formKey.currentState!.validate()) {
      final weight = double.parse(_weightController.text);
      final height = double.parse(_heightController.text) / 100;
      final bmi = weight / (height * height);
      final category = _getBmiCategory(bmi);

      setState(() {
        _bmiValue = bmi;
        _info = "$category (${bmi.toStringAsPrecision(4)})";
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final record = BmiRecord(
          userId: user.uid,
          weight: weight,
          height: height * 100, // Store in cm
          bmi: bmi,
          category: category,
          date: DateTime.now(),
        );

        await _firestoreService.addBmiRecord(record);
      }
    }
  }

  String _getBmiCategory(double bmi) {
    if (bmi < 18.6) return AppLocalizations.of(context)!.belowWeight;
    if (bmi < 24.9) return AppLocalizations.of(context)!.idealWeight;
    if (bmi < 29.9) return AppLocalizations.of(context)!.slightlyOverweight;
    if (bmi < 34.9) return AppLocalizations.of(context)!.obesityGrade1;
    if (bmi < 39.9) return AppLocalizations.of(context)!.obesityGrade2;
    return AppLocalizations.of(context)!.obesityGrade3;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.person, size: 120.0, color: Colors.green),
            const SizedBox(height: 20),
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: "${AppLocalizations.of(context)!.weight} (${AppLocalizations.of(context)!.weightUnit})",
                border: const OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, color: Colors.green),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.pleaseEnterWeight;
                }
                if (double.tryParse(value) == null) {
                  return AppLocalizations.of(context)!.pleaseEnterValidNumber;
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _heightController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: "${AppLocalizations.of(context)!.height} (${AppLocalizations.of(context)!.heightUnit})",
                border: const OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, color: Colors.green),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.pleaseEnterHeight;
                }
                if (double.tryParse(value) == null) {
                  return AppLocalizations.of(context)!.pleaseEnterValidNumber;
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(AppLocalizations.of(context)!.calculateBmi, style: const TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            BmiGauge(bmiValue: _bmiValue),
            const SizedBox(height: 20),
            Text(
              _info,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, color: Colors.green),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: _resetFields,
              child: Text(AppLocalizations.of(context)!.reset),
            ),
          ],
        ),
      ),
    );
  }
}