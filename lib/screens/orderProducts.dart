import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderProductScreen extends StatefulWidget {
  final String orderId;
  const OrderProductScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderProductScreen> createState() => _OrderProductScreenState();
}

class _OrderProductScreenState extends State<OrderProductScreen> {
  String token = "";
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchToken();
  }

  Future<void> fetchToken() async {
    final url = "http://192.168.18.18/apiss/getTokenAndIDpost.php";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        token = response.body;
      });
    } else {
      throw Exception('Failed to load token');
    }
  }

  Future<void> fetchProducts() async {
    try {
      final url = "http://192.168.18.18/apiss/getOrderProducts.php";
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'orderId': widget.orderId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List) {
          setState(() {
            products = responseData;
          });
        } else {
          setState(() {
            print("Error or message: ${responseData['message']}");
          });
        }
      } else {
        setState(() {
          print(
              'Failed to load products. Server responded with ${response.statusCode}.');
        });
      }
    } catch (e) {
      setState(() {
        print("Rola");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ordered Products ${widget.orderId}",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(products[index]['product_name']),
            subtitle: Text('Quantity: ${products[index]['product_quantity']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(token);
          print(widget.orderId);
        },
      ),
    );
  }
}
