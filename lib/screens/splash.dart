import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:venorawatersupply/compontents/gaps.dart';
import 'package:venorawatersupply/screens/home.dart';
import 'package:venorawatersupply/screens/options.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    Future<bool> validateToken(String token) async {
      String url = 'http://192.168.18.18/apiss/validateToken.php';
      // String url = 'https://letsbuildblock.com/apiss/validateToken.php';

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'token': token}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data['valid'] == true;
        } else {
          print('Server error: ${response.statusCode}');
          return false;
        }
      } catch (e) {
        print('Error validating token: $e');
        return false;
      }
    }

    if (token != null) {
      final isValidToken = await validateToken(token);
      if (isValidToken) {
        Timer(
          Duration(seconds: 3),
          () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
                (Route<dynamic> route) => false);
          },
        );
      }
    } else {
      Timer(
        Duration(seconds: 3),
        () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => OptionScreen(),
              ),
              (Route<dynamic> route) => false);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(46, 49, 146, 1),
              Color.fromRGBO(91, 104, 219, 19),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            TopCont(),
            BotCont(),
          ],
        ),
      ),
    );
  }

  Widget TopCont() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image(
            image: AssetImage("images/white.png"),
          ),
        ],
      ),
    );
  }

  Widget BotCont() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Water At Your Doorstep",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
          midgapH,
        ],
      ),
    );
  }
}
