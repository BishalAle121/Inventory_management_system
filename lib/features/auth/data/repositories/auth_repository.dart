import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/network_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/token_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../models/user_model.dart';

class AuthRepository implements IAuthRepository {
  final DioClient _dioClient;
  final TokenService _tokenService;

  AuthRepository(this._dioClient, this._tokenService);

  @override
  Future<Either<NetworkException, User?>> getCurrentUser() async {
    try {
      final token = _tokenService.getAccessToken();
      if (token == null) return const Right(null);

      final response = await _dioClient.get(ApiConstants.authorisedMe, options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),);
      print(response);
      final user = UserModel.fromJson(response.data);
      return Right(user);
    } on NetworkException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<NetworkException, User>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.login,
        data: {
          'userEmail': email,
          'passwordHash': password,
        },
      );

      final user =  UserModel.fromJson(response.data);

      await _tokenService.saveTokens(
        accessToken: response.data['token'],
        refreshToken: response.data['refresh'],
        expiresIn: response.data['expireIn'],
      );

      return Right(user);
    } on NetworkException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<NetworkException, String>> logout(String UserId) async {
    try {
      var response = await _dioClient.post(ApiConstants.logout, queryParameters: {"UserId" : UserId});
      if(response.statusCode == 200 || response.statusCode == 201)
        {
           print("Success: ${response.data}");
           await _tokenService.clearTokens();
        }
      else
        {
          print("Failed: ${response.data}");
        }
      return Right("Logout Successfully");
    } on NetworkException catch (e) {
      return Left(e);
    }
  }
}