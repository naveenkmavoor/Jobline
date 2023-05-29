import 'package:formz/formz.dart';

enum EmailValidationError { invalid, empty }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure([String value = '']) : super.pure(value);
  const Email.dirty([String value = '']) : super.dirty(value);

  static final _emailRegExp = RegExp(
    r"^[a-zA-Z][a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  @override
  EmailValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return EmailValidationError.empty;
    } else if (!_emailRegExp.hasMatch(value)) {
      return EmailValidationError.invalid;
    }
    return null;
  }
}

extension DisplayE on EmailValidationError {
  String text() {
    switch (this) {
      case EmailValidationError.empty:
        return 'Please enter an email';
      case EmailValidationError.invalid:
        return 'Please ensure the email entered is valid';
    }
  }
}
