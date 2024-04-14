import "dart:convert";
import 'package:flutter/material.dart';

import "package:shared_preferences/shared_preferences.dart";
import 'package:http/http.dart' as http;
import "package:venorawatersupply/compontents/drawer.dart";
import "package:venorawatersupply/screens/cart.dart";
import "package:venorawatersupply/screens/home.dart";
import "package:venorawatersupply/screens/login.dart";
import "package:venorawatersupply/screens/orderProducts.dart";
import "package:venorawatersupply/screens/products.dart";
import "package:venorawatersupply/screens/profile.dart";

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final url = "http://192.168.18.18/apiss/getOrders.php";
      // final url = "http://letsbuildblock.com/apiss/getOrders.php";
      final response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data != null && data is List) {
          setState(() {
            orders = data;
          });
        } else {
          print('No orders found');
        }
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

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
          "Orders",
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
      body: Center(
        child: orders.isEmpty
            ? Text("No Data")
            : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(208, 209, 239, 1),
                              Color.fromRGBO(172, 179, 237, 0.922),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          onTap: () async {
                            final orderId = order['order_id'];
                            print("Click ho raha hay Order ID : $orderId per");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrderProductScreen(orderId: orderId),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              'Order ID: ${order['order_id']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(height: 25),
                                    Text(
                                      'Total: ${order['order_amount']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                        width: 15), // Add space between lines
                                    Text(
                                      'Ordered On: ${order['date']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                        width: 10), // Add space between lines
                                    Text(
                                      'Status: ${order['order_status']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color:
                                            order['order_status'] == 'pending'
                                                ? Colors.red
                                                : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Add more details if needed
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
