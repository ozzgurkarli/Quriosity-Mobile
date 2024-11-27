// ignore_for_file: non_constant_identifier_names

class DTOQuestion{
  String? id;
  String? senderuid;
  String? SenderUsername;
  String? CommunityId;
  String? Question;
  DateTime? QuestionDate;
  List? Options;
  List? Answers;
  List? InactiveUsers;

  DTOQuestion({this.id, this.senderuid, this.SenderUsername, this.CommunityId, this.Options, this.Question, this.InactiveUsers, this.Answers, this.QuestionDate});

  factory DTOQuestion.fromJson(Map<dynamic, dynamic> json) {
    return DTOQuestion(
      senderuid: json['senderuid'] as String?,
      id: json['id'] as String?,
      CommunityId: json['CommunityId'] as String?,
      Question: json['Question'] as String?,
      SenderUsername: json['SenderUsername'] as String?,
      QuestionDate: DateTime.fromMillisecondsSinceEpoch(json['QuestionDate'] as int? ?? 1),
      Options: json['Options'] as List?,
      Answers: json['Answers'] as List?,
      InactiveUsers: json['InactiveUsers'] as List?,
    );
  }

  // toJson metodu
  Map<String, dynamic> toJson() {
    return {
      'senderuid': senderuid,
      'id': id,
      'CommunityId': CommunityId,
      'InactiveUsers': InactiveUsers,
      'Options': Options,
      'SenderUsername': SenderUsername,
      'Question': Question,
      'QuestionDate': QuestionDate,
      'Answers': Answers,
    };
  }
}
