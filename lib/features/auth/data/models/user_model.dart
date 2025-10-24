import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String phoneNumber,
    required String email,
    String? name,
    required String token,
    required String refresh
  }) : super(
          userID: id,
          userName: name,
          userPhoneNumber: phoneNumber,
          userEmail: email,
          userExpireToken: token,
          userRefreshToken: refresh
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['userId'] as String,
      name: json['userName'] as String?,
      phoneNumber: json['userPhoneNumber'] as String,
      email: json['userEmail'] as String,
      token: json['token'] as String,
      refresh: json['refresh'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userID,
      'userName': userName,
      'PhoneNumber': userPhoneNumber,
      'userEmail': userEmail,
      'token': userExpireToken,
      'refresh' : userRefreshToken
    };
  }
}