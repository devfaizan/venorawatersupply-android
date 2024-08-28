import "dart:convert";
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:venorawatersupply/screens/orderProducts.dart';

class InprocessOrders extends StatefulWidget {
  const InprocessOrders({super.key});

  @override
  State<InprocessOrders> createState() => _InprocessOrdersState();
}

class _InprocessOrdersState extends State<InprocessOrders> {
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final url = "http://192.168.18.18/apiss/getInprocessOrders.php";
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: orders.isEmpty
          ? Text("No Inprocess Orders")
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
                                      color: Color.fromARGB(255, 162, 129, 58),
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
    );
  }
}
