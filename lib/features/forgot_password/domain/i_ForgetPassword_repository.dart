import 'package:either_dart/either.dart';

import '../../../core/exceptions/network_exception.dart';


abstract class IForgetPasswordRepository {
  Future<Either<NetworkException, String>> sendOtp(String receptor);
  Future<Either<NetworkException, String>> verifyOtp(String receptor, String otp);
  Future<Either<NetworkException, String>> resetPassword(String receptor, String newPassword);
}
