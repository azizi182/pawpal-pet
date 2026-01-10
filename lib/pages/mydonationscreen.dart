import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal_project_301310/class/donation.dart';
import 'package:pawpal_project_301310/class/user.dart';
import 'package:pawpal_project_301310/ipaddress.dart';
import 'package:pawpal_project_301310/pages/makepayment.dart';

class Mydonationscreen extends StatefulWidget {
  final User? user;
  const Mydonationscreen({super.key, required this.user});

  @override
  State<Mydonationscreen> createState() => _MydonationscreenState();
}

class _MydonationscreenState extends State<Mydonationscreen> {
  String walletBalance = '0';
  List<Donation> donationList = [];
  late double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
    loadWallet();
    loadDonation();
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
        title: const Text('Donation Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              loadDonation();
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Makepayment(mode: "topup", user: widget.user),
                ),
              );
            },
            child: Text("Topup Wallet", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 32, 10, 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 238, 176, 83)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'My wallet balance: RM $walletBalance',
                style: const TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 16),
            Divider(color: Colors.grey, thickness: 1),

            Container(
              padding: const EdgeInsets.all(16.0),

              child: Text(
                'My Donation History: ',
                style: const TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),

            // Add donation history list here
            Expanded(
              child: donationList.isEmpty
                  ? const Center(child: Text('No donations made yet.'))
                  : ListView.builder(
                      itemCount: donationList.length,
                      itemBuilder: (context, index) {
                        final donation = donationList[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              'Donation ID: ${donation.donationId}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Type: ${donation.donationType}'),
                                Text('Pet ID: ${donation.petId}'),

                                if (donation.donationType == "food/medical")
                                  Text(
                                    'Description: ${donation.donationAmount}',
                                  ),
                                if (donation.donationType != "food/medical")
                                  Text('Amount: RM ${donation.donationAmount}'),
                                Text('Date: ${donation.donationDate}'),
                              ],
                            ),
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

  //load donation
  Future<void> loadDonation() async {
    http
        .get(
          Uri.parse(
            '${ipaddress.baseUrl}/api/get_my_donation.php?user_id=${widget.user?.userId}',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            //log(response.body);
            final data = jsonDecode(response.body);
            if (data['status'] == 'success') {
              donationList.clear();
              for (var donationData in data['data']) {
                Donation donation = Donation.fromJson(donationData);
                donationList.add(donation);
              }
              setState(() {});
            }
          }
        });
  }

  //load wallet
  Future<void> loadWallet() async {
    http
        .get(
          Uri.parse(
            '${ipaddress.baseUrl}/api/get_my_wallet.php?user_id=${widget.user?.userId}',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            log(response.body);
            final data = jsonDecode(response.body);
            if (data['status'] == 'success') {
              var walletData = data['data'][0];
              setState(() {
                walletBalance = walletData['user_wallet'];
              });
            }
          }
        });
  }
}
