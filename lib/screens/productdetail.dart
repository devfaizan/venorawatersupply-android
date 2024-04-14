import 'dart:convert';

import 'package:clippy_flutter/arc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:venorawatersupply/compontents/drawer.dart';
import 'package:venorawatersupply/compontents/gaps.dart';
import 'package:venorawatersupply/compontents/roundbutton.dart';
import 'package:venorawatersupply/compontents/toast.dart';
import 'package:venorawatersupply/screens/cart.dart';
import 'package:venorawatersupply/screens/home.dart';
import 'package:venorawatersupply/screens/login.dart';
import 'package:venorawatersupply/screens/orders.dart';
import 'package:venorawatersupply/screens/products.dart';
import 'package:venorawatersupply/screens/profile.dart';
import 'package:http/http.dart' as http;

class ProductDetailScreen extends StatefulWidget {
  final String productID;
  final String productName;
  final String productAmount;
  final String productStatus;
  const ProductDetailScreen({
    Key? key,
    required this.productID,
    required this.productName,
    required this.productAmount,
    required this.productStatus,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int counter = 1;
  String token = "";

  @override
  void initState() {
    super.initState();
    fetchToken();
  }

  void incrementCounter() {
    if (counter < 10) {
      setState(() {
        counter++;
      });
    }
  }

  void decrementCounter() {
    if (counter > 1) {
      setState(() {
        counter--;
      });
    }
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

  Future<void> addToCart() async {
    await fetchToken();
    if (token.isEmpty) {
      print("No Token Here");
      return;
    }

    final String apiUrl = 'http://192.168.18.18/apiss/addToCart.php';
    // final String apiUrl = 'http://letsbuildblock.com/apiss/addToCart.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'products': [
            {
              'product_id': widget.productID,
              'product_name': widget.productName,
              'product_amount': widget.productAmount,
              'product_quantity': counter,
              'timestamp': DateTime.now().toUtc().toString(),
            },
            // Add other products here if needed
          ]
          // 'product_id': widget.productID,
          // 'product_name': widget.productName,
          // 'product_amount': widget.productAmount,
          // 'product_quantity': counter,
          // 'timestamp': DateTime.now().toUtc().toString(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle the response data, you might want to check for success or handle errors.
        toastMessage("Added To Cart", Colors.green);
        print('Add to cart response: $data');
      } else {
        toastMessage('Server error: ${response.statusCode}', Colors.green);
      }
    } catch (e) {
      toastMessage(e.toString(), Colors.green);
      print(e.toString());
    }
  }

  Future<void> addToDupCart() async {
    await fetchToken();
    if (token.isEmpty) {
      print("No Token Here");
      return;
    }
//
    final String apiUrl = 'http://192.168.18.18/apiss/dupaddToCart.php';
    // final String apiUrl = 'http://letsbuildblock.com/apiss/dupaddToCart.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'products': [
            {
              'product_id': widget.productID,
              'product_name': widget.productName,
              'product_amount': widget.productAmount,
              'product_quantity': counter,
              'timestamp': DateTime.now().toUtc().toString(),
            },
            // Add other products here if needed
          ]
          // 'product_id': widget.productID,
          // 'product_name': widget.productName,
          // 'product_amount': widget.productAmount,
          // 'product_quantity': counter,
          // 'timestamp': DateTime.now().toUtc().toString(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle the response data, you might want to check for success or handle errors.
        toastMessage("Added To Cart", Colors.green);
        print('Add to cart response: $data');
      } else {
        toastMessage('Server error: ${response.statusCode}', Colors.green);
      }
    } catch (e) {
      toastMessage(e.toString(), Colors.green);
      print(e.toString());
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
          "${widget.productName}",
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: Image.asset("images/cane1.png"),
          ),
          Arc(
            edge: Edge.TOP,
            arcType: ArcType.CONVEY,
            height: 30,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    midgapH,
                    Padding(
                      padding: EdgeInsets.only(
                        top: 50,
                        bottom: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${widget.productName}",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).textScaleFactor * 28,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(46, 49, 146, 1),
                            ),
                          ),
                          Text(
                            "${widget.productAmount}",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).textScaleFactor * 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(46, 49, 146, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    smolgapH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            decrementCounter();
                            print(counter);
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: Icon(CupertinoIcons.minus),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "$counter",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(46, 49, 146, 1),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            incrementCounter();
                            print(counter);
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: Icon(CupertinoIcons.plus),
                          ),
                        ),
                      ],
                    ),
                    midgapH,
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Product Description to be added later.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras tincidunt consectetur lectus, eu pulvinar massa lacinia sit amet. Maecenas sed \ndolor at elit hendrerit tincidunt. In imperdiet ullamcorper nibh, nec feugiat ligula vestibulum at.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(84, 87, 149, 1),
                        ),
                      ),
                    ),
                    smolgapH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.0),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 40),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 226, 226, 226),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${widget.productStatus}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: widget.productStatus == 'Instock'
                                  ? Color.fromRGBO(46, 146, 83, 1)
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    biggapH,
                    biggapH,
                    biggapH,
                    vsmolgapH,
                  ],
                ),
              ),
            ),
          ),
          RoundButton(
            title: "Add To Cart",
            doThis: () {
              if (widget.productStatus == 'Instock') {
                addToCart();
                addToDupCart();
                print("Clicj");
                print(token);
              } else {
                toastMessage("Product Is Out Of Stock", Colors.red);
              }
            },
          ),
        ],
      ),
    );
  }
}
