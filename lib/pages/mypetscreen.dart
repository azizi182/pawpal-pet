import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pawpal_project_301310/class/pet.dart';
import 'package:pawpal_project_301310/class/user.dart';
import 'package:pawpal_project_301310/ipaddress.dart';
import 'package:pawpal_project_301310/pages/editpetscreen.dart';
import 'package:pawpal_project_301310/pages/loginscreen.dart';
import 'package:pawpal_project_301310/pages/submitpetscreen.dart';

import 'package:pawpal_project_301310/animatedroute.dart';

class Mypetscreen extends StatefulWidget {
  const Mypetscreen({super.key, required this.user});
  final User? user;
  @override
  State<Mypetscreen> createState() => _MypetscreenState();
}

class _MypetscreenState extends State<Mypetscreen> {
  List<petDetails> petList = [];
  late double screenWidth, screenHeight;
  String status = "Loading...";

  @override
  void initState() {
    super.initState();
    loadMyPet();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > 600) {
      screenWidth = 600;
    } else {
      screenWidth = screenWidth;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('My list Pets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              loadMyPet();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Submitpetscreen(user: widget.user),
                ),
              );
            },
          ),
        ],
      ),
      body: widget.user!.userId.toString() == '0'
          ? buildNotLoggedInState(context)
          : Center(
              child: Column(
                children: [
                  petList.isEmpty
                      ? const Text('No pets found.')
                      : Expanded(
                          child: ListView.builder(
                            itemCount: petList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // IMAGE
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          width:
                                              screenWidth *
                                              0.28, // more responsive
                                          height:
                                              screenWidth *
                                              0.22, // balanced aspect ratio
                                          color: Colors.grey[200],
                                          child:
                                              petList[index]
                                                  .imagePaths
                                                  .isNotEmpty
                                              ? Image.network(
                                                  '${ipaddress.baseUrl}/file_put_contents/${petList[index].imagePaths[0]}',
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return const Icon(
                                                          Icons.broken_image,
                                                          size: 60,
                                                        );
                                                      },
                                                )
                                              : Icon(Icons.pets, size: 60),
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      // detail section
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // pet name
                                            Text(
                                              petList[index].petName.toString(),
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                            const SizedBox(height: 4),

                                            // pet type
                                            Text(
                                              "type: ${petList[index].petType}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                            const SizedBox(height: 4),
                                            Text(
                                              "Age: ${petList[index].petAge} years",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                            const SizedBox(height: 4),
                                            Text(
                                              "Category: ${petList[index].category}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                            // DISTRICT TAG
                                          ],
                                        ),
                                      ),

                                      // icon
                                      Column(
                                        children: [
                                          //edit pet icon

                                          //delete pet icon
                                          IconButton(
                                            onPressed: () {
                                              showdeleteDialog(index);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 18,
                                            ),
                                          ),
                                          //arrow icon to details
                                          IconButton(
                                            onPressed: () {
                                              showDetailsPet(index);
                                            },
                                            icon: const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  Text('Welcome, ${widget.user?.userName} !'),
                ],
              ),
            ),
    );
  }

  void loadMyPet() {
    setState(() {
      petList.clear();
    });
    http
        .get(
          Uri.parse(
            '${ipaddress.baseUrl}/api/get_my_pet.php?user_id=${widget.user!.userId}',
          ),
        )
        .then((response) {
          // log(response.body);
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);

            if (jsonResponse['status'] == 'success' &&
                jsonResponse['data'] != null &&
                jsonResponse['data'].isNotEmpty) {
              petList.clear();
              for (var item in jsonResponse['data']) {
                petList.add(petDetails.fromJson(item));
              }
              setState(() {
                status = "";
              });
            } else {
              setState(() {
                petList.clear();
                status = "You have no pets";
              });
            }

            // print(jsonResponse);
          } else {
            setState(() {
              status = "Failed to load data";
            });
          }
        });
  }

  void showDetailsPet(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(petList[index].petName.toString()),
          content: SizedBox(
            width: screenWidth,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 200, // or any fixed height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: petList[index].imagePaths.length,
                      itemBuilder: (context, i) {
                        return Container(
                          margin: EdgeInsets.all(5),
                          width: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              '${ipaddress.baseUrl}/file_put_contents/${petList[index].imagePaths[i]}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, size: 60);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 10),
                  Table(
                    border: TableBorder.all(
                      color: Colors.grey,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                    columnWidths: {
                      0: FixedColumnWidth(100.0),
                      1: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            // use table to detail information
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Name'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(petList[index].petName.toString()),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Description'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                petList[index].description.toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Type'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(petList[index].petType.toString()),
                            ),
                          ),
                        ],
                      ),

                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Gender'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(petList[index].petGender.toString()),
                            ),
                          ),
                        ],
                      ),

                      // pet age
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Age'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(petList[index].petAge.toString()),
                            ),
                          ),
                        ],
                      ),

                      // pet health
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Health'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(petList[index].petHealth.toString()),
                            ),
                          ),
                        ],
                      ),
                      //category
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Category'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(petList[index].category.toString()),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Location'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Lat: ${petList[index].latitude}, Lng: ${petList[index].longitude}',
                              ),
                            ),
                          ),
                        ],
                      ),

                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Owner'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${petList[index].userId}', //\n${petList[index].userName}',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildNotLoggedInState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 56,
                color: Color(0xFF1F3C88),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            const Text(
              "You're not logged in",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              "Please login to access this feature and manage your services.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 24),

            // Action button
            SizedBox(
              width: 200,
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F3C88),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.login),
                label: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    AnimatedRoute.slideFromRight(const Loginscreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  //show delele dialog
  void showdeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this pet?"),
          actions: [
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                deletePet(index);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deletePet(int index) {
    http
        .post(
          Uri.parse('${ipaddress.baseUrl}/api/delete_pet.php'),
          body: {
            'user_id': widget.user!.userId.toString(),
            'pet_id': petList[index].petId.toString(),
          },
        )
        .then((response) {
          log(response.body);
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            if (resarray['status'] == 'success') {
              loadMyPet();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Pet deleted successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Pet deletion failed"),
                  backgroundColor: Colors.red,
                ),
              );
            }
            setState(() {});
          }
        });
  }
}
