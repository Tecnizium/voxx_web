part of 'details_poll_bloc.dart';

@immutable
sealed class DetailsPollState {}

final class DetailsPollInitial extends DetailsPollState {}

final class DetailsPollLoaded extends DetailsPollState {
  final PollModel poll;

  DetailsPollLoaded({required this.poll});
}

final class PollStatLoading extends DetailsPollState {}

final class PollStatLoaded extends DetailsPollState {
  final PollStatModel pollStat;

  PollStatLoaded({required this.pollStat});
}

final class PollStatError extends DetailsPollState {
  final String message;

  PollStatError({required this.message});

}

final class RedirectToEditPoll extends DetailsPollState {
  final PollModel poll;

  RedirectToEditPoll({required this.poll});
}