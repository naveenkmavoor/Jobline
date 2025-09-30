import 'package:formz/formz.dart';

enum AgeValidationError { invalid }

class AgeValidation extends FormzInput<String, AgeValidationError> {
  const AgeValidation.pure([String value = '']) : super.pure(value);
  const AgeValidation.dirty([String value = '']) : super.dirty(value);

  @override
  AgeValidationError? validator(String? value) {
    return value != "" ? null : AgeValidationError.invalid;
  }
}
