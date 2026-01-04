import 'package:flutter/material.dart';
import 'package:pawpal_project_301310/class/user.dart';
import 'package:pawpal_project_301310/pages/donationscreen.dart';
import 'package:pawpal_project_301310/pages/loginscreen.dart';
import 'package:pawpal_project_301310/pages/mainscreen.dart';
import 'package:pawpal_project_301310/pages/mypetscreen.dart';
import 'package:pawpal_project_301310/pages/profilescreen.dart';
import 'package:pawpal_project_301310/pages/submitpetscreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key, required this.user});
  final User? user;

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool isGuest() {
    return widget.user == null || widget.user!.userId == "0";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 218, 176),

      appBar: AppBar(
        title: const Text(
          'Home Screen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_people_rounded,
                      size: 40,
                      color: Color.fromARGB(255, 141, 102, 25),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "Welcome, ${widget.user?.userName ?? 'Guest'}\n your id is ${widget.user?.userId ?? '0'}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 50),

            //profile
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 238, 176, 83),
                ),
                icon: const Icon(
                  Icons.person_3_outlined,
                  size: 24,
                  color: Colors.white,
                ),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "My Profile",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                onPressed: () {
                  if (isGuest()) {
                    showGuestDialog();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profilescreen(user: widget.user),
                      ),
                    );
                  }
                },
              ),
            ),

            SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 238, 176, 83),
                ),
                icon: const Icon(Icons.add, size: 24, color: Colors.white),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Submit a Pet",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                onPressed: () {
                  if (isGuest()) {
                    showGuestDialog();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Submitpetscreen(user: widget.user),
                      ),
                    );
                  }
                },
              ),
            ),

            SizedBox(height: 15),

            // All LIST ANIMALS BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 238, 176, 83),
                ),
                icon: const Icon(Icons.list_alt, size: 24, color: Colors.white),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "All List Animals",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Mainscreen(user: widget.user),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 15),

            const SizedBox(height: 15),

            // LOGOUT BUTTON (RED)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                icon: const Icon(Icons.logout, size: 24, color: Colors.white),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Logout",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Loginscreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  //dialog guest
  void showGuestDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Registration Required"),
        content: const Text(
          "You must register or login to access this feature.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Loginscreen()),
              );
            },
            child: const Text("Register / Login"),
          ),
        ],
      ),
    );
  }
}
