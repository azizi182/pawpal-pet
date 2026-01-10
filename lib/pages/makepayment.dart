import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:pawpal_project_301310/class/user.dart';
import 'package:pawpal_project_301310/class/pet.dart';
import 'package:pawpal_project_301310/ipaddress.dart';

// ignore: must_be_immutable
class Makepayment extends StatefulWidget {
  String mode;
  User? user; // yang donate
  petDetails? pet; // yang terima donation

  Makepayment({super.key, required this.mode, required this.user, this.pet});

  @override
  State<Makepayment> createState() => _MakepaymentState();
}

class _MakepaymentState extends State<Makepayment> {
  String walletBalance = '0';
  List<String> money = [
    '5',
    '10',
    '15',
    '20',
    '25',
    '30',
    '35',
    '40',
    '45',
    '50',
  ];
  String? selectedMoney = '0';
  String? selectedPaymentMethod;
  late double screenWidth, screenHeight;
  @override
  void initState() {
    super.initState();
    loadWallet();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == "topup"
              ? 'Top Up Wallet'
              : 'Donate to ${widget.pet?.petName}',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            Text('Wallet Balance: RM $walletBalance'),

            const SizedBox(height: 20),

            // 1 file has to handle 2 mode topup and donate
            if (widget.mode == "topup") buildTopupUI(),

            if (widget.mode == "donate") buildDonateUI(),
          ],
        ),
      ),
    );
  }

  Widget buildTopupUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //amount to topup
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Top-up Amount',
            prefixText: 'RM  ',
            border: OutlineInputBorder(),
          ),
          items: money.map((selectedType) {
            return DropdownMenuItem<String>(
              value: selectedType,
              child: Text(selectedType),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedMoney = newValue;
            });
          },
        ),

        //select payment method
        Divider(height: 40, color: Colors.grey),
        Text('Select Payment Method:'),

        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // make button full width
            children: [
              // Payment options
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.account_balance_wallet,
                    color: Colors.blue,
                  ),
                  title: Text('Touch n Go eWallet'),
                  trailing: Checkbox(
                    value: selectedPaymentMethod == "ewallet",
                    onChanged: (bool? value) {
                      setState(() {
                        selectedPaymentMethod = value! ? "ewallet" : null;
                      });
                    },
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.credit_card, color: Colors.green),
                  title: Text('Credit/Debit Card'),
                  trailing: Checkbox(
                    value: selectedPaymentMethod == "creditcard",
                    onChanged: (bool? value) {
                      setState(() {
                        selectedPaymentMethod = value! ? "creditcard" : null;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    double? selectedAmount = double.tryParse(selectedMoney!);

                    if (selectedAmount != null && selectedAmount > 0) {
                      showDialogTopup();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 238, 176, 83),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Confirm Top-up',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //donate ui
  Widget buildDonateUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        //card-detail pet
        Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
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
                    width: screenWidth * 0.28, // more responsive
                    height: screenWidth * 0.22, // balanced aspect ratio
                    color: Colors.grey[200],
                    child: widget.pet!.imagePaths.isNotEmpty
                        ? Image.network(
                            '${ipaddress.baseUrl}/file_put_contents/${widget.pet!.imagePaths[0]}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 60);
                            },
                          )
                        : Icon(Icons.pets, size: 60),
                  ),
                ),

                const SizedBox(width: 12),

                // detail section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // pet name
                      Text(
                        widget.pet!.petName.toString(),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 4),

                      Text(
                        "Owner: ${widget.pet!.userName}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // pet description
                      Text(
                        "Description: ${widget.pet!.description}",
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
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        //amount to donate
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Donate Amount',
            prefixText: 'RM  ',
            border: OutlineInputBorder(),
          ),
          items: money.map((selectedType) {
            return DropdownMenuItem<String>(
              value: selectedType,
              child: Text(selectedType),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedMoney = newValue;
            });
          },
        ),
        SizedBox(height: 20),
        Text('Select Payment Method:'),

        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // make button full width
            children: [
              // Payment options
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.account_balance_wallet,
                    color: Colors.blue,
                  ),
                  title: Text('Touch n Go eWallet'),
                  trailing: Checkbox(
                    value: selectedPaymentMethod == "ewallet",
                    onChanged: (bool? value) {
                      setState(() {
                        selectedPaymentMethod = value! ? "ewallet" : null;
                      });
                    },
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.credit_card, color: Colors.green),
                  title: Text('Credit/Debit Card'),
                  trailing: Checkbox(
                    value: selectedPaymentMethod == "creditcard",
                    onChanged: (bool? value) {
                      setState(() {
                        selectedPaymentMethod = value! ? "creditcard" : null;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    double? selectedAmount = double.tryParse(selectedMoney!);
                    double? walletAmount = double.tryParse(walletBalance);
                    if (selectedAmount! > walletAmount!) {
                      print("mode ${widget.mode}");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Not enough balance in wallet"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      showDialogDonation();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 238, 176, 83),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Confirm Donate to ${widget.pet?.petName}',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //show dialog topup
  void showDialogTopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Topup Wallet'),
          content: Text('Do you want to topup your wallet ?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
                TextButton(
                  onPressed: () {
                    //print("mode ${widget.mode}");
                    updatePayment(selectedMoney, widget.mode);
                    loadWallet();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('Topup'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  //show dialog donation
  void showDialogDonation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Donation'),
          content: Text('Do you want to donate to ${widget.pet?.userName} ?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
                TextButton(
                  onPressed: () {
                    // print("mode ${widget.mode}");
                    updatePayment(selectedMoney, widget.mode);
                    loadWallet();
                    Navigator.of(context).pop();
                  },
                  child: Text('Donate'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  //updatepayment topup
  Future<void> updatePayment(String? selectedMoney, String? mode) async {
    http
        .post(
          Uri.parse('${ipaddress.baseUrl}/api/update_payment.php'),
          body: {
            'user_id': widget.user?.userId, // yang nk donate
            'amount': selectedMoney,
            'mode': mode,

            if (mode == 'donate') 'pet_id': widget.pet?.petId,
          },
        )
        .then((response) {
          if (response.statusCode == 200) {
            log(response.body);
            var resarray = jsonDecode(response.body);
            if (resarray['status'] == 'success') {
              loadWallet();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Wallet updated successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
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

  //get amount
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
