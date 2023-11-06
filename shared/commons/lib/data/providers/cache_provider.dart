import 'dart:convert';

import 'package:commons/data/data.dart';
import 'package:commons_dependencies/commons_dependencies.dart';

class CacheProvider {
  Future<SharedPreferences> get prefs async => await SharedPreferences.getInstance();

  Future<void> clear() async => (await prefs).clear();

  Future<UserModel> get user async => UserModel.fromMap(json.decode((await prefs).getString('user') ?? '{}'));
  Future<void> setUser(UserModel value) async => (await prefs).setString('user', json.encode(value.toJson()));
  
  Future<String> get jwtToken async => (await prefs).getString('jwtToken') ?? '';
  Future<void> setJwtToken(String value) async => (await prefs).setString('jwtToken', value);

  Future<DateTime> get lastUpdate async => DateTime.parse((await prefs).getString('lastUpdate') ?? DateTime.now().toIso8601String());
  Future<void> setLastUpdate(DateTime value) async => (await prefs).setString('lastUpdate', value.toIso8601String());

  Future<PollModel> get pollDetails async => PollModel.fromMap(json.decode((await prefs).getString('pollDetails') ?? '{}'));
  Future<void> setPollDetails(PollModel value) async => (await prefs).setString('pollDetails', json.encode(value.toJson()));
}