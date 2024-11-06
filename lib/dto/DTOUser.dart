// ignore_for_file: non_constant_identifier_names

class DTOUser{
  String? NameSurname;
  String? Username;
  String? CommunityId;
  int? State;
  String? Email;
  String? Password;
  String? uid;
  String? NotificationToken;
  String? UserToken;

  DTOUser({this.NameSurname, this.Username, this.Password, this.UserToken, this.CommunityId, this.State, this.Email, this.uid, this.NotificationToken});

  factory DTOUser.fromJson(Map<dynamic, dynamic> json) {
    return DTOUser(
      NameSurname: json['NameSurname'] as String?,
      Username: json['Username'] as String?,
      CommunityId: json['CommunityId'] as String?,
      State: json['State'] as int?,
      Email: json['Email'] as String?,
      Password: json['Password'] as String?,
      NotificationToken: json['NotificationToken'] as String?,
      UserToken: json['UserToken'] as String?,
      uid: json['uid'] as String?,
    );
  }

  // toJson metodu
  Map<String, dynamic> toJson() {
    return {
      'Username': Username,
      'NameSurname': NameSurname,
      'CommunityId': CommunityId,
      'State': State,
      'Email': Email,
      'UserToken': UserToken,
      'NotificationToken': NotificationToken,
      'Password': Password,
      'uid': uid,
    };
  }
}
