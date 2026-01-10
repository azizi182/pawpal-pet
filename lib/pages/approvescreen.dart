import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal_project_301310/class/adopt.dart';
import 'package:pawpal_project_301310/class/user.dart';
import 'package:pawpal_project_301310/ipaddress.dart';

class Approvescreen extends StatefulWidget {
  User? user;
  Approvescreen({super.key, required this.user});

  @override
  State<Approvescreen> createState() => _ApprovescreenState();
}

class _ApprovescreenState extends State<Approvescreen> {
  List<Adopt> requests = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  // get pending adoption requests from the server
  void fetchRequests() async {
    setState(() {
      loading = true;
    });

    await http
        .get(
          Uri.parse(
            '${ipaddress.baseUrl}/api/get_adopt.php?owner_id=${widget.user?.userId}',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data['status'] == 'success') {
              requests.clear();
              for (var item in data['data']) {
                requests.add(Adopt.fromJson(item));
              }
            }
          }

          setState(() {
            loading = false;
          });
        });
  }

  // update adoption request status
  void updateRequest(String? adoptId, String action) async {
    final response = await http
        .post(
          Uri.parse('${ipaddress.baseUrl}/api/update_adopt.php'),
          body: {'adopt_id': adoptId, 'action': action},
        )
        .then((response) {
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(data['message']),
                backgroundColor: data['status'] == 'success'
                    ? Colors.green
                    : Colors.red,
              ),
            );
            fetchRequests();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Approve Adoptions')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
          ? const Center(child: Text('No pending requests'))
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final req = requests[index];
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
                                "Requester: ${req.adoptName}",
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text("Message: ${req.adoptMsg}"),
                              const SizedBox(height: 8),

                              // ACTION BUTTONS
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        updateRequest(req.adoptId, 'Rejected'),
                                    child: const Text(
                                      'Reject',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () =>
                                        updateRequest(req.adoptId, 'Accepted'),
                                    child: const Text('Accept'),
                                  ),
                                ],
                              ),
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
}
