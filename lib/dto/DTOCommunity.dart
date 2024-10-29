// ignore_for_file: non_constant_identifier_names

class DTOCommunity{
  String? CommunityName;
  String? id;
  List? Participants;
  int? Streak;
  DateTime? LastActivity;

  DTOCommunity({this.id, this.CommunityName, this.Participants, this.Streak, this.LastActivity});

  factory DTOCommunity.fromJson(Map<dynamic, dynamic> json) {
    return DTOCommunity(
      CommunityName: json['CommunityName'] as String?,
      id: json['id'] as String?,
      Participants: json['Participants'] as List?,
      LastActivity: DateTime.fromMillisecondsSinceEpoch(json['LastActivity'] as int? ?? 1),
      Streak: json['Streak'] as int?
    );
  }

  // toJson metodu
  Map<String, dynamic> toJson() {
    return {
      'Participants': Participants,
      'CommunityName': CommunityName,
      'id': id,
      'Streak': Streak,
      'LastActivity': LastActivity
    };
  }
}
