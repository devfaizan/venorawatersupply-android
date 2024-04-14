import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:venorawatersupply/compontents/roundbutton.dart';
import 'package:venorawatersupply/compontents/validation.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  TextEditingController emailController = TextEditingController();
  String eMail = "";

  // Future resetPassword() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       showSpinner = true;
  //     });
  //     try {
  //       await _auth.auth.resetPasswordForEmail(emailController.text.toString());
  //       setState(() {
  //         showSpinner = false;
  //       });
  //       toastMessage("Reset link sent", Colors.blueAccent);
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => LoginScreen(),
  //         ),
  //         (Route<dynamic> route) => false,
  //       );
  //     } on AuthException catch (e) {
  //       setState(() {
  //         showSpinner = false;
  //       });
  //       toastMessage(e.toString(), Colors.red);
  //     }
  //   }
  // }

  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Reset Password",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Reset Your Password",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
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
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: RoundButton(
                            title: "Send Reset Link To Email",
                            doThis: () {
                              // resetPassword();
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
