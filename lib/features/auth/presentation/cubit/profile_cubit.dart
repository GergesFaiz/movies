import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _repository;
  StreamSubscription<UserEntity?>? _userSubscription;

  ProfileCubit(this._repository) : super(const ProfileState());

  void watchProfile() {
    _userSubscription?.cancel();
    _userSubscription = _repository.watchCurrentUser().listen(
      (user) => emit(
        state.copyWith(
          status: ProfileStatus.loaded,
          user: user,
          clearUser: user == null,
        ),
      ),
      onError: (Object error) => emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: error.toString(),
        ),
      ),
    );
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String avatar,
  }) async {
    if (state.isBusy) return;
    emit(state.copyWith(action: ProfileAction.updating, clearError: true));
    final result = await _repository.updateProfile(
      name: name,
      phone: phone,
      avatar: avatar,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          action: ProfileAction.none,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(action: ProfileAction.updated)),
    );
  }

  Future<void> deleteAccount() async {
    if (state.isBusy) return;
    emit(state.copyWith(action: ProfileAction.deleting, clearError: true));
    final result = await _repository.deleteAccount();
    result.fold(
      (failure) => emit(
        state.copyWith(
          action: ProfileAction.none,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(action: ProfileAction.deleted)),
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(state.copyWith(action: ProfileAction.loggedOut));
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
