import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:venorawatersupply/compontents/roundbutton.dart';
import 'package:venorawatersupply/compontents/toast.dart';
import 'package:venorawatersupply/compontents/validation.dart';
import 'package:venorawatersupply/screens/home.dart';
import 'package:venorawatersupply/screens/resetpassword.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String eMail = "", password = "";
  bool isObscure = true;

  Future loginCustomer() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        showSpinner = true;
      });
      String url = "http://192.168.18.18/apiss/login.php";
      // String url = "http://letsbuildblock.com/apiss/login.php";
      Map<String, String> headers = {'Content-Type': 'application/json'};
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(
          {
            "email": eMail.toString().trim(),
            "password": password.toString().trim(),
          },
        ),
      );
      var data = jsonDecode(response.body);
      try {
        if (data['status'] == 'success') {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', data['token']);
          toastMessage(
            "Logged In",
            Colors.green,
          );
          setState(() {
            showSpinner = false;
          });
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          toastMessage(
            data['message'].toString(),
            Colors.red,
          );
          setState(() {
            showSpinner = false;
          });
        }
      } catch (e) {
        toastMessage(
          e.toString(),
          Colors.red,
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
            "Login",
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screensize.height / 2,
                  ),
                  Text(
                    "Login Into App",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Email",
                              labelText: "Email",
                              prefixIcon: Icon(Icons.mail),
                            ),
                            onChanged: (String value) {
                              eMail = value;
                            },
                            validator: validateEmail,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: TextFormField(
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: isObscure,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Password",
                                labelText: "Password",
                                prefixIcon: Icon(Icons.password),
                                suffixIcon: toggleObscure(),
                              ),
                              onChanged: (String value) {
                                password = value;
                              },
                              validator: validatePassword,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 20),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResetPasswordScreen(),
                                  ),
                                );
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text("Forgot Password?"),
                              ),
                            ),
                          ),
                          RoundButton(
                            title: "Login",
                            doThis: () {
                              loginCustomer();
                            },
                          ),
                        ],
                      ),
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

  Widget toggleObscure() {
    return IconButton(
      onPressed: () {
        setState(() {
          isObscure = !isObscure;
        });
      },
      icon: isObscure ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }
}
