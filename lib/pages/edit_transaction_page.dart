import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../utils/app_colors.dart';

class EditTransactionPage extends StatefulWidget {
  final TransactionModel transaction;
  final int index;

  const EditTransactionPage({
    super.key,
    required this.transaction,
    required this.index,
  });

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final noteController = TextEditingController();

  late String selectedType;

  @override
  void initState() {
    super.initState();

    titleController.text = widget.transaction.title;
    amountController.text = widget.transaction.amount.toStringAsFixed(0);
    dateController.text = widget.transaction.date;
    noteController.text = widget.transaction.note;
    selectedType = widget.transaction.type;
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    dateController.dispose();
    noteController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Judul transaksi wajib diisi';
    }

    return null;
  }

  String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nominal wajib diisi';
    }

    final amount = double.tryParse(value.trim());

    if (amount == null) {
      return 'Nominal harus berupa angka';
    }

    if (amount <= 0) {
      return 'Nominal harus lebih dari 0';
    }

    return null;
  }

  Future<void> chooseDate() async {
    final currentDate = DateTime.tryParse(dateController.text) ?? DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = formatDate(pickedDate);
      });
    }
  }

  void saveEditTransaction() {
    if (formKey.currentState!.validate()) {
      final editedTransaction = TransactionModel(
        id: widget.transaction.id,
        title: titleController.text.trim(),
        type: selectedType,
        amount: double.parse(amountController.text.trim()),
        date: dateController.text.trim(),
        note: noteController.text.trim(),
      );

      Navigator.pop(context, {
        'action': 'edit',
        'index': widget.index,
        'transaction': editedTransaction,
      });
    }
  }

  InputDecoration inputStyle({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppColors.primary,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
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
          'Edit Transaksi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      validator: validateTitle,
                      decoration: inputStyle(
                        label: 'Judul Transaksi',
                        icon: Icons.title_rounded,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: inputStyle(
                        label: 'Jenis Transaksi',
                        icon: Icons.category_outlined,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Pemasukan',
                          child: Text('Pemasukan'),
                        ),
                        DropdownMenuItem(
                          value: 'Pengeluaran',
                          child: Text('Pengeluaran'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedType = value ?? 'Pengeluaran';
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: amountController,
                      validator: validateAmount,
                      keyboardType: TextInputType.number,
                      decoration: inputStyle(
                        label: 'Nominal',
                        icon: Icons.payments_outlined,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: dateController,
                      readOnly: true,
                      onTap: chooseDate,
                      decoration: inputStyle(
                        label: 'Tanggal',
                        icon: Icons.calendar_month_outlined,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: noteController,
                      maxLines: 4,
                      decoration: inputStyle(
                        label: 'Catatan',
                        icon: Icons.note_alt_outlined,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: saveEditTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}