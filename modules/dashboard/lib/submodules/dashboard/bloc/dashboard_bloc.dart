import 'package:bloc/bloc.dart';
import 'package:commons/commons.dart';
import 'package:dashboard/dashboard.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(
      {DashboardApiProvider? dashboardApiProvider,
      CacheProvider? cacheProvider})
      : super(DashboardInitial()) {
    CacheProvider _cacheProvider = cacheProvider ?? CacheProvider();
    DashboardApiProvider _dashboardApiProvider =
        dashboardApiProvider ?? DashboardApiProvider();

    on<DashboardEvent>((event, emit) {
      if (kDebugMode) {
        print(event);
      }
    });

    on<DashboardInitialEvent>(
      (event, emit) async {
        emit(DashboardLoading());
        try {
          final jwtToken = await _cacheProvider.jwtToken;
          final response =
              await _dashboardApiProvider.getPollsByIdManager(jwtToken);
          if (response.statusCode == 200) {
            emit(DashboardLoaded(
                polls: response.data
                    .map<PollModel>((e) => PollModel.fromMap(e))
                    .toList()));
          } else {
            emit(DashboardError(message: response.data));
          }
        } catch (e) {
          emit(DashboardError(message: e.toString()));
        }
      },
    );

    on<DashboardLoadedEvent>((event, emit) {
      emit(DashboardLoaded(polls: event.polls));
    });

    on<CreatePollButtonPressedEvent>(
        (event, emit) => emit(RedirectToCreatePoll()));

    on<GetUserCachedEvent>((event, emit) async {
      final user = await _cacheProvider.user;
      emit(UserCacheLoaded(user: user));
    });

    on<RedirectToPollDetailEvent>((event, emit) async {
      await _cacheProvider.setPollDetails(event.poll);
      return emit(RedirectToPollDetail(poll: event.poll));
    });
  }
}
