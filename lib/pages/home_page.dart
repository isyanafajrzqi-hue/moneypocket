import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../utils/app_colors.dart';
import 'login_page.dart';
import 'add_transaction_page.dart';
import 'detail_transaction_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<TransactionModel> transactions = [
    TransactionModel(
      id: '1',
      title: 'Uang Saku',
      type: 'Pemasukan',
      amount: 100000,
      date: '2026-07-07',
      note: 'Uang saku harian',
    ),
    TransactionModel(
      id: '2',
      title: 'Beli Kebab',
      type: 'Pengeluaran',
      amount: 15000,
      date: '2026-07-07',
      note: 'Makan malam',
    ),
    TransactionModel(
      id: '3',
      title: 'Beli Minum',
      type: 'Pengeluaran',
      amount: 8000,
      date: '2026-07-07',
      note: 'Es teh',
    ),
  ];

  double getTotalIncome() {
    double total = 0;

    for (final transaction in transactions) {
      if (transaction.type == 'Pemasukan') {
        total += transaction.amount;
      }
    }

    return total;
  }

  double getTotalExpense() {
    double total = 0;

    for (final transaction in transactions) {
      if (transaction.type == 'Pengeluaran') {
        total += transaction.amount;
      }
    }

    return total;
  }

  String formatRupiah(double amount) {
    final value = amount.toStringAsFixed(0);

    final result = value.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );

    return 'Rp$result';
  }

  void showAboutApp() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tentang PocketMoney'),
          content: const Text(
            'PocketMoney adalah aplikasi catatan keuangan harian berbasis Flutter. '
            'Aplikasi ini membantu pengguna mencatat pemasukan, pengeluaran, dan melihat saldo akhir.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  Future<void> goToAddTransaction() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AddTransactionPage(),
    ),
  );

  if (result != null && result is TransactionModel) {
    setState(() {
      transactions.insert(0, result);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transaksi berhasil ditambahkan'),
      ),
    );
  }
}
   Future<void> goToDetailTransaction(
  TransactionModel transaction,
  int index,
) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DetailTransactionPage(
        transaction: transaction,
        index: index,
      ),
    ),
  );

  if (result != null && result is Map<String, dynamic>) {
    if (result['action'] == 'delete') {
      setState(() {
        transactions.removeAt(result['index']);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaksi berhasil dihapus'),
        ),
      );
    }

    if (result['action'] == 'edit') {
      setState(() {
        transactions[result['index']] = result['transaction'];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaksi berhasil diperbarui'),
        ),
      );
    }
     }
    }   

  Widget summaryCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            formatRupiah(amount),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget transactionCard(TransactionModel transaction, int index) {
  final bool isIncome = transaction.type == 'Pemasukan';

  return GestureDetector(
    onTap: () {
      goToDetailTransaction(transaction, index);
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: isIncome
                ? Colors.green.withOpacity(0.12)
                : AppColors.primary.withOpacity(0.12),
            child: Icon(
              isIncome
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: isIncome ? Colors.green : AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${transaction.type} • ${transaction.date}',
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatRupiah(transaction.amount),
            style: TextStyle(
              color: isIncome ? Colors.green : AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final totalIncome = getTotalIncome();
    final totalExpense = getTotalExpense();
    final balance = totalIncome - totalExpense;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'PocketMoney',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: showAboutApp,
            icon: const Icon(Icons.info_outline),
          ),
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        children: [
          const Text(
            'Halo, Selamat Datang 👋',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Kelola pemasukan dan pengeluaran harianmu di sini.',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 22),

          summaryCard(
            title: 'Saldo Akhir',
            amount: balance,
            icon: Icons.account_balance_wallet_rounded,
            color: AppColors.primary,
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: summaryCard(
                  title: 'Pemasukan',
                  amount: totalIncome,
                  icon: Icons.arrow_downward_rounded,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: summaryCard(
                  title: 'Pengeluaran',
                  amount: totalExpense,
                  icon: Icons.arrow_upward_rounded,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Riwayat Transaksi',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${transactions.length} data',
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          for (int i = 0; i < transactions.length; i++)
            transactionCard(transactions[i], i),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToAddTransaction,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}