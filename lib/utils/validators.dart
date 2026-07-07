class Validators {
  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }

    return null;
  }

  static String? amount(String? value) {
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

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password wajib diisi';
    }

    if (value.length < 4) {
      return 'Password minimal 4 karakter';
    }

    return null;
  }
}