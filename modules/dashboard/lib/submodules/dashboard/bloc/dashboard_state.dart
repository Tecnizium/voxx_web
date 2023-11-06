part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class DashboardLoaded extends DashboardState {
  final List<PollModel> polls;

  DashboardLoaded({required this.polls});
}

final class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}

final class RedirectToCreatePoll extends DashboardState {
  RedirectToCreatePoll();
}

final class RedirectToPollDetail extends DashboardState {
  final PollModel poll;

  RedirectToPollDetail({required this.poll});
}

final class UserCacheLoaded extends DashboardState {
  final UserModel user;

  UserCacheLoaded({required this.user});
}

