import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:venorawatersupply/compontents/categorieswidget.dart';
import 'package:venorawatersupply/compontents/drawer.dart';
import 'package:venorawatersupply/compontents/itemswidget.dart';
import 'package:venorawatersupply/screens/cart.dart';
import 'package:venorawatersupply/screens/home.dart';
import 'package:venorawatersupply/screens/login.dart';
import 'package:venorawatersupply/screens/orders.dart';
import 'package:venorawatersupply/screens/profile.dart';
import 'package:http/http.dart' as http;

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Products",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
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
      body: ListView(
        children: [
          Container(
            // height: 500,
            padding: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: Color(0xFFEDECF2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Search Items",
                          ),
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.search,
                        color: Color.fromRGBO(46, 49, 146, 1),
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                    top: 20,
                    left: 25,
                    // horizontal: 10,
                  ),
                  child: Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(81, 84, 184, 1),
                    ),
                  ),
                ),
                CategoriesWidget(),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                    top: 20, left: 25,
                    // horizontal: 10,
                  ),
                  child: Text(
                    "All Products",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(81, 84, 184, 1),
                    ),
                  ),
                ),
                ItemsWidget(),
                // ProductGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
