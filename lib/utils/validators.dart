class Validators {
  static String? validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'Email tidak boleh kosong';
    if (!v.contains('@')) return 'Format email tidak valid';
    return null;
  }

  static String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password tidak boleh kosong';
    if (v.length < 6) return 'Password minimal 6 karakter';
    return null;
  }
}
