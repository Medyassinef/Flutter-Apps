import 'package:bmi_firebase/data/bmi_record.dart';
import 'package:bmi_firebase/data/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.bmiHistory)),
      body: StreamBuilder<List<BmiRecord>>(
        stream: firestoreService.getBmiRecords(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('${AppLocalizations.of(context)!.error}: ${snapshot.error}'));
          }

          final records = snapshot.data ?? [];

          if (records.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noRecordsFound));
          }

          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return Dismissible(
                key: Key(record.id!),
                background: Container(color: Colors.red),
                onDismissed: (direction) {
                  firestoreService.deleteBmiRecord(record.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)!.recordDeleted)),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text('${AppLocalizations.of(context)!.bmiCalculator}: ${record.bmi.toStringAsFixed(2)}'),
                    subtitle: Text(
                        '${record.weight.toStringAsFixed(1)} ${AppLocalizations.of(context)!.weightUnit}, ${record.height.toStringAsFixed(1)} ${AppLocalizations.of(context)!.heightUnit}\n${record.category}'),
                    trailing: Text(
                      DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(record.date),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}