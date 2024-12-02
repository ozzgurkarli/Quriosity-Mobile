// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:math';

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
  static const List<String> invitation_code_cannot_be_less_than_12_characters = ["Davet kodu 12 karakterden az olamaz.", "The invitation code cannot be less than 12 characters."];
  static const List<String> community_name_cannot_be_less_than_4_characters = ["Topluluk adı 4 karakterden az olamaz.", "The community name cannot be less than 4 characters."];
  static const List<String> message_cannot_be_empty = ["Mesaj boş olamaz.", "The message cannot be empty."];
  static const List<String> option_cannot_be_empty = ["Seçenek boş olamaz.", "The option cannot be empty."];
  static const List<String> question_cannot_have_more_than_4_options = ["Kaptan! Bu kadar seçeneği kaldıracak gücümüz yok! En fazla 4’le gidebiliriz!", "Captain! We don’t have the power to handle that many options! We can only go with up to 4!"];
  static const List<String> invalid_email = ["E-mail adresi geçersiz.", "Invalid e-mail address."];
  static const List<String> invalid_namesurname = ["Ad-soyad geçersiz.", "Invalid name-surname."];
  static const List<String> password_and_confirmation_does_not_match = ["Parola ile tekrarı eşleşmiyor.", "Password and confirmation do not match."];
  static const List<String> my_communities = ["Topluluklarım", "My Communities"];
  static const List<String> unopened = ["Açılmamış", "Unopened"];
  static const List<String> check_email_for_link = ["Parola oluşturma bağlantını kontrol etmek için gelen kutunu kontrol edebilirsin.", "You can check your inbox to verify the password creation link."];
  static const List<String> account_created = ["Hesabın oluşturuldu, ama henüz her şey hazır değil! Uygulamayı kullanabilmen için e-mail adresine gönderdiğimiz aktivasyon bağlantısına erişmen gerekiyor.", "Your account has been created, but everything is not ready yet! You need to access the activation link we sent to your email address to use the application."];
  static const List<String> Error = ["Hata", "Error"];
  static const List<String> ok = ["Tamam", "Ok"];
  static const List<String> join = ["Katıl", "Join"];
  static const List<String> create = ["Oluştur", "Create"];
  static const List<String> or = ["ya da", "or"];
  static const List<String> shortened_month = ["a", "mo"];
  static const List<String> shortened_day = ["g", "d"];
  static const List<String> shortened_hour = ["s", "h"];
  static const List<String> shortened_minute = ["d", "m"];
  static const List<String> shortened_second = ["sn", "s"];
  static const List<String> last_activity = ["Son aktivite: ", "Last activity: "];
  static const List<String> ago = [" önce", " ago"];
  static const List<String> invitation_code = ["Davet Kodu", "Invitation Code"];
  static const List<String> community_name = ["Topluluk Adı", "Community Name"];
  static const List<String> create_join_community = ["Topluluk Oluştur/Katıl", "Create/Join Community"];
  static const List<String> language_preference = ["Dil Tercihi", "Language Preference"];
  static const List<String> log_out = ["Çıkış yap", "Log out"];





  static const List<List<String>> community_created = [
    ["Topluluk oluşturuldu! Hadi şimdi arkadaşlarını davet et, soru bombardımanı başlasın!", "Community created! Now invite your friends and let the question bombardment begin!"],
    ["Topluluk tamam! Şimdi biraz eğlenme zamanı... ama önce arkadaşlarını davet et.", "Community ready! Now it's time for some fun... but first, invite your friends."],
    ["Yeni topluluk, yeni maceralar! Hadi, üyeleri topla ve şenlik başlasın.", "New community, new adventures! Gather the members and let the fun begin."],
    ["Topluluk hazır! Şimdi biraz kaos yaratmak için arkadaşlarını çağır.", "Community is set! Now call your friends to stir up some chaos."],
    ["Vay canına, bir topluluk kurdun! Artık geriye sadece bol bol soru sormak kaldı.", "Wow, you created a community! Now all that's left is asking tons of questions."]
  ];
  static const List<List<String>> change_icon = [
    ["Yok artık, bu ikon ben olamam. Ayna da mı yalan söylüyor?", "No way, this icon can't be me. Is the mirror lying too?"],
    ["Bu fotoğrafı ne ara seçtim? Hadi hemen düzeltelim!", "When did i pick this photo? Let's fix it right now!"],
    ["Bu profil fotoğrafıyla ne mesaj vermeye çalışıyorum? Yenilemek şart oldu.", "What message am i trying to send with this photo? Time for a refresh."],
    ["Bu ikonla kimseyi etkileyemem, hadi yenisini bulalım!", "I can't impress anyone with this icon, let's find a new one!"],
    ["Profil fotoğrafı mı? Yoksa 'beni ciddiye almayın' ilanı mı? Hadi değiştir!", "Profile photo? Or a 'don’t take me seriously' ad? Change it now!"]
  ];
  static String Get(List<String> list){
    return list[index];
  }

  static String GetRandom(List<List<String>> list){
    Random rnd = Random();
    return list[rnd.nextInt(list.length)][index];
  }
}