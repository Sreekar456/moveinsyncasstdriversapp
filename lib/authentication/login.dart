// import 'package:app/authentication/signup.dart';
// import 'package:app/global/global_var.dart';
// import 'package:app/pages/home.dart';
import 'package:drivers_app/authentication/signup.dart';
import 'package:drivers_app/global/global_var.dart';
import 'package:drivers_app/methods/common_methods.dart';
import 'package:drivers_app/pages/dashboard.dart';
import 'package:drivers_app/widgets/loading_dialogue.dart';
import 'package:flutter/material.dart';
// import 'package:app/widgets/loading_dialogue.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  // TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

CommonMethods cMethods = CommonMethods();
  checkIfNetworkAvailable() {
   cMethods.checkConnectivity(context);
   signInFormValidation();
  }
  signInFormValidation(){
      if(emailTextEditingController.text.contains("@") == false){
        cMethods.displaySnackbar("Email must contain @", context);
      }
      else if(passwordTextEditingController.text.trim().length<6){
        cMethods.displaySnackbar("Password must be at least 6 characters", context);
      }
      else{
        signInUser();
      }
  }

  signInUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialogue(messageText: "Logging in..."),
    );

    final UserCredential? userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passwordTextEditingController.text.trim())
        .catchError((error) {
      Navigator.pop(context);
      cMethods.displaySnackbar(error.toString(), context);
    });

    final User? userFirebase = userCredential?.user;
    if(!context.mounted || userFirebase == null) {
      return;
    }

    if(userFirebase != null) {
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child("drivers")
          .child(userFirebase.uid);

      userRef.once().then((DatabaseEvent event) {
        if (event.snapshot.exists) {
          final data = event.snapshot.value as Map?;
          if (data != null && data['blockStatus'] == "no") {
            // userName = (event.snapshot.value as Map)['name'] ?? '';
            
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
            );
          } else {
            FirebaseAuth.instance.signOut();
            Navigator.pop(context);
            cMethods.displaySnackbar("Driver does not exist or is blocked", context);
          }
        } else {
          FirebaseAuth.instance.signOut();
          Navigator.pop(context);
          cMethods.displaySnackbar("Driver does not exist", context);
        }
      });
    }
   
  }
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [

              const SizedBox(height: 60),
              Image.asset('assets/images/uberexec.png', width: 220,),
              Text(
                "Login as a driver",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              // textfields for email and password
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    

                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(fontSize: 14),
                        
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15
                      ),
                    ),
                    const SizedBox(height: 22),

                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(fontSize: 14),
                        
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: ()
                      {
                        checkIfNetworkAvailable();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.symmetric(horizontal: 80,vertical: 10)
                      ),
                      child: const Text(
                        "Log in",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUp()),
                        );
                      },
                      child: const Text(
                        "Don't have an account? Sign Up",
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