import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/transaction_model.dart';

class TransactionService {
  static const String baseUrl =
      'https://moneypocket-e2b90-default-rtdb.asia-southeast1.firebasedatabase.app';

  Future<List<TransactionModel>> getTransactions() async {
    final url = Uri.parse('$baseUrl/transactions.json');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data transaksi');
    }

    if (response.body == 'null') {
      return [];
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<TransactionModel> transactions = [];

    data.forEach((key, value) {
      transactions.add(
        TransactionModel.fromJson(
          key,
          Map<String, dynamic>.from(value),
        ),
      );
    });

    transactions.sort((a, b) => b.date.compareTo(a.date));

    return transactions;
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final url = Uri.parse('$baseUrl/transactions.json');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(transaction.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menambahkan transaksi');
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    final url = Uri.parse('$baseUrl/transactions/${transaction.id}.json');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(transaction.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui transaksi');
    }
  }

  Future<void> deleteTransaction(String id) async {
    final url = Uri.parse('$baseUrl/transactions/$id.json');

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus transaksi');
    }
  }
}