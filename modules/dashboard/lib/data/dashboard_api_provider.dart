import 'dart:convert';

import 'package:commons/commons.dart';
import 'package:commons/data/const/endpoints_const.dart';
import 'package:commons_dependencies/commons_dependencies.dart';

class DashboardApiProvider {
  final Dio dio = Dio();

  Future<Response> getPollsByIdManager(String jwtToken) async {
    try {
      return await dio.get(
          AppEndpoints.CampaignForgeCampaignGetCampaignsByIdManager,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Access-Control-Allow-Origin': '*',
              'Authorization': 'Bearer $jwtToken'
            },
          ));
    } on DioException catch (e) {
      return e.response as Response;
    }
  }

  Future<Response> createPoll(PollModel poll, String jwtToken) async {
    try {
      return await dio.post(AppEndpoints.CampaignForgeCampaignCreateCampaign,
          data: poll.toJsonWithoutId(),
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Access-Control-Allow-Origin': '*',
              'Authorization': 'Bearer $jwtToken'
            },
          ));
    } on DioException catch (e) {
      return e.response as Response;
    }
  }

  Future<Response> updatePoll(PollModel poll, String jwtToken) async{
    try {
      return await dio.put(AppEndpoints.CampaignForgeCampaignUpdateCampaign,
          data: poll.toJson(),
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Access-Control-Allow-Origin': '*',
              'Authorization': 'Bearer $jwtToken'
            },
          ));
    } on DioException catch (e) {
      return e.response as Response;
    }
  }

  Future<Response> deletePoll(String pollId, String jwtToken) async{
    try {
      return await dio.delete('${AppEndpoints.CampaignForgeCampaignDeleteCampaign}/$pollId',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Access-Control-Allow-Origin': '*',
              'Authorization': 'Bearer $jwtToken'
            },
          ));
    } on DioException catch (e) {
      return e.response as Response;
    }
  }

  Future<Response> getPollStat(String pollId, String jwtToken) async{
    try {
      return await dio.get(AppEndpoints.StatMosaicStatistics,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Access-Control-Allow-Origin': '*',
              'pollId': pollId,
              'Authorization': 'Bearer $jwtToken'
            },
          ));
    } on DioException catch (e) {
      return e.response as Response;
    }
  }
}
