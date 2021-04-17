/// A valid email address should contain an at sign: @.
///
/// This is generally considered a good method of validating an
/// email field given the extreme possibilities that are now
/// possible with domains and addresses - especially when
/// paired with a verification email sent to the user.
bool validateEmailAddress(String value) {
  return (value.contains('@')) ? true : false;
}
