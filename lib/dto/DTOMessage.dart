// ignore_for_file: non_constant_identifier_names

class DTOMessage{
  String? CommunityId;
  String? id;
  String? senderuid;
  String? SenderUsername;
  DateTime? MessageDate;
  String? Message;
  String? QuestionId;

  DTOMessage({this.id, this.CommunityId, this.Message, this.SenderUsername, this.senderuid, this.MessageDate, this.QuestionId});

  factory DTOMessage.fromJson(Map<dynamic, dynamic> json) {
    return DTOMessage(
      CommunityId: json['CommunityId'] as String?,
      Message: json['Message'] as String?,
      SenderUsername: json['SenderUsername'] as String?,
      id: json['id'] as String?,
      senderuid: json['senderuid'] as String?,
      MessageDate: DateTime.fromMillisecondsSinceEpoch(json['MessageDate'] as int? ?? 1),
      QuestionId: json['QuestionId'] as String?
    );
  }

  // toJson metodu
  Map<String, dynamic> toJson() {
    return {
      'CommunityId': CommunityId,
      'senderuid': senderuid,
      'Message': Message,
      'SenderUsername': SenderUsername,
      'id': id,
      'MessageDate': MessageDate,
      'QuestionId': QuestionId
    };
  }
}
