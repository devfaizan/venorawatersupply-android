import 'package:flutter/material.dart';
import 'package:venorawatersupply/compontents/gaps.dart';
import 'package:venorawatersupply/screens/productdetail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ItemsWidget extends StatefulWidget {
  const ItemsWidget({super.key});

  @override
  _ItemsWidgetState createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = "http://192.168.18.18/apiss/getProduct.php";
    // final url = "http://letsbuildblock.com/apiss/getProduct.php";

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      setState(() {
        products = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 0.68,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      padding: EdgeInsets.only(
        bottom: 20,
      ),
      children: [
        for (var product in products)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    productID: product['product_id'],
                    productName: product['product_name'],
                    productAmount: product['product_amount'],
                    productStatus: product['product_status'],
                    productQuantity: int.parse(product['product_quantity']),
                  ),
                  // Pass product data to ProductDetailScreen
                  settings: RouteSettings(arguments: product),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),
              margin: EdgeInsets.only(
                top: 15,
                left: 20,
                right: 15,
                bottom: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  biggapH,
                  smolgapH,
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                            productID: product['product_id'],
                            productName: product['product_name'],
                            productAmount: product['product_amount'],
                            productStatus: product['product_status'],
                            productQuantity:
                                int.parse(product['product_quantity']),
                          ),
                          // Pass product data to ProductDetailScreen
                          settings: RouteSettings(arguments: product),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Image.asset(
                        "images/cane1.png",
                        height: 110,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      product['product_name'] ?? "Product Name",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor * 22,
                        // fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(81, 84, 184, 1),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${product['product_amount']}",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor * 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(81, 84, 184, 1),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        smolgapW,
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                  productID: product['product_id'],
                                  productName: product['product_name'],
                                  productAmount: product['product_amount'],
                                  productStatus: product['product_status'],
                                  productQuantity:
                                      int.parse(product['product_quantity']),
                                ),
                                settings: RouteSettings(arguments: product),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.shopping_cart,
                            color: Color.fromRGBO(81, 84, 184, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
