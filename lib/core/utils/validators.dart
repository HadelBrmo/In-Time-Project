class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "يرجى إدخال البريد الإلكتروني";
    }
    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return "يرجى إدخال بريد إلكتروني صالح";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "يرجى إدخال كلمة المرور";
    }
    if (value.length < 8) {
      return "كلمة المرور يجب أن تكون 8 أحرف على الأقل";
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "يرجى تأكيد كلمة المرور";
    }
    if (value != password) {
      return "كلمات المرور غير متطابقة";
    }
    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "يرجى إدخال الاسم الثلاثي";
    }
    if (value.trim().split(' ').length < 3) {
      return "يرجى إدخال الاسم الثلاثي كاملاً";
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "يرجى إدخال $fieldName";
    }
    return null;
  }
}
