part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState._(
      {required this.status,
      this.user = User.empty,
      this.userDetails = UserDetails.empty});

  const AppState.authenticated(User user, UserDetails userDetails)
      : this._(
            status: AppStatus.authenticated,
            user: user,
            userDetails: userDetails);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;
  final User user;
  final UserDetails userDetails;

  @override
  List<Object> get props => [status, user, userDetails];
}
