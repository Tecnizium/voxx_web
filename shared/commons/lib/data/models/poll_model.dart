import 'dart:convert';

import 'package:commons/data/models/question_model.dart';
import 'package:commons_dependencies/commons_dependencies.dart';

class PollModel {
  String? id;
  String? managerId;
  String? campaignId;
  String? title;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  int? status;
  List<QuestionModel> questions;

  PollModel(
      {this.id,
      this.managerId,
      this.campaignId,
      this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.status,
      required this.questions});

  factory PollModel.fromJson(String source) =>
      PollModel.fromMap(json.decode(source));

  factory PollModel.fromMap(Map<String, dynamic> map) {
    return PollModel(
        id: map['id'],
        managerId: map['managerId'],
        campaignId: map['campaignId'],
        title: map['title'],
        description: map['description'],
        startDate: DateTime.tryParse(map['startDate']),
        endDate: DateTime.tryParse(map['endDate']),
        status: map['status'],
        questions: map['questions']
            .map<QuestionModel>((question) => QuestionModel.fromMap(question))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'managerId': managerId,
      'campaignId': campaignId,
      'title': title,
      'description': description,
      'startDate': startDate!.toIso8601String(),
      'endDate': endDate!.toIso8601String(),
      'status': status,
      'questions': questions.map((question) => question.toJson()).toList()
    };
  }

  //to Json without id
  Map<String, dynamic> toJsonWithoutId() {
    return {
      'campaignId': campaignId,
      'title': title,
      'description': description,
      'startDate': startDate!.toIso8601String(),
      'endDate': endDate!.toIso8601String(),
      'status': status ?? 0,
      'questions': questions.map((question) => question.toJsonWithoutId()).toList()
    };
  }
}
