import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userapp/providers/auth_methods.dart';
import 'package:userapp/providers/auth_provider.dart';
import 'package:userapp/screens/login_screen.dart';
import 'package:userapp/utils.dart';
import 'package:userapp/widgets/textfieldinput.dart';

class EditProfileScreen extends StatefulWidget {
  final editType;
  const EditProfileScreen({
    Key? key,
    required this.editType,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();
  final TextEditingController _deletePasswordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  String university = '';
  String bolum = '';

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _deletePasswordController.dispose();
    _oldpasswordController.dispose();
    _usernameController.dispose();
    _passwordConfirmationController.dispose();
  }

  @override
  void initState() {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

  void updateUser() async {
    setState(() {
      _isLoading = true;
    });

    if (widget.editType == 'password') {
      String res = await AuthMethods().settingsUser(
        oldpassword: _oldpasswordController.text,
        newpassword: _passwordController.text,
      );
      // if string returned is sucess, user has been created
      if (res == "Şifrə uğurla yeniləndi.") {
        setState(() {
          _isLoading = false;
        });
        // navigate to the home screen
        if (context.mounted) {
          showSnackBar(context, res);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        // show the error
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } else if (widget.editType == 'delete') {
      String res = await AuthMethods().settingsUser(deletepassword: _deletePasswordController.text);
      // if string returned is sucess, user has been created
      if (res == "Kaydedildi") {
        setState(() {
          _isLoading = false;
        });
        // navigate to the home screen
        if (context.mounted) {
          showSnackBar(context, res);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        // show the error
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } else if (widget.editType == 'info') {
      String res = await AuthMethods().settingsUser(university: university, bolum: bolum, bio: _bioController.text);
      if (res == "Kaydedildi") {
        setState(() {
          _isLoading = false;
        });
        // navigate to the home screen
        if (context.mounted) {
          showSnackBar(context, res);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        // show the error
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } else {
      if (context.mounted) {
        showSnackBar(context, 'error');
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * .96,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(flex: 1),
                    Image.asset(
                      'assets/icons/logo.png',
                      height: 150,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    widget.editType == 'password'
                        ? Column(
                            children: [
                              TextFieldInput(
                                hintText: 'Cari Şifrə',
                                textInputType: TextInputType.text,
                                textEditingController: _oldpasswordController,
                                isPass: true,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFieldInput(
                                hintText: 'Yeni Şifrə',
                                textInputType: TextInputType.text,
                                textEditingController: _passwordController,
                                isPass: true,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFieldInput(
                                hintText: 'Yeni Şifrə Təkrarı',
                                textInputType: TextInputType.text,
                                textEditingController: _passwordConfirmationController,
                                isPass: true,
                              ),
                            ],
                          )
                        : widget.editType == 'delete'
                            ? Column(
                                children: [
                                  Text(
                                    'Hesabınızı silmək üçün parolunuzu daxil edin',
                                    style: TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Red Hat Display'),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  TextFieldInput(
                                    hintText: 'Şifrə',
                                    textInputType: TextInputType.text,
                                    textEditingController: _deletePasswordController,
                                    isPass: true,
                                  ),
                                ],
                              )
                            : widget.editType == 'info'
                                ? Column(
                                    children: [
                                      TextFieldInput(
                                        hintText: 'Telefon nömrəsi',
                                        textInputType: TextInputType.text,
                                        textEditingController: _bioController,
                                      ),
                                    ],
                                  )
                                : const Center(child: Text('No data')),
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        !_isLoading
                            ? Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Container(
                                        //      width: double.infinity,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: const ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(4)),
                                          ),
                                          color: Colors.grey,
                                        ),
                                        child: const Text(
                                          'Geri',
                                        )),
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: updateUser,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                // width: double.infinity,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: const ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                    ),
                                    color: Colors.blue),
                                child: !_isLoading
                                    ? Text(
                                        widget.editType == 'delete' ? 'Hesabı Sil' : 'Təsdiq',
                                      )
                                    : const CircularProgressIndicator(
                                        color: Colors.blue,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
