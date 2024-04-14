import "dart:convert";

import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:http/http.dart' as http;
import "package:venorawatersupply/compontents/drawer.dart";
import "package:venorawatersupply/compontents/gaps.dart";
import "package:venorawatersupply/compontents/roundbutton.dart";
import "package:venorawatersupply/compontents/toast.dart";
import "package:venorawatersupply/screens/home.dart";
import "package:venorawatersupply/screens/login.dart";
import "package:venorawatersupply/screens/orders.dart";
import "package:venorawatersupply/screens/products.dart";
import "package:venorawatersupply/screens/profile.dart";

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String token = "";
  // String dupCartId = "";
  // String cartId = "";
  // String total = "";
  Map<String, dynamic> cartData = {};
  Map<String, dynamic> cartDataDup = {};
  List<dynamic> products = [];
  List<dynamic> productsDup = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchCartData();
    fetchToken();
    fetchCartDupData();
  }

  Future<void> fetchToken() async {
    final url = "http://192.168.18.18/apiss/getTokenAndIDpost.php";
    // final url = "http://letsbuildblock.com/apiss/getTokenAndIDpost.php";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        token = response.body;
      });
      // fetchCartData();
    } else {
      throw Exception('Failed to load token');
    }
  }

  Future<void> fetchCartData() async {
    await fetchToken();
    if (token.isEmpty) {
      print("No Token Here");
      return;
    }
    final url = "http://192.168.18.18/apiss/getUserCart.php";
    // final url = "http://letsbuildblock.com/apiss/getUserCart.php";
    final response = await http.post(
      Uri.parse(url),
      body: {'token': token},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('error')) {
        // Handle case when no cart is found
        print(data['error']);
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          cartData = data['cart'];
          products = data['products'];
          loading = false;
        });
      }
    } else if (response.statusCode == 401) {
      // Handle unauthorized access
      // For example, you can navigate to the login page
    } else {
      print("Server Error: ${response.statusCode}");
    }
  }

  Future<void> fetchCartDupData() async {
    await fetchToken();
    if (token.isEmpty) {
      print("No Token Here");
      return;
    }
    final url = "http://192.168.18.18/apiss/getUserDupCart.php";
    // final url = "http://letsbuildblock.com/apiss/getUserDupCart.php";
    final response = await http.post(
      Uri.parse(url),
      body: {'token': token},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('error')) {
        // Handle case when no cart is found
        print(data['error']);
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          cartDataDup = data['cart'];
          productsDup = data['products'];
          loading = false;
        });
      }
    } else if (response.statusCode == 401) {
      // Handle unauthorized access
      // For example, you can navigate to the login page
    } else {
      print("Server Error: ${response.statusCode}");
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final url = "http://192.168.18.18/apiss/deleteCartItem.php";
      // final url = "http://letsbuildblock.com/apiss/deleteCartItem.php";
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'token': token,
          'product_id': productId,
        }),
      );

      if (response.statusCode == 200) {
        // If the product is deleted successfully, refresh cart data
        await fetchCartData();
      } else {
        print("Failed to delete product");
      }
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  Future<void> deleteDupProduct(String productId) async {
    try {
      final url = "http://192.168.18.18/apiss/dupdeleteCartItem.php";
      // final url = "http://letsbuildblock.com/apiss/dupdeleteCartItem.php";
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'token': token,
          'product_id': productId,
        }),
      );

      if (response.statusCode == 200) {
        // If the product is deleted successfully, refresh cart data
        await fetchCartData();
      } else {
        print("Failed to delete product");
      }
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  void showDeleteConfirmationDialog(String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Confirmation"),
          content: Text("Do you want to delete this product?"),
          actions: [
            ElevatedButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Delete"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                deleteProduct(productId);
                deleteDupProduct(productId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> checkout() async {
    try {
      final url = Uri.parse('http://192.168.18.18/apiss/checkout.php');
      // final url = Uri.parse('http://letsbuildblock.com/apiss/checkout.php');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        toastMessage("Order Placed Succesfully", Colors.green);
        print(responseData['message']); // Output success message
      } else {
        toastMessage("Order Placement Failed", Colors.green);
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      toastMessage(error.toString(), Colors.green);
      print('Error: $error');
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
          "Your Cart",
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
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
                      padding: EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text(
                          "${products[index]['product_name']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          "Quantity: ${products[index]['product_quantity']}           Price: ${products[index]['product_amount']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            showDeleteConfirmationDialog(
                                products[index]['product_id']);
                          },
                          child: Icon(Icons.delete),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 241, 241, 241),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Total: ${cartData['total']}',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                midgapH,
                RoundButton(
                  title: "Checkout",
                  doThis: () {
                    if (cartData['total'] == '0.00' ||
                        cartData['total'] == '0' ||
                        cartData['total'] == 'null' ||
                        cartData['total'] == null) {
                      toastMessage("Please Add Items to Cart", Colors.green);
                    } else {
                      // Implement your checkout logic here
                      // For example, you can navigate to a checkout screen
                      checkout();
                      print(cartDataDup['cart_id']);
                      print(cartData['cart_id']);
                    }
                  },
                ),
                // ElevatedButton(
                //   onPressed: cartData['total'] != 0.00
                //       ? () {
                //           // Implement your checkout logic here
                //           // For example, you can navigate to a checkout screen
                //         }
                //       : null,
                //   child: Text('Checkout'),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
