abstract class RegisterState {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class DuplicateRegister extends RegisterState
{
   const DuplicateRegister();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  final String success;
  const RegisterSuccess(this.success);
}

class RegisterFailure extends RegisterState {
  final String message;
  const RegisterFailure(this.message);
}
