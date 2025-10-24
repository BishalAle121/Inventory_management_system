import 'package:either_dart/either.dart';

import '../../../../core/exceptions/network_exception.dart';

abstract class IChangePasswordRepository
{
    Future<Either<NetworkException, String>> ChangePassword(ChangePassword);
}