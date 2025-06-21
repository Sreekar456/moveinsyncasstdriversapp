import 'package:drivers_app/methods/common_methods.dart';
import 'package:drivers_app/pages/dashboard.dart';
import 'package:drivers_app/widgets/loading_dialogue.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignupState();
}

class _SignupState extends State<SignUp> {
  TextEditingController userPhoneTextEditingController = TextEditingController();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController vehicalModelTextEditingController = TextEditingController();
  TextEditingController vehicalColorEditingController = TextEditingController();
  TextEditingController vehicalNumberTextEditingController = TextEditingController();

  CommonMethods cMethods = CommonMethods();

  checkIfNetworkAvailable() {
    cMethods.checkConnectivity(context);
    signUpFormValidation(); // Always allow signup
  }

  signUpFormValidation() {
    if (userNameTextEditingController.text.trim().length < 3) {
      cMethods.displaySnackbar("User name must be at least 3 characters", context);
    } else if (userPhoneTextEditingController.text.trim().length < 10) {
      cMethods.displaySnackbar("Phone number must be at least 10 digits", context);
    } else if (emailTextEditingController.text.contains("@") == false) {
      cMethods.displaySnackbar("Email is not valid", context);
    } else if (passwordTextEditingController.text.trim().length < 6) {
      cMethods.displaySnackbar("Password must be at least 6 characters", context);
    } else if (vehicalColorEditingController.text.trim().isEmpty) {
      cMethods.displaySnackbar("Enter vehical color", context);
    } else if (vehicalModelTextEditingController.text.trim().isEmpty) {
      cMethods.displaySnackbar("Enter vehical model", context);
    } else if (vehicalNumberTextEditingController.text.trim().isEmpty) {
      cMethods.displaySnackbar("Enter vehical number", context);
    } else {
      registerNewDriver();
    }
  }

  registerNewDriver() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialogue(messageText: "Registering your account..."),
    );

    final UserCredential? userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passwordTextEditingController.text.trim())
        .catchError((error) {
      Navigator.pop(context);
      cMethods.displaySnackbar(error.toString(), context);
    });

    final User? userFirebase = userCredential?.user;
    if (!context.mounted || userFirebase == null) {
      return;
    }

    Navigator.pop(context);

    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("drivers").child(userFirebase.uid);

    Map driverCarInfo = {
      "carColor": vehicalColorEditingController.text.trim(),
      "carModel": vehicalModelTextEditingController.text.trim(),
      "carNumber": vehicalNumberTextEditingController.text.trim(),
    };

    Map driverDataMap = {
      "photo": "", // No image
      "car_details": driverCarInfo,
      "name": userNameTextEditingController.text.trim(),
      "email": emailTextEditingController.text.trim(),
      "phone": userPhoneTextEditingController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no",
    };

    userRef.set(driverDataMap);
    Navigator.push(context, MaterialPageRoute(builder: (c) => Dashboard()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const CircleAvatar(
                radius: 86,
                backgroundImage: AssetImage("assets/images/avatarman.png"),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    TextField(
                      controller: userNameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "User Name",
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: userPhoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Phone No.",
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "User password",
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    TextField(
                      controller: vehicalModelTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "vehical Model",
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    TextField(
                      controller: vehicalColorEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "vehical Color",
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: vehicalNumberTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "vehical Number",
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        checkIfNetworkAvailable();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10)),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LogIn()),
                        );
                      },
                      child: const Text(
                        "Already have an account? Sign In",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
