// class ConfirmedPassword {
//   final String value;
//   final bool isValid;

//   const ConfirmedPassword._internal({
//     required this.value,
//     required this.isValid,
//   });

//   const ConfirmedPassword.initial()
//       : value = '',
//         isValid = false;

//   factory ConfirmedPassword(String input) {
//     return ConfirmedPassword._internal(
//       value: input,
//       isValid: _validatePassword(input),
//     );
//   }
// }

// bool _validatePassword(String input) {
//   return (input.length >= 12) ? true : false;
// }
