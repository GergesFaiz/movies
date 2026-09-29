import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> login(String email, String password) {
    return _run(() => _remoteDataSource.login(email, password));
  }

  @override
  Future<Either<Failure, void>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
  }) {
    return _run(
      () => _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        avatar: avatar,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) {
    return _run(() => _remoteDataSource.forgotPassword(email));
  }

  @override
  Future<Either<Failure, void>> logout() {
    return _run(_remoteDataSource.logout);
  }

  @override
  bool get isLoggedIn => _remoteDataSource.isLoggedIn;

  @override
  Stream<UserEntity?> watchCurrentUser() {
    return _remoteDataSource.watchCurrentUser().map((user) => user?.toEntity());
  }

  @override
  Future<Either<Failure, void>> updateProfile({
    required String name,
    required String phone,
    required String avatar,
  }) {
    return _run(
      () => _remoteDataSource.updateProfile(
        name: name,
        phone: phone,
        avatar: avatar,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteAccount() {
    return _run(_remoteDataSource.deleteAccount);
  }

  Future<Either<Failure, void>> _run(Future<void> Function() action) async {
    try {
      await action();
      return const Right(null);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
