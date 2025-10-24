abstract class ForgetPasswordState {
  const ForgetPasswordState();
}

// Initial State — before any action
class ForgetPasswordInitial extends ForgetPasswordState {
  const ForgetPasswordInitial();
}

// Loading State — when the user submits the email/phone
class ForgetPasswordLoading extends ForgetPasswordState {
  const ForgetPasswordLoading();
}

// Success State — when OTP/email is sent
class ForgetPasswordSuccess extends ForgetPasswordState {
  final String message;
  const ForgetPasswordSuccess(this.message);
}

// Failure State — error in sending email/OTP
class ForgetPasswordFailure extends ForgetPasswordState {
  final String error;
  const ForgetPasswordFailure(this.error);
}

// Duplicate State (optional) — if you need to indicate email/phone already in use
class ForgetPasswordDuplicate extends ForgetPasswordState {
  const ForgetPasswordDuplicate();
}
