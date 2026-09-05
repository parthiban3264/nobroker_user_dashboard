class Validators {
  static String? validateEmail(String value) {
    final email = value.trim();

    if (email.isEmpty) {
      return null;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? validatePhone(String value) {
    if (value.isEmpty) {
      return null;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Only numbers are allowed';
    }

    if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }

    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return null;
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }
}
