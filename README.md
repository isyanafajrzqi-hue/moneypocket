# PocketMoney

PocketMoney adalah aplikasi catatan keuangan harian berbasis Flutter yang digunakan untuk mencatat pemasukan dan pengeluaran pengguna. Aplikasi ini membantu pengguna melihat saldo akhir, total pemasukan, total pengeluaran, serta riwayat transaksi harian.


## Fitur Aplikasi

- Splash screen
- Login sederhana dengan validasi input
- Dashboard keuangan
- Menampilkan saldo akhir
- Menampilkan total pemasukan
- Menampilkan total pengeluaran
- Menampilkan daftar transaksi
- Tambah transaksi
- Detail transaksi
- Edit transaksi
- Hapus transaksi
- Penyimpanan data menggunakan Firebase Realtime Database

## Teknologi yang Digunakan

- Flutter
- Dart
- Firebase Realtime Database
- REST API
- HTTP package
- Intl package

## Struktur Folder

```text
lib/
├── main.dart
│
├── models/
│   └── transaction_model.dart
│
├── pages/
│   ├── splash_page.dart
│   ├── login_page.dart
│   ├── home_page.dart
│   ├── add_transaction_page.dart
│   ├── detail_transaction_page.dart
│   └── edit_transaction_page.dart
│
├── services/
│   └── transaction_service.dart
│
├── utils/
│   ├── app_colors.dart
│   ├── currency_formatter.dart
│   └── validators.dart
│
└── widgets/
    ├── summary_card.dart
    └── transaction_card.dart