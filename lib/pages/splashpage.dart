import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal_project_301310/class/user.dart';
import 'package:pawpal_project_301310/ipaddress.dart';
import 'package:pawpal_project_301310/pages/homescreen.dart';
import 'package:pawpal_project_301310/pages/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashpage extends StatefulWidget {
  const Splashpage({super.key});

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    autologin();
  }

  void autologin() {
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('rememberMe');
      if (rememberMe != null && rememberMe) {
        email = prefs.getString('email') ?? 'NA';
        password = prefs.getString('password') ?? 'NA';
        http
            .post(
              Uri.parse('${ipaddress.baseUrl}/api/login.php'),
              body: {'email': email, 'password': password},
            )
            .then((response) {
              if (response.statusCode == 200) {
                var jsonResponse = response.body;
                // print(jsonResponse);
                var resarray = jsonDecode(jsonResponse);
                if (resarray['status'] == 'success') {
                  //print(resarray['data'][0]);
                  User user = User.fromJson(resarray['data'][0]);
                  if (!mounted) return;
                  Future.delayed(Duration(seconds: 2), () {
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Homescreen(user: user),
                      ),
                    );
                  });
                } else {
                  Future.delayed(Duration(seconds: 3), () {
                    if (!mounted) return;
                    User user = User(
                      userId: '0',
                      userName: 'Guest',
                      userEmail: 'guest@email.com',
                      userPassword: 'guest',
                      userPhone: '0000000000',
                      userRegdate: '0000-00-00',
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Homescreen(user: user),
                      ),
                    );
                  });
                }
              } else {
                Future.delayed(Duration(seconds: 3), () {
                  if (!mounted) return;
                  User user = User(
                    userId: '0',
                    userName: 'Guest',
                    userEmail: 'guest@email.com',
                    userPassword: 'guest',
                    userPhone: '0000000000',
                    userRegdate: '0000-00-00',
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Homescreen(user: user),
                    ),
                  );
                });
              }
            });
      } else {
        Future.delayed(Duration(seconds: 3), () {
          if (!mounted) return;
          User user = User(
            userId: '0',
            userName: 'Guest',
            userEmail: 'guest@email.com',
            userPassword: 'guest',
            userPhone: '0000000000',
            userRegdate: '0000-00-00',
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homescreen(user: user)),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            Text(
              'PawPal Pet Application'
              ' Adoption & Donation',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 236, 160, 38),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
