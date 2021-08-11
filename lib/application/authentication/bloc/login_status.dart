abstract class LoginStatus {}

class SignedOut extends LoginStatus {}

class SubmissionInProgress extends LoginStatus {}

class SubmissionSuccess extends LoginStatus {}

class SubmissionFailure extends LoginStatus {
  final String code;
  final String? message;
  final String? email;

  SubmissionFailure({
    required this.code,
    this.message,
    this.email,
  });
}
