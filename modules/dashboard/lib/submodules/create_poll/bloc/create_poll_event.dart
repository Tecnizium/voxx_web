part of 'create_poll_bloc.dart';

@immutable
sealed class CreatePollEvent {}

class SaveOrCreatePollButtonPressedEvent extends CreatePollEvent {
  final PollModel poll;

  SaveOrCreatePollButtonPressedEvent({required this.poll});
}

class DeleteOrCancelPollButtonPressedEvent extends CreatePollEvent {
  final PollModel poll;

  DeleteOrCancelPollButtonPressedEvent({required this.poll});
}
