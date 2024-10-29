// ignore_for_file: non_constant_identifier_names

class DTOUser{
  String? NameSurname;
  String? Username;
  String? Email;
  String? Password;
  String? uid;

  DTOUser({this.NameSurname, this.Username, this.Password, this.Email, this.uid});

  factory DTOUser.fromJson(Map<dynamic, dynamic> json) {
    return DTOUser(
      NameSurname: json['NameSurname'] as String?,
      Username: json['Username'] as String?,
      Email: json['Email'] as String?,
      Password: json['Password'] as String?,
      uid: json['uid'] as String?,
    );
  }

  // toJson metodu
  Map<String, dynamic> toJson() {
    return {
      'Username': Username,
      'NameSurname': NameSurname,
      'Email': Email,
      'Password': Password,
      'uid': uid,
    };
  }
}
