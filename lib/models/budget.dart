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
    this.startDate = DateTime.now();
    this.endDate = DateTime.now().add(Duration(days: 7));
    this.amount = 0;
    this.items = {};
    this.notes = '';
    this.amountSaved = 0;
    this.amountUsed = 0;
    this.hasItems = false;
    this.documentId = '';
    this.ledger = [];
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
    this.startDate = data['startDate'].toDate();
    this.endDate = data['endDate'].toDate();
    this.amount = data['amount'] ?? 0.0;
    this.notes = data['notes'] ?? '';
    this.items = Map<String, double>.from(data['items']);
    this.amountUsed = data['amountUsed'] ?? 0.0;
    this.amountSaved = data['amountSaved'] ?? 0.0;
    this.hasItems = data['hasItems'] ?? false;
    this.documentId = documentSnapshot.id;
    this.ledger = data['ledger'] ?? [];
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
