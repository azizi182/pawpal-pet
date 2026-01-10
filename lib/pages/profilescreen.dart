import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pawpal_project_301310/class/user.dart';
import 'package:pawpal_project_301310/ipaddress.dart';
import 'package:pawpal_project_301310/pages/approvedscreen.dart';
import 'package:pawpal_project_301310/pages/approvescreen.dart';
import 'package:pawpal_project_301310/pages/mydonationscreen.dart';
import 'package:pawpal_project_301310/pages/mypetscreen.dart';

class Profilescreen extends StatefulWidget {
  User? user;
  Profilescreen({super.key, required this.user});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  File? profileImage;
  bool isLoading = false;

  bool isEditing = false; // first time sign-in → editable

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user?.userName ?? '';
    emailController.text = widget.user?.userEmail ?? '';
    phoneController.text = widget.user?.userPhone ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          TextButton(
            onPressed: () {
              if (isEditing) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Confirm Save"),
                    content: const Text(
                      "Are you sure you want to save changes to your profile?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          updateProfile();
                          setState(() {
                            isEditing = false;
                          });
                        },
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                );
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
            child: Text(
              isEditing ? 'SAVE' : 'EDIT',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              loadProfile();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// PROFILE IMAGE
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: profileImage != null
                        ? FileImage(profileImage!)
                        : (widget.user?.userImage != null &&
                                      widget.user!.userImage!.isNotEmpty
                                  ? NetworkImage(
                                      '${ipaddress.baseUrl}/image_profile/${widget.user!.userImage}',
                                    )
                                  : null)
                              as ImageProvider?,
                    child:
                        (profileImage == null &&
                            (widget.user?.userImage == null ||
                                widget.user!.userImage!.isEmpty))
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
                  ),

                  if (isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: pickimagedialog,
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor: Color.fromARGB(255, 238, 176, 83),
                          child: Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //USER INFO
            _buildTextField('Name', nameController),
            _buildTextField('Email', emailController),
            _buildTextField('Phone', phoneController),

            const SizedBox(height: 30),

            //my pet
            _buildSection(
              title: 'My Pets',
              icon: Icons.pets,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Mypetscreen(user: widget.user),
                  ),
                );
              },
            ),

            //approve adopt - owner pet luluskan
            _buildSection(
              title: 'Approve Adoption',
              icon: Icons.check_circle,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Approvescreen(user: widget.user),
                  ),
                );
              },
            ),

            //approved adopt - new owner tunggu dh luluske
            _buildSection(
              title: 'Approved Adoption',
              icon: Icons.question_mark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Approvedscreen(user: widget.user),
                  ),
                );
              },
            ),

            //My Donation
            _buildSection(
              title: 'My Wallet & Donations',
              icon: Icons.attach_money,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Mydonationscreen(user: widget.user),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        enabled: isEditing,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Color.fromARGB(255, 238, 176, 83)),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void pickimagedialog() {
    if (!isEditing) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  openCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  openGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> updateProfile() async {
    setState(() => isLoading = true);
    final response = await http.post(
      Uri.parse('${ipaddress.baseUrl}/api/update_profile.php'),
      body: {
        'user_id': widget.user?.userId,
        'user_name': nameController.text,
        'user_phone': phoneController.text,
        'user_email': emailController.text,
        'image': profileImage != null
            ? base64Encode(profileImage!.readAsBytesSync())
            : '',
      },
    );

    if (response.statusCode == 200) {
      log(response.body);
      var resarray = jsonDecode(response.body);
      if (resarray['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully"),
            backgroundColor: Colors.green,
          ),
        );
        loadProfile();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resarray['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() => isLoading = false);
  }

  void loadProfile() async {
    http
        .get(
          Uri.parse(
            '${ipaddress.baseUrl}/api/get_my_profile.php?user_id=${widget.user?.userId}',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            log(response.body);
            if (resarray['status'] == 'success') {
              //print(resarray['data'][0]);
              User user = User.fromJson(resarray['data'][0]);
              widget.user = user;
              nameController.text = user.userName ?? '';
              emailController.text = user.userEmail ?? '';
              phoneController.text = user.userPhone ?? '';

              //image
              if (user.userImage != null && user.userImage!.isNotEmpty) {
                setState(() {
                  profileImage = null;
                });
              }
              setState(() {});
            }
          }
        });
  }
}
