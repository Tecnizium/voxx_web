import 'package:bloc/bloc.dart';
import 'package:commons/commons.dart';
import 'package:dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'details_poll_event.dart';
part 'details_poll_state.dart';

class DetailsPollBloc extends Bloc<DetailsPollEvent, DetailsPollState> {
  DetailsPollBloc(
      {CacheProvider? cacheProvider,
      DashboardApiProvider? dashboardApiProvider})
      : super(DetailsPollInitial()) {
    CacheProvider _cacheProvider = cacheProvider ?? CacheProvider();
    DashboardApiProvider _dashboardApiProvider =
        dashboardApiProvider ?? DashboardApiProvider();
      

    on<DetailsPollEvent>((event, emit) {
      debugPrint('DetailsPollEvent: $event');
    });

    on<GetPollDetailsCachedEvent>((event, emit) async {
      final poll = await _cacheProvider.pollDetails;
      emit(DetailsPollLoaded(poll: poll));
    });

    on<EditPollButtonPressedEvent>(
        (event, emit) => emit(RedirectToEditPoll(poll: event.poll)));

    on<GetPollStatEvent>((event, emit) async {
      emit(PollStatLoading());
      final jwtToken = await _cacheProvider.jwtToken;
      try {
        final response =
            await _dashboardApiProvider.getPollStat(event.pollId, jwtToken);

        if (response.statusCode == 200) {
          emit(PollStatLoaded(pollStat: PollStatModel.fromMap(response.data)));
        } else {
          emit(PollStatError(
              message: 'Error getting poll stat'));
        }
      } catch (e) {
        emit(PollStatError(message: 'Error getting poll stat'));
      }
    });
  }
}

const Map<String, dynamic> mock = {
  "pollId": "cf51db6f-e033-40a4-806b-90b3a03d44ac",
  "pollTitle": "Questionário de Avaliação do Sistema",
  "pollDescription":
      "Este questionário foi projetado para coletar feedback objetivo sobre a usabilidade, desempenho, funcionalidade, segurança, suporte, satisfação geral e outros aspectos do sistema em questão. Suas respostas nos ajudarão a avaliar a eficácia do sistema e identificar áreas que podem precisar de melhorias.",
  "pollStatus": 0,
  "pollQuestions": [
    {
      "id": "2da15dbe-a40c-474f-bdb1-cba13d7a079a",
      "text":
          "a. Em uma escala de 1 a 5, quão fácil é usar o sistema? (1 = Muito difícil, 5 = Muito fácil)",
      "options": [
        {"text": "1"},
        {"text": "2"},
        {"text": "3"},
        {"text": "4"},
        {"text": "5"}
      ],
      "type": 0
    },
    {
      "id": "89cfca06-de33-4fb9-895e-049b12c4f3d6",
      "text":
          "b. Em uma escala de 1 a 5, quão intuitiva é a interface do usuário? (1 = Pouco intuitiva, 5 = Muito intuitiva)",
      "options": [
        {"text": "1"},
        {"text": "2"},
        {"text": "3"},
        {"text": "4"},
        {"text": "5"}
      ],
      "type": 0
    },
    {
      "id": "25dc0cda-3a7b-42c2-a3f9-bcf750e02ff3",
      "text": "a. O sistema responde rapidamente às suas ações? (Sim / Não)",
      "options": [
        {"text": "Sim"},
        {"text": "Não"}
      ],
      "type": 0
    }
  ],
  "pollPercentage": {
    "2da15dbe-a40c-474f-bdb1-cba13d7a079a": {
      "1": 25,
      "2": 25,
      "3": 0,
      "4": 40,
      "5": 10
    },
    "89cfca06-de33-4fb9-895e-049b12c4f3d6": {
      "1": 100,
      "2": 0,
      "3": 0,
      "4": 0,
      "5": 0
    },
    "25dc0cda-3a7b-42c2-a3f9-bcf750e02ff3": {"Sim": 0, "Não": 100}
  },
  "pollCount": {
    "TotalAnswers": {"TotalAnswers": 1},
    "2da15dbe-a40c-474f-bdb1-cba13d7a079a": {
      "1": 1,
      "2": 0,
      "3": 0,
      "4": 0,
      "5": 0
    },
    "89cfca06-de33-4fb9-895e-049b12c4f3d6": {
      "1": 1,
      "2": 0,
      "3": 0,
      "4": 0,
      "5": 0
    },
    "25dc0cda-3a7b-42c2-a3f9-bcf750e02ff3": {"Sim": 0, "Não": 1}
  }
};
