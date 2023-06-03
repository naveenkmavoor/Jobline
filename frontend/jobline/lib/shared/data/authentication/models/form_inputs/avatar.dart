import 'package:formz/formz.dart';

enum AvatarValidationError { invalid }

class AvatarValidation extends FormzInput<String, AvatarValidationError> {
  const AvatarValidation.pure([String value = '']) : super.pure(value);
  const AvatarValidation.dirty([String value = '']) : super.dirty(value);

  @override
  AvatarValidationError? validator(String? value) {
    return value != "" ? null : AvatarValidationError.invalid;
  }
}
