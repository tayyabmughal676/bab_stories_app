extension StringExtension on String {
  /// Truncate a string if it's longer than [maxLength] and add an [ellipsis].
  String getShortString(int maxLength, [String ellipsis = "…"]) =>
      length > maxLength
          ? '${substring(0, maxLength - ellipsis.length)}$ellipsis'
          : this;

  String getShortStringWithoutDots(int maxLength, [String ellipsis = ""]) =>
      length > maxLength ? substring(0, maxLength - ellipsis.length) : this;

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  bool validateEmail() {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }

  bool validatePassword() {
    return RegExp(
        r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$")
        .hasMatch(this);
  }

  bool validatePhoneNumber() {
    return RegExp(
        r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)')
        .hasMatch(this);
  }

  bool validateUserName() {
    return RegExp(r"^[a-zA-Z-]{4,15}$").hasMatch(this);
  }
}
