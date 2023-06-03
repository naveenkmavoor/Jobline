import 'package:formz/formz.dart';

enum GenderValidationError { invalid }

class GenderValidation extends FormzInput<String, GenderValidationError> {
  const GenderValidation.pure([String value = '']) : super.pure(value);
  const GenderValidation.dirty([String value = '']) : super.dirty(value);

  @override
  GenderValidationError? validator(String? value) {
    return value != "" ? null : GenderValidationError.invalid;
  }
}
