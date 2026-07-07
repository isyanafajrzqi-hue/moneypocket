import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../services/transaction_service.dart';
import '../utils/app_colors.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_card.dart';
import 'add_transaction_page.dart';
import 'detail_transaction_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TransactionService service = TransactionService();

  late Future<List<TransactionModel>> futureTransactions;

  @override
  void initState() {
    super.initState();
    futureTransactions = service.getTransactions();
  }

  Future<void> refreshTransactions() async {
    setState(() {
      futureTransactions = service.getTransactions();
    });

    await futureTransactions;
  }

  double getTotalIncome(List<TransactionModel> transactions) {
    double total = 0;

    for (final transaction in transactions) {
      if (transaction.isIncome) {
        total += transaction.amount;
      }
    }

    return total;
  }

  double getTotalExpense(List<TransactionModel> transactions) {
    double total = 0;

    for (final transaction in transactions) {
      if (transaction.isExpense) {
        total += transaction.amount;
      }
    }

    return total;
  }

  Future<void> goToAddTransaction() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTransactionPage(),
      ),
    );

    if (result == true) {
      await refreshTransactions();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaksi berhasil ditambahkan'),
        ),
      );
    }
  }

  Future<void> goToDetailTransaction(TransactionModel transaction) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailTransactionPage(
          transaction: transaction,
        ),
      ),
    );

    if (result == true) {
      await refreshTransactions();
    }
  }

  void showAboutApp() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tentang PocketMoney'),
          content: const Text(
            'PocketMoney adalah aplikasi catatan keuangan harian berbasis Flutter. '
            'Aplikasi ini menggunakan Firebase Realtime Database untuk menyimpan, '
            'menampilkan, mengedit, dan menghapus data transaksi.',
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

  Widget emptyTransactionView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            color: AppColors.textGrey,
            size: 52,
          ),
          const SizedBox(height: 12),
          const Text(
            'Belum ada transaksi',
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tambahkan pemasukan atau pengeluaran pertamamu.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: goToAddTransaction,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Tambah Transaksi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<TransactionModel>>(
        future: futureTransactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Terjadi kesalahan:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                  ),
                ),
              ),
            );
          }

          final transactions = snapshot.data ?? [];

          final totalIncome = getTotalIncome(transactions);
          final totalExpense = getTotalExpense(transactions);
          final balance = totalIncome - totalExpense;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: refreshTransactions,
            child: ListView(
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

                SummaryCard(
                  title: 'Saldo Akhir',
                  amount: balance,
                  icon: Icons.account_balance_wallet_rounded,
                  color: AppColors.primary,
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: 'Pemasukan',
                        amount: totalIncome,
                        icon: Icons.arrow_downward_rounded,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
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

                if (transactions.isEmpty)
                  emptyTransactionView()
                else
                  for (final transaction in transactions)
                    TransactionCard(
                      transaction: transaction,
                      onTap: () {
                        goToDetailTransaction(transaction);
                      },
                    ),
              ],
            ),
          );
        },
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