import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:userapp/models/profile_model.dart';
import 'package:userapp/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _smsCodeController = TextEditingController();
  TextEditingController get smsCodeController => _smsCodeController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get phoneController => _phoneController;
  final TextEditingController _identityNumberController = TextEditingController();
  TextEditingController get identityNumberController => _identityNumberController;
  TextEditingController _plateController = TextEditingController();
  TextEditingController get plateController => _plateController;
  TextEditingController _manufaturerController = TextEditingController();
  TextEditingController get manufaturerController => _manufaturerController;
  final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _loginEmailController = TextEditingController();
  TextEditingController get loginEmailController => _loginEmailController;
  final TextEditingController _loginPasswordController = TextEditingController();
  TextEditingController get loginPasswordController => _loginPasswordController;
  TextEditingController _supportMailController = TextEditingController();
  TextEditingController get supportMailController => _supportMailController;
  TextEditingController get familyNameController => _familyNameController;
  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber;
  set phoneNumber(value) {
    _phoneNumber = value;
    notifyListeners();
  }

  File? _frontDriverLicense;
  File? get fronDriverLicense => _frontDriverLicense;
  set fronDriverLicense(value) {
    _frontDriverLicense = value;
    notifyListeners();
  }

  String? _selectedPhoneCode;
  String? get selectedPhoneCode => _selectedPhoneCode;
  set selectedPhoneCode(value) {
    _selectedPhoneCode = value;
    notifyListeners();
  }

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;
  set isPasswordVisible(value) {
    _isPasswordVisible = value;
    notifyListeners();
  }

  File? _facePhoto;
  File? get facePhoto => _facePhoto;
  set facePhoto(value) {
    _facePhoto = value;
    notifyListeners();
  }

  File? _backDriverLincese;
  File? get backDriverLicense => _backDriverLincese;
  set backDriverLicense(value) {
    _backDriverLincese = value;
    notifyListeners();
  }

  late String _verificationId;

  String get verificationId => _verificationId;
  set verificationId(value) {
    _verificationId = value;
    notifyListeners();
  }

  String? _currentUSerProfilePicture;
  String? get currentUserProfilePicture => _currentUSerProfilePicture;
  set currentUserProfilePicture(value) {
    _currentUSerProfilePicture = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  ProfileModel? _currentUser;
  ProfileModel? get currentUser => _currentUser;
  set currentUser(value) {
    _currentUser = value;
    notifyListeners();
  }

  bool _isTermsAccepted = false;
  bool get isTermsAccepted => _isTermsAccepted;
  set isTermsAccepted(bool value) {
    _isTermsAccepted = value;
    notifyListeners();
  }

  final TextEditingController _passwordAgainController = TextEditingController();
  TextEditingController get passwordAgainController => _passwordAgainController;
  final TextEditingController _userNameController = TextEditingController();
  TextEditingController get userNameController => _userNameController;
  Client _client = Client();

  Client get client => _client;
  bool isLoggedIn() {
    if (auth.currentUser == null) {
      return false;
    } else {
      return true;
    }
  }

  model.Token? _token;
  model.Token? get token => _token;
  set token(value) {
    _token = value;
    notifyListeners();
  }

  Future<UserCredential> signupWithEmail() async {
    try {
      isLoading = true;
      var response = await AuthService.createUserWithEmailAndPassword(emailController.text, passwordAgainController.text);
      if (response.user != null) {
        var response = await addUserToDb();
        isLoading = false;
      }
      isLoading = false;
      return response;
    } catch (e) {
      isLoading = false;
      throw Exception(e);
    }
  }

  Future<bool> deleteUser() async {
    var response = await AuthService.deleteUser(currentUser!.userId);

    if (response == true) {
      await FirebaseAuth.instance.signOut();
      return true;
    } else {
      return false;
    }
  }

  Future<void> sendSms(BuildContext context) async {
    try {
      isLoading = true;
      final Account account = Account(client);

      token = await account.createPhoneToken(
        userId: ID.unique(),
        phone: selectedPhoneCode! + phoneController.text.trim().replaceAll(" ", ""),
      );
      isLoading = false;
    } on AppwriteException {
      rethrow;
    }
  }

  String? _otpCode;

  String? get otpCode => _otpCode;
  set otpCode(value) {
    _otpCode = value;
    // notifyListeners();
  }

  String? currentUserId() {
    return auth.currentUser?.uid;
  }

  Future<ProfileModel?>? _getCurrentUserFuture = null;
  Future<ProfileModel?>? get getCurrentUserFuture => _getCurrentUserFuture;
  set getCurrentUserFuture(value) {
    _getCurrentUserFuture = value;
    notifyListeners();
  }

  Future<model.Session> verifyOTP({
    required String userId,
    required String otp,
  }) async {
    try {
      final Account account = Account(client);

      final session = await account.updatePhoneSession(
        userId: userId,
        secret: otp,
      );
      return session;
    } catch (e) {
      rethrow;
    }
  }
  // Future<void> sendSms(BuildContext context) async {
  //   FirebaseAuth _auth = FirebaseAuth.instance;
  //   try {
  //     isLoading = true;
  //     await _auth.verifyPhoneNumber(
  //         phoneNumber: phoneNumber,
  //         timeout: const Duration(seconds: 60),
  //         verificationCompleted: (value) async {
  //           try {
  //             var user = await auth.signInWithCredential(
  //               AuthCredential(
  //                   providerId: value.providerId,
  //                   signInMethod: value.signInMethod),
  //             );
  //             currentUser = await AuthService.getCurrentUser(user.user!.uid);

  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (_) => LoginScreen(),
  //               ),
  //             );
  //           } catch (e) {
  //             throw Exception();
  //           }
  //         },
  //         verificationFailed: (value) {
  //           isLoading = false;
  //           ScaffoldMessenger.of(context)
  //               .showSnackBar(SnackBar(content: Text("Sms failed")));
  //         },
  //         codeSent: (value, code) {
  //           isLoading = false;
  //           verificationId = value;
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (_) => SmsConfirmationScreen(),
  //             ),
  //           );
  //         },
  //         codeAutoRetrievalTimeout: (value) {});
  //   } catch (e) {
  //     isLoading = false;

  //     throw Exception(e);
  //   }
  // }
  Future<void> refreshUser(String userId) async {
    currentUser = await AuthService.getCurrentUser(userId);
    notifyListeners();
  }

  Future<String> uploadProfilePicture(File profile) async {
    try {
      isLoading = true;
      var response = await storage.ref('profile_pictures').child(currentUser!.userId).putFile(profile);

      var downloadUrl = await storage.ref('profile_pictures').child(currentUser!.userId).getDownloadURL();
      await firestore.collection('users').doc(currentUser!.userId).set({"profileUrl": downloadUrl}, SetOptions(merge: true));
      isLoading = false;
      return downloadUrl;
    } catch (e) {
      isLoading = false;
      throw Exception(e);
    }
  }

  String? _deviceToken;
  String? get deviceToken => _deviceToken;
  set deviceToken(value) {
    _deviceToken = value;
    notifyListeners();
  }

  Future<void> setToken({String? userId}) async {
    try {
      FirebaseMessaging.instance.getToken().then((token) async {
        if (token == null) {
          throw Exception("token could not set");
        }
        deviceToken = token;
        if (userId != null) {
          await AuthService.setDeviceToken(userId, token!);
        }
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<UserCredential> signInWithEmail() async {
    try {
      isLoading = true;
      final credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: loginEmailController.text, password: loginPasswordController.text);
      isLoading = false;

      return credential;
    } on FirebaseAuthException catch (e) {
      print("LOGIN ERROR CODE  ******   ${e.code}");
      isLoading = false;
      if (e.code == 'user-not-found') {
        throw Exception('Bu hesab mövcud deyil.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Parol yalnışdır zəhmət olmasa parolu yenidən daxil edin');
      } else if (e.code == 'user-disabled') {
        throw Exception('İstifadəçi hesabı administrator tərəfindən deaktiv edilmişdir.');
      } else if (e.code == 'too-many-requests') {
        throw Exception('Bu hesaba giriş üçün çox sayda sorğu göndərilib.');
      } else if (e.code == 'operation-not-allowed') {
        throw Exception('Server xətası, zəhmət olmasa daha sonra yenidən cəhd edin.');
      } else {
        throw Exception('Giriş uğursuz oldu. Zəhmət olmasa yenidən cəhd edin.');
      }
    } catch (e) {
      isLoading = false;
      throw Exception('Gözlənilməz bir xəta baş verdi. Zəhmət olmasa yenidən cəhd edin.');
    }
  }

  Future<ProfileModel> addUserToDb() async {
    isLoading = true;
    FirebaseFirestore client = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.currentUser;
    var profileModel = ProfileModel(
        identityNumber: identityNumberController.text,
        name: nameController.text,
        userId: auth.currentUser!.uid,
        email: emailController.text,
        familyName: familyNameController.text,
        profileUrl: "",
        username: userNameController.text,
        age: 12,
        description: "21",
        phoneNumber: "+994" + phoneController.text,
        deviceToken: deviceToken ?? "",
        lastName: familyNameController.text);
    try {
      await client.collection('users').doc(auth.currentUser!.uid).set(
            profileModel.toJson(),
          );
      FirebaseChatCore.instance.setConfig(FirebaseChatCoreConfig(null, "rooms", "chatUsers"));
      await FirebaseChatCore.instance.createUserInFirestore(
          types.User(id: auth.currentUser!.uid, firstName: nameController.text, lastName: familyNameController.text, imageUrl: ""));
    } catch (e) {
      isLoading = false;

      throw Exception(e);
    }

    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      if (fronDriverLicense != null) {
        var ref = storage.ref("driver_licenses").child('front-${auth.currentUser!.uid}');
        ref.putFile(fronDriverLicense!);
      }
      if (backDriverLicense != null) {
        var ref = storage.ref("driver_licenses").child('back-${auth.currentUser!.uid}');
        ref.putFile(fronDriverLicense!);
      }
      if (facePhoto != null) {
        var ref = storage.ref("faces").child('face-${auth.currentUser!.uid}');
        ref.putFile(fronDriverLicense!);
      }
    } catch (e) {
      isLoading = false;
    }
    isLoading = false;
    return profileModel;
  }
}
