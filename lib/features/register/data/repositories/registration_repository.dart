import 'package:either_dart/src/either.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/network_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/I_regist_repository.dart';
import '../models/registration_model.dart';

class RegistrationRepository extends IRegistRepository {
  final DioClient _dioClient;
  RegistrationRepository(this._dioClient);
  @override
  Future<Either<NetworkException, String>> registration(RegistrationModel newRegistration) async {
    try
        {
          var response =  await _dioClient.post(ApiConstants.register, data: newRegistration.toJson());
          if(response.statusCode == 200 || response.statusCode == 201)
            {
               return Right(response.data);
            }
          else
            {
               return Right(response.data);

            }
        }

    on NetworkException catch (error)
    {
        return Left(error);
    }
  }
}
