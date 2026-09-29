import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> login(String email, String password);

  Future<Either<Failure, void>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
  });

  Future<Either<Failure, void>> forgotPassword(String email);

  Future<Either<Failure, void>> logout();

  bool get isLoggedIn;

  /// Emits the signed-in user's profile, or `null` when nobody is signed in.
  Stream<UserEntity?> watchCurrentUser();

  Future<Either<Failure, void>> updateProfile({
    required String name,
    required String phone,
    required String avatar,
  });

  Future<Either<Failure, void>> deleteAccount();
}
