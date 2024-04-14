import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:venorawatersupply/compontents/gaps.dart';
import 'package:venorawatersupply/compontents/roundbutton.dart';
import 'package:venorawatersupply/compontents/toast.dart';
import 'package:venorawatersupply/compontents/validation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String id = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String name = "", address = "", phone = "";
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  var loading = true;
  String token = "";

  File? imagePath;
  String? imageName;
  String? imageData;
  ImagePicker imagePicker = ImagePicker();
  String? imagePathFromDB;
  String? actualPath;

  Future<void> fetchToken() async {
    final url = "http://192.168.18.18/apiss/getTokenAndIDpost.php";
    // final url = "http://letsbuildblock.com/apiss/getTokenAndIDpost.php";
    //
    // final url = "http://192.168.109.137/apiss/getTokenAndIDpost.php";
    // final url = "http://192.168.157.137/apiss/getTokenAndIDpost.php";
    // final url = "http://127.0.0.1/apiss/getTokenAndIDpost.php";
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

  Future<void> getProfile() async {
    setState(() {
      loading = true;
    });
    try {
      String url = "http://192.168.18.18/apiss/getProfile.php";
      // String url = "http://letsbuildblock.com/apiss/getProfile.php";
      final response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> customerInfo = json.decode(response.body);

        setState(() {
          nameController.text = customerInfo['name'];
          addressController.text = customerInfo['address'];
          phoneController.text = customerInfo['phone'];
          imagePathFromDB = customerInfo['imagePath'];
          actualPath = "http://192.168.18.18/apiss/${imagePathFromDB!}";
          // actualPath = "http://letsbuildblock.com/apiss/${imagePathFromDB!}";
          print(actualPath);
        });
      } else {
        print(
            'Failed to get customer information. Status code: ${response.statusCode}');
      }
    } catch (e) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> updateProfile() async {
    await fetchToken();
    if (_formKey.currentState!.validate()) {
      setState(() {
        showSpinner = true;
      });
      try {
        String url = "http://192.168.18.18/apiss/updateProfile.php";
        // String url = "http://letsbuildblock.com/apiss/updateProfile.php";
        final response = await http.post(
          Uri.parse(url),
          body: {
            'token': token.toString().trim(),
            if (nameController.text.isNotEmpty)
              'name': nameController.text.trim(),
            if (addressController.text.isNotEmpty)
              'address': addressController.text.trim(),
            if (phoneController.text.isNotEmpty)
              'phone': phoneController.text.trim(),
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          if (responseData['status'] == 'success') {
            setState(() {
              showSpinner = false;
            });
            toastMessage("Profile Updated", Colors.green);
          } else {
            setState(() {
              showSpinner = false;
            });
            toastMessage("Failed to Update Profile", Colors.blue);
          }
        } else {
          setState(() {
            showSpinner = false;
          });
          toastMessage('Error: ${response.statusCode}'.toString(), Colors.red);
        }
      } catch (e) {
        setState(() {
          showSpinner = false;
        });
        toastMessage(e.toString(), Colors.red);
      }
    }
  }

  Future<void> getProfileImageFromGallery() async {
    var getImage = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath = File(getImage!.path);
      imageName = getImage.path.split("/").last;
      imageData = base64Encode(imagePath!.readAsBytesSync());
      toastMessage("Image Selected Now Upload Image", Colors.green);
      // print(imageName);
      // print(imagePath);
      // print(imageData);
    });
  }

  Future<void> uploadProfileImage() async {
    await fetchToken();
    if (imagePath != null) {
      setState(() {
        showSpinner = true;
      });
      try {
        String url = "http://192.168.18.18/apiss/uploadPhoto.php";
        // String url = "http://letsbuildblock.com/apiss/uploadPhoto.php";
        Map<String, String> headers = {'Content-Type': 'application/json'};
        var response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(
            {
              'token': token.toString().trim(),
              'name': imageName,
              'zata': imageData,
            },
          ),
        );
        var result = jsonDecode(response.body);
        if (result['success'] == 'true') {
          setState(() {
            showSpinner = false;
          });
          toastMessage("Image Uploaded", Colors.green);
        } else {
          setState(() {
            showSpinner = false;
          });
          toastMessage("Error While Uploading Image", Colors.green);
        }
      } catch (e) {
        setState(() {
          showSpinner = false;
        });
        toastMessage("Failed to Upload Photo", Colors.red);
        toastMessage(e.toString(), Colors.red);
        print(e);
      }
    } else {
      toastMessage("Please Select An Image First", Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20),
          children: [
            CircleAvatar(
              radius: 100,
              backgroundColor: const Color.fromARGB(255, 220, 220, 220),
              child: Stack(
                // clipBehavior: Clip.none,
                children: [
                  Stack(
                    // clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 0,
                        left: 125,
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColorLight,
                          radius: 100,
                          child: actualPath != null
                              ? ClipOval(
                                  child: Image.network(
                                    actualPath ?? "",
                                    fit: BoxFit.cover,
                                    width: 200,
                                    height: 200,
                                  ),
                                )
                              : null,
                          // backgroundImage:
                          //     imagePath != null ? FileImage(imagePath!) : null,
                        ),
                      ),
                      Positioned(
                        top: 150,
                        left: 260,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            elevation: 5,
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: EdgeInsets.all(8),
                          ),
                          onPressed: () {
                            getProfileImageFromGallery();
                          },
                          child: Icon(Icons.camera_alt_outlined),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            smolgapH,
            // Image.network(neww ?? ""),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 150,
              ),
              child: RoundButton(
                title: "Upload Image",
                doThis: () {
                  setState(() {
                    // print('Token: $token');
                    print('name: $imageName');
                    print('data: $imageData');
                    uploadProfileImage();
                  });
                },
              ),
            ),
            midgapH,
            Divider(
                height: 10,
                indent: 25,
                endIndent: 25,
                color: Theme.of(context).primaryColor),
            biggapH,
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Full Name",
                        labelText: "Full Name",
                        prefixIcon: Icon(Icons.person),
                      ),
                      onChanged: (String value) {
                        name = value;
                      },
                      validator: validateText,
                    ),
                  ),
                  midgapH,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: addressController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Address",
                        labelText: "Address",
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      onChanged: (String value) {
                        address = value;
                      },
                      validator: validateTextAndNumber,
                    ),
                  ),
                  midgapH,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Phone",
                        labelText: "Phone",
                        prefixIcon: Icon(Icons.phone),
                      ),
                      onChanged: (String value) {
                        phone = value;
                      },
                      validator: validateNumber,
                    ),
                  ),
                ],
              ),
            ),
            biggapH,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: RoundButton(
                title: "Update Profile",
                doThis: () {
                  print('Token: $token');
                  print('Name: $name');
                  print('Address: $address');
                  print('Phone: $phone');
                  updateProfile();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
