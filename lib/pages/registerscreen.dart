import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pawpal_project_301310/ipaddress.dart';
import 'package:pawpal_project_301310/pages/loginscreen.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool visible = true;
  bool loading = false;

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
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 43, 149, 230),
                    ),
                  ),
                  SizedBox(height: 20),

                  TextField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 10),

                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Number Phone',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 10),

                  TextField(
                    controller: passwordController,
                    obscureText: visible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.password),
                    ),
                  ),
                  SizedBox(height: 10),

                  TextField(
                    controller: confirmPasswordController,
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
                  SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      registerDialog();
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 43, 149, 230),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Loginscreen()),
                      );
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 43, 149, 230),
                        fontSize: 16,
                      ),
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

  void registerDialog() {
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      SnackBar snackBar = SnackBar(
        // pop message on the bottom of the screen
        content: Text("Please fill in all the fields."),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    //email handling
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      SnackBar snackBar = SnackBar(
        content: Text("Please enter a valid email address."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (password.length < 6) {
      SnackBar snackBar = SnackBar(
        content: Text("Password must be at least 6 characters."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    //password handling
    if (password != confirmPassword) {
      SnackBar snackBar = SnackBar(content: Text("Password do not match."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Register this account?"),
        content: Text("Are you sure you want to register this account?"),
        actions: [
          TextButton(
            onPressed: () => {
              registerUser(name, email, password, phone),
              Navigator.pop(context),
            },
            child: Text("Register"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void registerUser(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    setState(() {
      loading = true;
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Registering..."),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );

    await http
        .post(
          Uri.parse("${ipaddress.baseUrl}/lab_asg2/api/register_user.php"),
          body: {
            // parameters to send to backend
            "name": name,
            "phone": phone,
            "email": email,
            "password": password,
          },
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var msgArray = jsonDecode(
              jsonResponse,
            ); // convert from json type(backend) to array msg (frontend)

            if (msgArray['status'] == "success") {
              if (!mounted) return;

              SnackBar snackBar = SnackBar(
                content: Text(msgArray['message']),
                backgroundColor: Colors.green,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              if (loading) {
                if (!mounted) return;
                Navigator.pop(context);
                setState(() {
                  loading = false;
                });
              }
              Navigator.pop(context); // close the register page
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Loginscreen()),
              );
              // failed register handling
            } else if (msgArray['status'] == "failed") {
              if (!mounted) return;
              SnackBar snackBar = SnackBar(
                content: Text(msgArray['message']),
                backgroundColor: Colors.orange,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              // for duplicate email handling
            } else if (msgArray['status'] == "duplicate") {
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Email already registered"),
                  backgroundColor: Colors.red,
                ),
              );
              //another error handling
            } else {
              if (!mounted) return;

              SnackBar snackBar = SnackBar(
                content: Text(msgArray['message']),
                backgroundColor: Colors.red,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          } else {
            print(response.statusCode);
            if (!mounted) return;
            SnackBar snackBar = SnackBar(
              content: Text("Registration error. Please try again."),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        })
        .timeout(
          //server crash or no response
          Duration(seconds: 10),
          onTimeout: () {
            if (!mounted) return;
            SnackBar snackBar = SnackBar(
              content: Text("Request timed out. Please try again."),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        );

    if (loading) {
      if (!mounted) return;
      Navigator.pop(context); // Close the loading dialog
      setState(() {
        loading = false;
      });
    }
  }
}
