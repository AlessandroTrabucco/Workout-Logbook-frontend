import 'package:flutter/material.dart';
import 'package:gym_app_fixed/screens/main_screen.dart';
import 'package:provider/provider.dart';

import 'package:google_sign_in/google_sign_in.dart';
import '../providers/user.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const route = '/login';
  @override
  Widget build(BuildContext context) {
    //only for rebuild of widget tree

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 189, 189),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 300),
            child: Text(
              'GYM LOGBOOK',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                  shadows: [
                    Shadow(
                        color: Colors.white,
                        blurRadius: 1.0,
                        offset: Offset.fromDirection(0.2, 0.8))
                  ],
                  fontFamily: 'Roboto'),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 50),
              child: ElevatedButton(
                  onPressed: () async {
                    final provider = Provider.of<User>(context, listen: false);
                    final navigator = Navigator.of(context);
                    try {
                      GoogleSignIn googleSignIn = GoogleSignIn(scopes: []);
                      final user = await googleSignIn.signIn();
                      GoogleSignInAuthentication googleSignInAuthentication =
                          await user!.authentication;
                      await provider.verifyToken(
                          googleSignInAuthentication.idToken ?? '');
                      navigator.pushReplacementNamed(MainScreen.route,
                          arguments: true);
                    } catch (e) {
                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('An error occurred!'),
                          content: const Text('Something went wrong'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Okay'),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                            )
                          ],
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    )),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(right: 5),
                          height: 40,
                          child: Image.asset('assets/images/g-logo.webp')),
                      const Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 19.5,
                          color: Color.fromARGB(255, 113, 113, 113),
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
