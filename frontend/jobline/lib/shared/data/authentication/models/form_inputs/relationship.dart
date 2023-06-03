import 'package:formz/formz.dart';

enum RelationshipValidationError { invalid }

class RelationshipValidation
    extends FormzInput<String, RelationshipValidationError> {
  const RelationshipValidation.pure([String value = '']) : super.pure(value);
  const RelationshipValidation.dirty([String value = '']) : super.dirty(value);

  @override
  RelationshipValidationError? validator(String? value) {
    return value != "" ? null : RelationshipValidationError.invalid;
  }
}
