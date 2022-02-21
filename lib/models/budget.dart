import 'package:cloud_firestore/cloud_firestore.dart';

class Budget {
  late DateTime startDate;
  late DateTime endDate;
  late Map<String, double> items;
  late double amount;
  late String notes;
  late double amountUsed;
  late double amountSaved;
  late bool hasItems;
  late String documentId;
  late List ledger;

  Budget({
    required this.startDate,
    required this.endDate,
    required this.amount,
    required this.items,
    required this.hasItems,
    required this.amountSaved,
    required this.amountUsed,
    required this.documentId,
    required this.ledger,
    required this.notes,
  });

  /// No argument constuctor
  Budget.noArgument() {
    startDate = DateTime.now();
    endDate = DateTime.now().add(const Duration(days: 7));
    amount = 0;
    items = {};
    notes = '';
    amountSaved = 0;
    amountUsed = 0;
    hasItems = false;
    documentId = '';
    ledger = [];
  }

  /// Formatting for upload to Firebase
  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'amount': amount,
      'notes': notes,
      'items': items,
      'amountUsed': amountUsed,
      'amountSaved': amountSaved,
      'hasItems': hasItems,
      'ledger': ledger,
    };
  }

  /// Creating a Trip object from a firebase snapshot
  Budget.fromSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;
    startDate = data['startDate'].toDate();
    endDate = data['endDate'].toDate();
    amount = data['amount'] ?? 0.0;
    notes = data['notes'] ?? '';
    items = Map<String, double>.from(data['items']);
    amountUsed = data['amountUsed'] ?? 0.0;
    amountSaved = data['amountSaved'] ?? 0.0;
    hasItems = data['hasItems'] ?? false;
    documentId = documentSnapshot.id;
    ledger = data['ledger'] ?? [];
  }

  /// Total days of the budget
  int getTotalDaysofBudget() {
    return endDate.difference(startDate).inDays;
  }

  updateLedger(String amount, String type) {
    double amountDouble = double.parse(amount);
    if (type == 'spent') {
      amountUsed = amountUsed + amountDouble;
    } else {
      amountSaved = amountSaved + amountDouble;
    }
    ledger.add({
      'date': DateTime.now(),
      'amountUsed': type == 'spent' ? amountDouble : 0,
      'amountSaved': type != 'spent' ? amountDouble : 0,
    });
  }
}
