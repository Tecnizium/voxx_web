part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

class DashboardInitialEvent extends DashboardEvent {}

class DashboardLoadedEvent extends DashboardEvent {
  final List<PollModel> polls;
DashboardLoadedEvent({required this.polls});
}

class CreatePollButtonPressedEvent extends DashboardEvent {
  CreatePollButtonPressedEvent();
}

class GetUserCachedEvent extends DashboardEvent {}

class RedirectToPollDetailEvent extends DashboardEvent {
  final PollModel poll;

  RedirectToPollDetailEvent({required this.poll});
}