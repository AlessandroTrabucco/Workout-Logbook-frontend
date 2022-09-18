import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import './login_screen.dart';
import '../providers/user.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 350),
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.network(
                  user.imageUrl,
                ),
              ),
            ),
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                child: Text(
                  '${user.name} are you sure you want to logout?',
                  style: const TextStyle(fontSize: 18),
                )),
            TextButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                const storage = FlutterSecureStorage();
                await storage.delete(key: 'jwt');
                navigator.pushReplacementNamed(LoginScreen.route);
              },
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 21, fontFamily: 'Roboto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
