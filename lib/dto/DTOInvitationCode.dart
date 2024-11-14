// ignore_for_file: non_constant_identifier_names

class DTOInvitationCode{
  DateTime? GenerateDate;
  String? InvitationCode;

  DTOInvitationCode({this.InvitationCode, this.GenerateDate});

  factory DTOInvitationCode.fromJson(Map<dynamic, dynamic> json) {
    return DTOInvitationCode(
      InvitationCode: json['InvitationCode'] as String?,
      GenerateDate: DateTime.fromMillisecondsSinceEpoch(json['GenerateDate'] as int? ?? 1)
    );
  }

  // toJson metodu
  Map<String, dynamic> toJson() {
    return {
      'InvitationCode': InvitationCode,
      'GenerateDate': GenerateDate
    };
  }
}
