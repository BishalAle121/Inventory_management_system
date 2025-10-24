class User {
  final String userID;
  final String? userName;
  final String userPhoneNumber;
  final String userEmail;
  final String userExpireToken;
  final String userRefreshToken;

  const User({
    required this.userID,
    this.userName,
    required this.userEmail,
    required this.userPhoneNumber,
    required this.userExpireToken,
    required this.userRefreshToken
  });
}