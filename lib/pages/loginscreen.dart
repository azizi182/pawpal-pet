import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pawpal_project_301310/class/user.dart';
import 'package:pawpal_project_301310/ipaddress.dart';
import 'package:pawpal_project_301310/pages/homescreen.dart';
//import 'package:pawpal_project_301310/pages/mainscreen.dart';
import 'package:pawpal_project_301310/pages/registerscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  bool checkBox = false;
  bool visible = true;
  late User user;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 176, 83),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 242, 237, 229),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color.fromARGB(255, 9, 9, 9),
                width: 2,
              ),
            ),

            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),

              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),

                  SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 20),

                  TextField(
                    controller: passwordController,
                    obscureText: visible,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (visible) {
                            visible = false;
                          } else {
                            visible = true;
                          }
                          setState(() {});
                        },
                        icon: Icon(Icons.visibility),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Text("Remember Me"),
                      Checkbox(
                        value: checkBox,
                        onChanged: (value) {
                          checkBox = value!;
                          setState(() {});
                          if (checkBox) {
                            if (emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              prefUpdate(checkBox);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Saved!",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        11,
                                        11,
                                        11,
                                      ),
                                      fontSize: 18,
                                    ),
                                  ),

                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    13,
                                    141,
                                    109,
                                  ),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                      "Please fill all inputs before clicking Remember Me",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("OK"),
                                      ),
                                    ],
                                    backgroundColor: Color.fromARGB(
                                      255,
                                      255,
                                      254,
                                      254,
                                    ),
                                  );
                                },
                              );

                              setState(() {
                                checkBox = false;
                              });
                            }
                          } else {
                            prefUpdate(checkBox);
                            if (emailController.text.isEmpty &&
                                passwordController.text.isEmpty) {
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Removed!",
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      12,
                                      12,
                                      12,
                                    ),
                                    fontSize: 18,
                                  ),
                                ),
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  141,
                                  13,
                                  56,
                                ),
                              ),
                            );
                            emailController.clear();
                            passwordController.clear();
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      loginUser();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 15,
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Registerscreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Dont have an account? Sign up',
                      style: TextStyle(color: Colors.orange, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void prefUpdate(bool checkBox) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (checkBox) {
      prefs.setString('email', emailController.text);
      prefs.setString('password', passwordController.text);
      prefs.setBool('rememberMe', checkBox);
    } else {
      prefs.remove('email');
      prefs.remove('password');
      prefs.remove('rememberMe');
    }
  }

  void loadPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('rememberMe');

      if (rememberMe != null && rememberMe) {
        String? email = prefs.getString('email');
        String? password = prefs.getString('password');

        emailController.text = email ?? '';
        passwordController.text = password ?? '';
        checkBox = true;

        setState(() {});
      }
    });
  }

  void loginUser() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in email and password"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    http
        .post(
          Uri.parse('${ipaddress.baseUrl}/api/login_user.php'),
          body: {'email': email, 'password': password},
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            print(resarray['status']);
            print(resarray['message']);

            if (resarray['status'] == 'success' && resarray['data'] != null) {
              user = User.fromJson(resarray['data'][0]);

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Login successful"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
              // Navigate to home screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Homescreen(user: user)),
              );
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Login failed: ${response.statusCode}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
  }
}
