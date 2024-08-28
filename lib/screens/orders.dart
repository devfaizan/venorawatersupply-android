import "dart:convert";
import 'package:flutter/material.dart';

import "package:shared_preferences/shared_preferences.dart";
import 'package:http/http.dart' as http;
import "package:venorawatersupply/compontents/drawer.dart";
import "package:venorawatersupply/screens/cart.dart";
import "package:venorawatersupply/screens/fulfilled.dart";
import "package:venorawatersupply/screens/home.dart";
import "package:venorawatersupply/screens/inprocess.dart";
import "package:venorawatersupply/screens/login.dart";
import "package:venorawatersupply/screens/orderProducts.dart";
import "package:venorawatersupply/screens/pending.dart";
import "package:venorawatersupply/screens/products.dart";
import "package:venorawatersupply/screens/profile.dart";

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future<void> logoutUser(String token) async {
    final String url = 'http://192.168.18.18/apiss/logout.php';
    // final String url = 'http://letsbuildblock.com/apiss/logout.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          final prefs = await SharedPreferences.getInstance();
          prefs.remove('token');

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          print('Logout failed: ${data['message']}');
        }
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Orders",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          bottom: TabBar(tabs: [
            Tab(
              text: "Pending",
            ),
            Tab(
              text: "Inprocess",
            ),
            Tab(
              text: "Fulfilled",
            ),
          ]),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHead(),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Home"),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.inventory),
                  title: Text("Products"),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductScreen(),
                    ),
                  );
                },
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Update Profile"),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ),
                  );
                },
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text("Cart"),
                ),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ),
                  );
                },
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.conveyor_belt),
                  title: Text("Orders"),
                ),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderScreen(),
                    ),
                  );
                },
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                ),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final String? token = prefs.getString('token');
                  if (token != null) {
                    await logoutUser(token);
                  }
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PendingOrders(),
            InprocessOrders(),
            FulfilledOrders(),
          ],
        ),
      ),
    );
  }
}
