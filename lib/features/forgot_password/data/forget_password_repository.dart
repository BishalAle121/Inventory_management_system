import 'package:either_dart/either.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/exceptions/network_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/i_ForgetPassword_repository.dart';



class ForgetPasswordRepository implements IForgetPasswordRepository {
  final DioClient _dioClient;

  ForgetPasswordRepository(this._dioClient);

  @override
  Future<Either<NetworkException, String>> sendOtp(String receptor) async {
    try {
      Map<String, dynamic> receptorData = {'receptor': receptor};
      final response = await _dioClient.post(
        ApiConstants.sendOtp,
        queryParameters: receptorData,
      );

      print("RAW response: ${response.data} (${response.data.runtimeType})");

      if (response.data is Map<String, dynamic>) {
        final message = response.data['message'];
        return Right(message);
      } else if (response.data is String) {
        // If API returns plain text
        return Right(response.data);
      } else {
        // Unknown format
        return Right("Unexpected response");
      }
    } on NetworkException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<NetworkException, String>> verifyOtp(String receptor, String otp) async {
    try {
      Map<String, dynamic> receptorData = {
        'EmailID': receptor,
        'perOTPVerification': otp,
      };
      final response = await _dioClient.post(
        ApiConstants.verifyOtp,
        queryParameters: receptorData,
      );

      print("RAW response: ${response.data} ${response.data.runtimeType}");

      if (response.data is Map<String, dynamic>)
      {
        return Right(response.data['message']);
      }
      else if (response.data is String)
      {
        return Right(response.data);
      } else
      {
        return Right("Unexpected response");
      }
    } on NetworkException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<NetworkException, String>> resetPassword(String receptor, String newPassword) async {
    try {
      final queryParameter = {
        'EmailID': receptor,
        'NewPassword': newPassword,
      };

      final response = await _dioClient.post(
        ApiConstants.resetPassword,
        queryParameters: queryParameter,
      );

      // Since your API returns a plain string, no casting needed
      final String message = response.data.toString();

      return Right(message);
    } on NetworkException catch (e) {
      return Left(e);
    } catch (e) {
      // Catch unexpected format issues
      return Left(NetworkException(message: 'Unexpected error: $e'));
    }
  }

}
