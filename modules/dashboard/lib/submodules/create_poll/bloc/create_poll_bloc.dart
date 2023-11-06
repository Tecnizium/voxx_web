import 'package:bloc/bloc.dart';
import 'package:commons/commons.dart';
import 'package:dashboard/dashboard.dart';
import 'package:meta/meta.dart';

part 'create_poll_event.dart';
part 'create_poll_state.dart';

class CreatePollBloc extends Bloc<CreatePollEvent, CreatePollState> {
  CreatePollBloc(
      {CacheProvider? cacheProvider,
      DashboardApiProvider? dashboardApiProvider})
      : super(CreatePollInitial()) {
    CacheProvider _cacheProvider = cacheProvider ?? CacheProvider();
    DashboardApiProvider _dashboardApiProvider =
        dashboardApiProvider ?? DashboardApiProvider();

    on<CreatePollEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<SaveOrCreatePollButtonPressedEvent>((event, emit) async {
      emit(CreatePollLoading());
      final jwtToken = await _cacheProvider.jwtToken;
      if (event.poll.id == null) {
        try {
          final response =
              await _dashboardApiProvider.createPoll(event.poll, jwtToken);
          if (response.statusCode == 200) {
            emit(CreatePollSuccess());
          } else {
            emit(CreatePollError(message: response.statusMessage.toString()));
          }
        } catch (e) {
          emit(CreatePollError(message: e.toString()));
        }
      } else {
        try {
          final response =
              await _dashboardApiProvider.updatePoll(event.poll, jwtToken);
          if (response.statusCode == 200) {
            emit(EditPollSuccess(poll: event.poll));
          } else {
            emit(CreatePollError(message: response.data));
          }
        } catch (e) {
          emit(CreatePollError(message: e.toString()));
        }
      }
    });

    on<DeleteOrCancelPollButtonPressedEvent>((event, emit) async {
      if (event.poll.id == null) {
        emit(CancelPollSuccess());
      } else {
        emit(CreatePollLoading());
        final jwtToken = await _cacheProvider.jwtToken;
        try {
          final response =
              await _dashboardApiProvider.deletePoll(event.poll.id!, jwtToken);

          if (response.statusCode == 200) {
            emit(DeletePollSuccess());
          } else {
            emit(CreatePollError(message: response.statusMessage.toString()));
          }
        } catch (e) {
          emit(CreatePollError(message: e.toString()));
        }
      }
    });
  }
}
