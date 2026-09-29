part of 'profile_cubit.dart';

enum ProfileStatus { loading, loaded, failure }

/// One-shot results of user actions, used by listeners to show feedback.
enum ProfileAction { none, updating, updated, deleting, deleted, loggedOut }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserEntity? user;
  final ProfileAction action;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.loading,
    this.user,
    this.action = ProfileAction.none,
    this.errorMessage,
  });

  bool get isBusy =>
      action == ProfileAction.updating || action == ProfileAction.deleting;

  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? user,
    bool clearUser = false,
    ProfileAction? action,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      action: action ?? this.action,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, user, action, errorMessage];
}
