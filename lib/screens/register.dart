import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:venorawatersupply/compontents/gaps.dart';
import 'package:venorawatersupply/compontents/roundbutton.dart';
import 'package:venorawatersupply/compontents/toast.dart';
import 'package:venorawatersupply/compontents/validation.dart';
import 'package:venorawatersupply/screens/login.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String eMail = "", password = "";
  bool showSpinner = false;
  bool isVisible = true;

  Future registerCustomer() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        showSpinner = true;
      });
      try {
        String url = "http://192.168.18.18/apiss/register.php";
        // String url = "http://letsbuildblock.com/apiss/register.php";
        // for mobile
        // String url = "http://192.168.109.137/apiss/register.php";
        // String url = "http://192.168.157.137/apiss/register.php";
        // String url = "http://127.0.0.1/apiss/register.php";
        Map<String, String> headers = {'Content-Type': 'application/json'};
        var response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode({
            "email": eMail.toString().trim(),
            "password": password.toString().trim(),
          }),
        );
        var data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            showSpinner = false;
          });
          toastMessage(
            "Account Created Successfully",
            Colors.green,
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        print(e);
        toastMessage(e.toString(), Colors.red);
        setState(
          () {
            showSpinner = false;
          },
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size / 2;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Register",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screensize.height / 2,
                  ),
                  Text(
                    "Create An Account",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  midgapH,
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Email",
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email),
                            ),
                            onChanged: (String value) {
                              eMail = value;
                            },
                            validator: validateEmail,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            obscureText: isVisible,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Password",
                              labelText: "Password",
                              prefixIcon: Icon(Icons.password),
                              suffixIcon: showPass(),
                            ),
                            onChanged: (String value) {
                              password = value;
                            },
                            validator: validatePassword,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: RoundButton(
                            title: "Register Now",
                            doThis: () {
                              registerCustomer();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showPass() {
    return IconButton(
      onPressed: () {
        setState(() {
          isVisible = !isVisible;
        });
      },
      icon: isVisible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }
}
