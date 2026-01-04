import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pawpal_project_301310/class/pet.dart';
import 'package:pawpal_project_301310/class/user.dart';
import 'package:pawpal_project_301310/ipaddress.dart';
//import 'package:pawpal_project_301310/pages/homescreen.dart';
import 'package:pawpal_project_301310/pages/submitpetscreen.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key, required this.user});

  final User? user;
  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  List<petDetails> petList = [];
  late double screenWidth, screenHeight;
  String status = "Loading...";

  List<String> petTypes = ['Dog', 'Cat', 'Horse', 'Rabbit', 'Other'];
  String? selectedPetType = 'Cat';
  late petDetails selectedPet;

  bool isGuest() {
    return widget.user == null || widget.user!.userId == "0";
  }

  @override
  void initState() {
    super.initState();
    loadData('');
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
        title: Text('Public Pets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_alt),
            onPressed: () {
              showFilterDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearchDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              loadData('');
            },
          ),
        ],
      ),
      body: Center(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // IMAGE
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width:
                                        screenWidth * 0.28, // more responsive
                                    height:
                                        screenWidth *
                                        0.22, // balanced aspect ratio
                                    color: Colors.grey[200],
                                    child: petList[index].imagePaths.isNotEmpty
                                        ? Image.network(
                                            '${ipaddress.baseUrl}/file_put_contents/${petList[index].imagePaths[0]}',
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
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
                                        "Type: ${petList[index].petType}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        "Age: ${petList[index].petAge} years",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        "Category: ${petList[index].category}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                // TRAILING ARROW BUTTON
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

  void loadData(String query) {
    petList.clear();
    setState(() {
      status = "Loading...";
    });
    //print("SEARCH QUERY: [$query]");
    http
        .get(Uri.parse('${ipaddress.baseUrl}/api/load_pet.php?search=$query'))
        .then((response) {
          // print("RESPONSE: ${response.body}");
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            //var data = jsonDecode(jsonResponse);
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
                status = "No pets found";
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
                      //name
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
                      //description
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
                      //pet type
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
                      //pet gender
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
                      //location
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
                      //owner
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
                                '${petList[index].userId} \n${petList[index].userName}',
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
            if (isGuest() != true)
              if (petList[index].category == 'Adoption' &&
                  widget.user?.userId != petList[index].userId)
                TextButton(
                  onPressed: () {
                    selectedPet = petList[index];
                    showAdoptDialog();
                    // Navigator.pop(context);
                    //  handle request adopt
                  },
                  child: Text('Request to Adopt'),
                ),

            if (petList[index].category == 'Donation')
              TextButton(
                onPressed: () {
                  //  handle request adopt
                },
                child: Text('Donate Money'),
              ),
            if (petList[index].category == 'Donation Medical')
              TextButton(
                onPressed: () {
                  //  handle request adopt
                },
                child: Text('Donate Medical'),
              ),
          ],
        );
      },
    );
  }

  //serach
  void showSearchDialog() {
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE
                const Text(
                  "Search Name/Type of pet",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 12),

                // SEARCH FIELD
                TextField(
                  controller: searchController,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    _performSearch(value);
                  },
                  decoration: InputDecoration(
                    hintText: "e.g. Labibi, Cat",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ACTION BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 238, 176, 83),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 238, 176, 83),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        _performSearch(searchController.text);
                      },
                      child: const Text("Search"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _performSearch(String query) {
    Navigator.pop(context);

    if (query.trim().isEmpty) {
      loadData('');
    } else {
      loadData(query.trim());
    }
  }

  //filter
  void showFilterDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE
                const Text(
                  "Filter by Type of pet",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                //selected input
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    // value: selectedPetType,
                    items: petTypes.map((selectedType) {
                      return DropdownMenuItem<String>(
                        value: selectedType,
                        child: Text(selectedType),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPetType = newValue;
                      });
                    },
                  ),
                ),

                // ACTION BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 238, 176, 83),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 238, 176, 83),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        _performFilter(selectedPetType);
                      },
                      child: const Text("Search"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _performFilter(String? petType) {
    Navigator.pop(context);
    if (petType == null) {
      loadData('');
    } else {
      loadData(petType);
    }
  }

  //adoption

  void showAdoptDialog() {
    TextEditingController msgController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE
                const Text(
                  "Motivation message",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 12),

                // SEARCH FIELD
                TextField(
                  controller: msgController,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    submitmsg(value);
                  },
                  decoration: InputDecoration(
                    hintText: "e.g. I want to adopt a dog",

                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ACTION BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 238, 176, 83),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 238, 176, 83),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        submitmsg(msgController.text);
                      },

                      child: const Text("Request"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void submitmsg(String msg) {
    http
        .post(
          Uri.parse('${ipaddress.baseUrl}/api/adopt_pet.php'),
          body: {
            'user_id': widget.user?.userId,
            'pet_id': selectedPet?.petId,
            'msg': msg,
          },
        )
        .then((required) {
          if (required.statusCode == 200) {
            var resarray = jsonDecode(required.body);
            if (resarray['status'] == 'success') {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Message sent successfully"),
                  backgroundColor: Colors.green,
                ),
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
          }
        });
  }

  //donation
}
