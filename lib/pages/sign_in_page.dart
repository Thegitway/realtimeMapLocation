import 'package:delivery/pages/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auth_buttons/auth_buttons.dart'
    show GoogleAuthButton, AuthButtonStyle, AuthButtonType;

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool isGoogleLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signOutGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await auth.signOut();
    } catch (e) {}
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    User? user;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
      } catch (e) {}
    }

    return user;
  }

  double buttonHeight = 50;
  Size scrSize = const Size(1, 1);
  @override
  Widget build(BuildContext context) {
    scrSize = MediaQuery.of(context).size;
    return Scaffold(
      body: //google
          Center(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: scrSize.height * 0.06, top: scrSize.height * 0.014),
          child: GoogleAuthButton(
            text: "Google",
            style: AuthButtonStyle(
              borderRadius: 40,
              iconSize: scrSize.height * 0.03,
              iconBackground: Colors.white,
              elevation: 0,
              progressIndicatorColor: Theme.of(context).hintColor,
              progressIndicatorValueColor: Colors.white,
              buttonType: AuthButtonType.secondary,
              splashColor: Colors.black12,
              textStyle: Theme.of(context)
                  .textTheme
                  .button
                  ?.apply(color: Colors.white, fontSizeDelta: 2),
              height: buttonHeight,
              width: scrSize.width * 0.9,
            ),
            isLoading: isGoogleLoading,
            onPressed: () async {
              setState(() {
                isGoogleLoading = true;
              });

              await signOutGoogle();
              //sign out
              User? user = await signInWithGoogle(context: context);

              setState(() {
                isGoogleLoading = false;
              });

              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            title: "Delivery PFA",
                            user: user,
                          )));
            },
          ),
        ),
      ),
    );
  }
}
