import 'dart:convert';

class PollStatModel {
  String? pollId;
  Map<String, dynamic>? pollPercentage;
  Map<String, dynamic>? pollCount;

  PollStatModel({this.pollId, this.pollPercentage, this.pollCount});

  factory PollStatModel.fromJson(String source) =>
      PollStatModel.fromMap(json.decode(source));

  factory PollStatModel.fromMap(Map<String, dynamic> map) {
    return PollStatModel(
        pollId: map['pollId'],
        pollPercentage: map['pollPercentage'],
        pollCount: map['pollCount']);
  }

  Map<String, dynamic> toJson() {
    return {
      'pollId': pollId,
      'pollPercentage': pollPercentage,
      'pollCount': pollCount
    };
  }
}