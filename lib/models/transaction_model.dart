class TransactionModel {
  final String id;
  final String title;
  final String type;
  final double amount;
  final String date;
  final String note;

  TransactionModel({
    required this.id,
    required this.title,
    required this.type,
    required this.amount,
    required this.date,
    required this.note,
  });

  factory TransactionModel.fromJson(String id, Map<String, dynamic> json) {
    return TransactionModel(
      id: id,
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      date: json['date'] ?? '',
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'amount': amount,
      'date': date,
      'note': note,
    };
  }

  TransactionModel copyWith({
    String? id,
    String? title,
    String? type,
    double? amount,
    String? date,
    String? note,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }

  bool get isIncome => type == 'Pemasukan';

  bool get isExpense => type == 'Pengeluaran';
}