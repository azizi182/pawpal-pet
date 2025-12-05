import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pawpal_project_301310/class/user.dart';
import 'package:pawpal_project_301310/ipaddress.dart';
import 'package:pawpal_project_301310/pages/mainscreen.dart';

class Submitpetscreen extends StatefulWidget {
  final User? user;
  const Submitpetscreen({super.key, required this.user});

  @override
  State<Submitpetscreen> createState() => _SubmitpetscreenState();
}

class _SubmitpetscreenState extends State<Submitpetscreen> {
  // declare variables

  List<File> image = [];
  late double height, width;

  late Position mypostion;

  TextEditingController petnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController petdescriptionController = TextEditingController();

  List<String> petTypes = ['Dog', 'Cat', 'Other'];
  String? selectedPetType = 'Cat';

  List<String> category = ['Adoption', 'Donation', 'Help', 'Save', 'Other'];
  String? selectedPetCategory = 'Adoption';

  @override
  Widget build(BuildContext context) {
    // get device size
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if (width > 600) {
      width = 600;
    } else {
      width = width;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Submit Pet Screen')),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),

            child: Column(
              children: [
                // first input: image
                GestureDetector(
                  onTap: () {
                    pickimagedialog();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: height / 3,
                    alignment: Alignment.center,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: image.isEmpty
                        ? Center(
                            child: Image.asset("assets/images/cameraIcon.png"),
                          )
                        : Row(
                            children: image.map((img) {
                              return Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(img),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() => image.remove(img));
                                        },
                                        child: Container(
                                          color: Colors.black54,
                                          padding: EdgeInsets.all(2),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                ),
                SizedBox(height: 10.0),

                // second input: pet name (textfield)
                TextField(
                  controller: petnameController,
                  decoration: InputDecoration(
                    labelText: 'Pet Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10.0),

                // third input: pet type (dropdown)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Pet Type',
                    border: OutlineInputBorder(),
                  ),
                  items: petTypes.map((String selectedType) {
                    return DropdownMenuItem<String>(
                      value: selectedType,
                      child: Text(selectedType),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPetType = newValue!;
                    });
                  },
                ),
                SizedBox(height: 10),

                //  input: address (textfield and live location)
                TextField(
                  maxLines: 3,
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        mypostion = await _determinePosition();
                        // print(mypostion.latitude);
                        //+
                        // print(mypostion.longitude);
                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                              mypostion.latitude,
                              mypostion.longitude,
                            );
                        Placemark place = placemarks[0];
                        addressController.text =
                            "${place.name},\n${place.street},\n${place.postalCode},${place.locality},\n${place.administrativeArea},${place.country}";
                      },
                      icon: Icon(Icons.location_on),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                //  input: pet description(textfield)
                SizedBox(height: 10.0),
                TextField(
                  controller: petdescriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Pet Description',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: category.map((String selectedCategory) {
                    return DropdownMenuItem<String>(
                      value: selectedCategory,
                      child: Text(selectedCategory),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPetCategory = newValue!;
                    });
                  },
                ),

                // submit button
                SizedBox(height: 10.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 238, 176, 83),
                    ),
                    icon: const Icon(
                      Icons.sentiment_very_satisfied_sharp,
                      size: 24,
                      color: Colors.white,
                    ),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Submit",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    onPressed: finishdialog,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pickimagedialog() {
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
    if (image.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only upload up to 3 images.')),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        image.add(File(pickedFile.path));
      });
    }
  }

  Future<void> openGallery() async {
    if (image.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only upload up to 3 images.')),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image.add(File(pickedFile.path));
      });
    }
  }

  void finishdialog() {
    String name = petnameController.text;
    String type = selectedPetType.toString();
    String category = selectedPetCategory.toString();
    String address = addressController.text;
    String description = petdescriptionController.text;

    // handling error
    if (name.isEmpty ||
        type.isEmpty ||
        description.isEmpty ||
        address.isEmpty ||
        category.isEmpty ||
        image.isEmpty) {
      SnackBar snackBar = SnackBar(
        // pop message on the bottom of the screen
        content: Text("Please fill in all the fields."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    //check textfield
    if (addressController.text.isEmpty) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please enter an address'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (mypostion.latitude.isNaN || mypostion.longitude.isNaN) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please select an address'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmation this pet?"),
        content: Text("Are you sure you want to submit this pet?"),
        actions: [
          TextButton(
            onPressed: () => {
              addPet(),
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Mainscreen(user: widget.user),
                ),
              ),
              Navigator.pop(context),
            },
            child: Text("Submit"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied,and  requesting permissions again

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    // can continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  addPet() {
    List<String> base64Image = image.map((img) {
      return base64Encode(img.readAsBytesSync());
    }).toList();
    String name = petnameController.text;
    String description = petdescriptionController.text;
    http
        .post(
          Uri.parse('${ipaddress.baseUrl}/lab_asg2/api/submit_pet.php'),

          body: {
            'user_id': widget.user?.userId,
            'pet_name': name,
            'pet_type': selectedPetType,
            'pet_category': selectedPetCategory,
            'description': description,
            'latitude': mypostion.latitude.toString(),
            'longitude': mypostion.longitude.toString(),
            'image': jsonEncode(base64Image),
          },
        )
        .then((response) {
          //print(response.body);
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            print(resarray['status']);
            print(resarray['message']);
            if (resarray['status'] == 'success') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        });
  }
}
