import 'package:either_dart/either.dart';


import '../../../../core/exceptions/network_exception.dart';
import '../../data/models/registration_model.dart';


abstract class IRegistRepository
{
    Future<Either<NetworkException, String>> registration(RegistrationModel registerModel);
}