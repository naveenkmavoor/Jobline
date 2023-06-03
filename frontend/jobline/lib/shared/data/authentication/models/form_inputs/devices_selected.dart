import 'package:formz/formz.dart';

enum DeviceValidationError { empty, invalid }

class DeviceValidation extends FormzInput<List<String>, DeviceValidationError> {
  const DeviceValidation.pure([List<String> value = const []])
      : super.pure(value);
  const DeviceValidation.dirty([List<String> value = const []])
      : super.dirty(value);

  @override
  DeviceValidationError? validator(List<String> value) {
    // if (value.contains("ios") && value.length == 1) {
    //throws error when ios is only selected
    //   return DeviceValidationError.invalid;
    // }
    return value.isNotEmpty ? null : DeviceValidationError.empty;
  }
}
