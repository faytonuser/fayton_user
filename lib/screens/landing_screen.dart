import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userapp/common/waiting_indicator.dart';
import 'package:userapp/models/profile_model.dart';
import 'package:userapp/providers/auth_provider.dart';
import 'package:userapp/screens/custom_navigation_bar.dart';
import 'package:userapp/screens/login_screen.dart';
import 'package:userapp/services/auth_service.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    auth.FirebaseAuth.instance.currentUser?.reload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<auth.User?>(
      stream: auth.FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.providerData.length == 1) {
            return VerificationLandingScreen(userId: snapshot.data!.uid);
          } else {
            // logged in using other providers
            return LoginScreen();
          }
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

class VerificationLandingScreen extends StatefulWidget {
  final String userId;
  const VerificationLandingScreen({super.key, required this.userId});

  @override
  State<VerificationLandingScreen> createState() => _VerificationLandingScreenState();
}

class _VerificationLandingScreenState extends State<VerificationLandingScreen> {
  @override
  void initState() {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authProvider.getCurrentUserFuture = AuthService.getCurrentUser(widget.userId);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: FutureBuilder<ProfileModel?>(
        future: authProvider.getCurrentUserFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CustomWaitingIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return CustomNavigationBar(
              currentUser: snapshot.data,
            );
          } else if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return CustomNavigationBar(
              currentUser: snapshot.data,
            );
          } else {
            return Stack(
              fit: StackFit.expand,
              children: [
                Center(child: Text(snapshot.error.toString())),
                Positioned(
                  top: 50,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: () async {
                      await AuthService.signOut();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LandingScreen()));
                    },
                    child: Text("Sign Out"),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
