class RegistrationModel
{
  final String userName;
  final String phoneNumber;
  final String emailId;
  final String password;
  bool confirmEmail = false;

  RegistrationModel(
      {
        required this.userName,
        required this.phoneNumber,
        required this.emailId,
        required this.password,
        required this.confirmEmail
      });

  factory RegistrationModel.fromjson(Map<String, dynamic> json)
  {
      return RegistrationModel(
          userName: json['userName'],
          phoneNumber: json['phoneNumber'],
          emailId: json['userEmail'],
          confirmEmail: json['userEmailConfirm'],
          password: json['passwordHash'],
      );
  }

  Map<String, dynamic> toJson()
  {
      return{
          'UserName' : userName,
          'phoneNumber' : phoneNumber,
          'UserEmail' : emailId,
          'userEmailConfirm' : confirmEmail,
          'passwordHash' : password
      };
  }
}