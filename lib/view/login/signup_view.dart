import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upwards2/common/colo_extension.dart';
import 'package:upwards2/common_widget/round_button.dart';
import 'package:upwards2/common_widget/round_textfield.dart';
import 'package:upwards2/view/login/completeProfileView.dart';
import 'package:upwards2/view/login/login_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  // 1. Controllers to capture text
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 2. State variables
  bool isChecked = false;
  bool isPasswordHidden = true; // To toggle password visibility
  bool isLoading = false; // To show loading spinner

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 3. Firebase Sign Up Logic
  Future<void> signUpUser() async {
    // Basic Validation
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill in all fields")));
      return;
    }

    if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please accept the terms")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Create User in Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());

      // Save User Data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'uid': userCredential.user!.uid,
        'created_at': DateTime.now(),
      });

      if (mounted) {
        // Navigate to next screen
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Completeprofileview(),
            ));
      }
    } on FirebaseAuthException catch (e) {
      String message = "An error occurred";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is invalid.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hey there",
                  style: TextStyle(color: TColor.grey, fontSize: 18),
                ),
                Text(
                  "Create an Account",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                RoundTextFeild(
                  hintText: "First Name",
                  icon: "assets/img/user.png",
                  controller: _firstNameController, // Added Controller
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextFeild(
                  hintText: "Last Name",
                  icon: "assets/img/user.png",
                  controller: _lastNameController, // Added Controller
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextFeild(
                  hintText: "Email",
                  icon: "assets/img/Message.png",
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController, // Added Controller
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextFeild(
                  hintText: "Password",
                  icon: "assets/img/Lock.png",
                  obscureText: isPasswordHidden, // Controls visibility
                  controller: _passwordController, // Added Controller
                  rightIcon: TextButton(
                      onPressed: () {
                        // Toggle the password visibility
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                      child: Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/img/hidepass.png",
                            height: 20,
                            width: 20,
                            fit: BoxFit.contain,
                            // Change color based on state so user knows it's active
                            color: isPasswordHidden ? TColor.grey : TColor.black,
                          ))),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isChecked = !isChecked;
                          });
                        },
                        icon: Icon(
                          isChecked
                              ? Icons.check_box_outlined
                              : Icons.check_box_outline_blank_outlined,
                          color: TColor.grey,
                          size: 20,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "By continuing you accept our Privacy Policy and\nTerm of Use",
                        style: TextStyle(color: TColor.grey, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.4,
                ),
               
                // Show loading spinner while signing up
                if (isLoading)
                   const CircularProgressIndicator()
                else
                  RoundButton(
                    title: "Register",
                    onPressed: () {
                      
                      signUpUser();
                      
                    },
                  ),

                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: 1,
                      color: TColor.grey.withOpacity(0.5),
                    )),
                    Text(
                      "  Or  ",
                      style: TextStyle(color: TColor.black, fontSize: 12),
                    ),
                    Expanded(
                        child: Container(
                      height: 1,
                      color: TColor.grey.withOpacity(0.5),
                    )),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Add Google Sign in logic here later
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TColor.white,
                          border: Border.all(
                            width: 1,
                            color: TColor.grey.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          "assets/img/google.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: media.width * 0.04,
                    ),
                    GestureDetector(
                      onTap: () {
                         // Add Facebook Sign in logic here later
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TColor.white,
                          border: Border.all(
                            width: 1,
                            color: TColor.grey.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          "assets/img/facebook.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: TColor.black, fontSize: 14),
                      ),
                      Text(
                        "Login",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}