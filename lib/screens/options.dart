import 'package:flutter/material.dart';
import 'package:venorawatersupply/compontents/gaps.dart';
import 'package:venorawatersupply/compontents/roundbutton.dart';
import 'package:venorawatersupply/screens/login.dart';
import 'package:venorawatersupply/screens/register.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size / 2;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: screensize.height / 2,
                ),
                Image(
                  image: AssetImage("images/brandip.png"),
                ),
                biggapH,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: RoundButton(
                    title: "Login",
                    doThis: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                  ),
                ),
                midgapH,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: RoundButton(
                    title: "Register",
                    doThis: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                  ),
                ),
                midgapH,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
