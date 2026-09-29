import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies/core/error/failures.dart';
import 'package:movies/features/auth/domain/entities/user_entity.dart';
import 'package:movies/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movies/features/auth/presentation/cubit/profile_cubit.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeAuthRepository repository;

  setUp(() => repository = FakeAuthRepository());
  tearDown(() => repository.users.close());

  group('AuthCubit', () {
    test('register passes the profile fields to the repository', () async {
      final cubit = AuthCubit(repository);
      final states = <AuthState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.register(
        name: 'Gerges',
        email: 'g@example.com',
        password: 'Abc12345',
        phone: '01012345678',
        avatar: 'assets/images/avatars/gamer (2).png',
      );
      await pumpEventQueue();

      expect(states, [isA<AuthLoading>(), isA<AuthSuccess>()]);
      expect(repository.lastRegistration, {
        'name': 'Gerges',
        'email': 'g@example.com',
        'phone': '01012345678',
        'avatar': 'assets/images/avatars/gamer (2).png',
      });
      await subscription.cancel();
      await cubit.close();
    });

    test('emits an error when login fails', () async {
      repository.result = const Left(AuthFailure('Wrong password'));
      final cubit = AuthCubit(repository);

      await cubit.login('g@example.com', 'bad');

      expect(cubit.state, const AuthError('Wrong password'));
      await cubit.close();
    });

    test('forgotPassword emits AuthEmailSent on success', () async {
      final cubit = AuthCubit(repository);

      await cubit.forgotPassword('g@example.com');

      expect(cubit.state, isA<AuthEmailSent>());
      await cubit.close();
    });
  });

  group('ProfileCubit', () {
    const user = UserEntity(
      id: '1',
      name: 'Gerges',
      email: 'g@example.com',
      phone: '01012345678',
      avatar: 'assets/images/avatars/gamer (2).png',
    );

    test('follows the signed-in user', () async {
      final cubit = ProfileCubit(repository)..watchProfile();

      repository.users.add(user);
      final state = await cubit.stream.firstWhere(
        (s) => s.status == ProfileStatus.loaded,
      );

      expect(state.user, user);
      await cubit.close();
    });

    test('updateProfile reports success', () async {
      final cubit = ProfileCubit(repository);

      await cubit.updateProfile(name: 'G', phone: '0100', avatar: 'a.png');

      expect(cubit.state.action, ProfileAction.updated);
      expect(repository.lastUpdate, {
        'name': 'G',
        'phone': '0100',
        'avatar': 'a.png',
      });
      await cubit.close();
    });

    test(
      'deleteAccount failure keeps the user on the page with a message',
      () async {
        repository.result = const Left(AuthFailure('requires-recent-login'));
        final cubit = ProfileCubit(repository);

        await cubit.deleteAccount();

        expect(cubit.state.action, ProfileAction.none);
        expect(cubit.state.errorMessage, 'requires-recent-login');
        await cubit.close();
      },
    );

    test('logout signs out and reports it', () async {
      final cubit = ProfileCubit(repository);

      await cubit.logout();

      expect(repository.calls, contains('logout'));
      expect(cubit.state.action, ProfileAction.loggedOut);
      await cubit.close();
    });
  });
}
