import 'package:flutter/material.dart';
import 'package:pawpal_project_301310/pages/registerscreen.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  bool checkBox = false;
  bool visible = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                    ),
                  ),
                  SizedBox(height: 20),

                  TextField(
                    controller: passwordController,
                    obscureText: visible,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
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
                          // value is time press
                          checkBox = value!;
                          setState(() {});
                          if (checkBox) {
                            if (emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              // prefUpdate(checkBox);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Preference stored!",
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
                            // prefUpdate(checkBox);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Preferences Removed!",
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
                      // Handle login action
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
                      'Dont have an account? Sign up.?',
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
}
