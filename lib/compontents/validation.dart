String? validateEmail(String? value) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);

  if (value!.isEmpty) {
    return "Enter an Email Address";
  }
  return !regex.hasMatch(value) ? 'Enter a valid Email Address' : null;
}

String? validatePassword(String? value) {
  // ignore: unused_local_variable
  const patternWhole =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  const patternCase = r'^(?=.*?[A-Z])(?=.*?[a-z])';
  const patternNumerical = r'^(?=.*?[0-9])';
  const patternSpecical = r'^(?=.*?[!@#\$&*~]).{8,}$';
  final regexC = RegExp(patternCase);
  final regexN = RegExp(patternNumerical);
  final regexS = RegExp(patternSpecical);
  if (value!.isEmpty) {
    return "Enter a Password";
  }
  if (value.length < 8) {
    return "Password must be atleast 8 charcters long";
  }
  if (!regexC.hasMatch(value)) {
    return "Password must contain 1 uppercase & 1 lowercase letter";
  }
  if (!regexN.hasMatch(value)) {
    return "Password must contain 1 Numeric";
  }
  if (!regexS.hasMatch(value)) {
    return "Password must contain 1 Special Character ( ! @ # \$ & * ~ )";
  }
  return null;
}

String? validateText(String? value) {
  const pattern = r'^[a-zA-Z\ -]+$';
  final regex = RegExp(pattern);

  if (value!.isEmpty) {
    return "Enter Some Text";
  }
  return !regex.hasMatch(value) ? 'Enter Text Only' : null;
}

String? validateTextAndNumber(String? value) {
  const pattern = r'^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/? ]+$';
  final regex = RegExp(pattern);

  if (value!.isEmpty) {
    return "Enter Something";
  }
  return !regex.hasMatch(value) ? 'Enter Text & Numbers Only' : null;
}

String? validateNumber(String? value) {
  const pattern = r'^(?=.*?[0-9])';
  final regex = RegExp(pattern);

  if (value!.isEmpty) {
    return "Enter Some Numbers";
  }
  return !regex.hasMatch(value) ? 'Enter Numbers Only' : null;
}
