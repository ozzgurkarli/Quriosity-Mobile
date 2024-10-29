// ignore_for_file: non_constant_identifier_names, constant_identifier_names

class Localizer
{
  static int index = 0;
  static const List<String> index_text = ["EN", "TR"];
  
  static const List<String> name_surname = ["Ad Soyad", "Name Surname"];
  static const List<String> username = ["Kullanıcı Adı", "Username"];
  static const List<String> e_mail = ["E-mail", "E-mail"];
  static const List<String> password = ["Parola", "Password"];
  static const List<String> again = ["Tekrar", "Again"];
  static const List<String> password_what_password = ["Parola? Ne parolası?", "Password? What password?"];
  static const List<String> login = ["Giriş Yap", "Login"];
  static const List<String> create_an_account_start_asking = ["Hesap oluştur, sormaya başla!", "Create an account, start asking!"];
  static const List<String> dont_panic_if_you_forgot_your_password = ["Parolanı unuttun diye panik yapma! Eğer girdiğin kullanıcı adı ve e-posta birbiriyle iyi anlaşıyorsa, sana yeni bir parola oluşturma bağlantısı göndereceğiz.", "Don’t panic just because you forgot your password! If the username and email address you entered are a good match, we’ll send you a link to create a new password."];
  static const List<String> im_ready = ["Hazırım!", "I’m ready!"];
  static const List<String> just_remembered_account = ["Hesabın olduğunu yeni mi hatırladın?\nGeri dönmek için geç değil.", "Just remembered you have an account?\nIt’s not too late to come back."];
  static const List<String> just_remembered_password = ["Parolanı yeni mi hatırladın?\nGeri dönmek için geç değil.", "Just remembered your password?\nIt’s not too late to come back."];
  static const List<String> your_questions_your_community = ["Senin Soruların,\nSenin Topluluğun.", "Your Questions,\nYour Community."];
  static const List<String> username_cannot_be_less_than_4_characters = ["Kullanıcı adı 4 karakterden az olamaz.", "The username cannot be less than 4 characters."];
  static const List<String> password_cannot_be_less_than_8_characters = ["Parola 8 karakterden az olamaz.", "The password cannot be less than 8 characters."];
  static const List<String> my_communities = ["Topluluklarım", "My Communities"];
  static const List<String> unopened = ["Açılmamış", "Unopened"];
  
  static String Get(List<String> list){
    return list[index];
  }
}