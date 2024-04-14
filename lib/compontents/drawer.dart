import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:venorawatersupply/compontents/gaps.dart';
import 'package:http/http.dart' as http;

class DrawerHead extends StatefulWidget {
  const DrawerHead({super.key});

  @override
  State<DrawerHead> createState() => _DrawerHeadState();
}

class _DrawerHeadState extends State<DrawerHead> {
  String customerName = '';
  String customerEmail = '';
  String token = "";
  String? imagePathFromDB;
  String? actualPath;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> fetchToken() async {
    final url = "http://192.168.18.18/apiss/getTokenAndIDpost.php";
    // final url = "http://letsbuildblock.com/apiss/getTokenAndIDpost.php";
    final response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      setState(() {
        token = response.body;
      });
    } else {
      throw Exception('Failed to load token');
    }
  }

  Future<void> doodoo() async {
    Image.network(actualPath ?? "");
  }

  Future<void> getData() async {
    try {
      String url = "http://192.168.18.18/apiss/getProfile.php";
      // String url = "http://letsbuildblock.com/apiss/getProfile.php";

      final response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> customerInfo = json.decode(response.body);

        setState(() {
          customerName = customerInfo['name'];
          customerEmail = customerInfo['email'];
          imagePathFromDB = customerInfo['imagePath'];
          actualPath = "http://192.168.18.18/apiss/${imagePathFromDB!}";
          // actualPath = "http://letsbuildblock.com/apiss/${imagePathFromDB!}";
        });
      } else {
        print(
            'Failed to get customer information. Status code: ${response.statusCode}');
      }
    } catch (e) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imagePathFromDB != null
                      ? Image.network(actualPath ?? "").image
                      : AssetImage("images/white.png"),
                ),
              ),
            ),
            Text(
              '$customerName',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            smolgapH,
            Text(
              '$customerEmail',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
