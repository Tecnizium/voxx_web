import 'package:bloc/bloc.dart';
import 'package:commons/commons.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../../data/login_api_provider.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({LoginApiProvider? loginApiProvider, CacheProvider? cacheProvider})
      : super(SignUpInitial()) {
    CacheProvider _cacheProvider = cacheProvider ?? CacheProvider();
    LoginApiProvider _loginApiProvider = loginApiProvider ?? LoginApiProvider();

    on<SignUpEvent>((event, emit) {
      if (kDebugMode) {
        print(event);
      }
    });

    on<SignUpButtonPressed>(
      (event, emit) async {
        emit(SignUpLoading());
        try {
          final response = await _loginApiProvider.signUp(event.firstName,
              event.lastName, event.username, event.email, event.password);

          if (response.statusCode == 200) {
            emit(SignUpSuccess());
          } else {
            emit(SignUpError(response.data));
          }
        } catch (e) {
          emit(SignUpError(e.toString()));
        }
      },
    );
  }
}
