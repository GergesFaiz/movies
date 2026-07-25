// domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> login(String email, String password);

  Future<Either<Failure, void>> register(String email, String password);

  Future<Either<Failure, void>> forgotPassword(String email);

  Future<Either<Failure, void>> logout();

  bool get isLoggedIn;
}
