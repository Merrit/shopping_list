/// Returns true if the password is at least 12 characters in length.
///
/// Recommendations for passwords containing special characters, numerals,
/// capitals and etc are antiquated and not considered best practice.
///
/// Modern passwords should be easy for a user to remember - like words - while
/// being difficult for machines to guess by:
///
/// 1. Being unrelated words that would never appear together naturally.
///
/// 2. Being a long password. Here we validate for 12 characters for simplicity
/// and user-friendliness, however a stronger enforcement would be 16 or more.
///
///
/// Example of a good password:
/// beginning-cloak-beetle
///
/// This is a 22-character password that is very easy for a human to
/// remember and type, but very difficult for a computer to guess.
bool validatePassword(String input) {
  return (input.length >= 12) ? true : false;
}
