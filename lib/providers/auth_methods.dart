import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;



  Future<String> settingsUser({
    ///  required String email,
    String? deletepassword,
    String? newpassword,
    String? oldpassword,
    String? passwordConfirmation,
    String? username,
    String? university,
    String? bolum,
    String? bio,
    }) async {
    String res = "Some error Occurred";

    if (passwordConfirmation == newpassword) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (newpassword != null) {
          if (user != null) {
            final cred = EmailAuthProvider.credential(
                email: user.email!, password: oldpassword!);

            await user.reauthenticateWithCredential(cred).then((value) {
              user.updatePassword(newpassword).then((_) {
                print('Kullanıcı parolası güncellendi');
                res = 'Şifrə uğurla yeniləndi.';
              }).catchError((error) {
                res = 'Hata-12';
              });
              res = 'Kaydedildi';
            }).catchError((err) {
              res = 'Hata-13';
            });
          }
        } else if (deletepassword != null) {
          try {
            User? user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              String password = deletepassword;
              AuthCredential credential = EmailAuthProvider.credential(
                  email: user.email!, password: password);
              await user.reauthenticateWithCredential(credential);

              // Kullanıcının hesabını sil
              await user.delete();

              print("Hesap başarıyla silindi.");
              res = 'Kaydedildi';
            } else {
              print("Kullanıcı oturum açmamış.");
              res = 'Hata-14';
            }
          } catch (e) {
            print("Hesap silme hatası: $e");
            res = 'Hata-15';
          }
        } else if (username != null) {
          if (user != null) {
            Map<String, dynamic> toJson() => {
                  "username": username,
                };

            // adding user in our database
            await _firestore.collection("users").doc(user.uid).update(toJson());
            print('Kullanıcı adı güncellendi.');
            res = 'Kaydedildi';
          }
        } else {
          if (user != null) {
            Map<String, dynamic> toJson() => {
                  "phoneNumber": bio,
                };

            // adding user in our database
            await _firestore.collection("users").doc(user.uid).update(toJson());
            print('Kullanıcı bilgileri güncellendi.');
            res = 'Kaydedildi';
          }
        }
      } catch (error) {
        print('Hata oluştu: $error');
        return error.toString();
      }
    }
    else {
      res = "Şifrələr eyni deyil";
    }
    return res;
  }

}