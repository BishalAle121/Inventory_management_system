import 'package:either_dart/src/either.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/network_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/token_service.dart';
import '../../domain/I_change_password_reopsitory/i_change_password_repository.dart';
import '../model/changepassword_model.dart';


class ChangePasswordRepository implements IChangePasswordRepository
{
  final DioClient _dioClient;
  final TokenService _tokenService;

  ChangePasswordRepository(this._dioClient, this._tokenService);
  @override
  Future<Either<NetworkException, String>> ChangePassword(ChangePassword) async{
    try
        {
           final dataModel = ChangePasswordModel.fromEntity(ChangePassword);
           final response = await _dioClient.post(
             ApiConstants.changePassword,
             data: dataModel.toJson()
           );

           final data = response.data;

           if (data.containsKey('message') && data['message'] != null) {
             return Right(data['message'].toString());
           } else if (data.containsKey('error') && data['error'] != null) {
             return Left(NetworkException(message: data['error'].toString()));
           } else {
             return Left(NetworkException(message: 'Unknown server response'));
           }
        }
    catch (error)
    {
      return Left(NetworkException(message: error.toString()));
    }
  }
}