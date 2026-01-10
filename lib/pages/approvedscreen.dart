import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal_project_301310/class/adopt.dart';
import 'package:pawpal_project_301310/class/user.dart';
import 'package:pawpal_project_301310/ipaddress.dart';

class Approvedscreen extends StatefulWidget {
  User? user;
  Approvedscreen({super.key, required this.user});

  @override
  State<Approvedscreen> createState() => _ApprovedscreenState();
}

class _ApprovedscreenState extends State<Approvedscreen> {
  List<Adopt> adoptapproved = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchListAdopt();
  }

  // get approved adoption requests from the server
  void fetchListAdopt() async {
    setState(() {
      loading = true;
    });

    final response = await http.get(
      Uri.parse(
        '${ipaddress.baseUrl}/api/get_adopt_approved.php?user_id=${widget.user?.userId}',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        adoptapproved.clear();
        for (var item in data['data']) {
          adoptapproved.add(Adopt.fromJson(item));
        }
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Approved Adoptions')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : adoptapproved.isEmpty
          ? const Center(child: Text('No pending requests'))
          : ListView.builder(
              itemCount: adoptapproved.length,
              itemBuilder: (context, index) {
                final req = adoptapproved[index];
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
                            width: 110,
                            height: 90,
                            color: Colors.grey[200],
                            child: req.imagePaths.isNotEmpty
                                ? Image.network(
                                    '${ipaddress.baseUrl}/file_put_contents/${req.imagePaths[0]}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                    ),
                                  )
                                : const Icon(Icons.pets, size: 50),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // DETAILS
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                req.petName.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text("Type: ${req.petType}"),
                              Text("Age: ${req.petAge}"),
                              Text("Category: ${req.category}"),
                              const SizedBox(height: 6),
                              Text(
                                "Owner:${req.ownerName}",
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [buildStatusChip(req.adoptStatus)],
                              ),

                              //
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  //make widget usable for status chip
  Widget buildStatusChip(String? status) {
    Color bgColor;
    IconData icon;

    switch (status) {
      case 'Accepted':
        bgColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'Rejected':
        bgColor = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        bgColor = Colors.orange;
        icon = Icons.hourglass_top;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            status ?? 'Pending',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
