import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upwards2/common/colo_extension.dart';
import 'package:upwards2/common_widget/round_button.dart';
import 'package:upwards2/view/main_tab/main_tab_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  // Variable to store the name, default is empty
  String userName = "User";

  @override
  void initState() {
    super.initState();
    loadUserData(); // Fetch data when page loads
  }

  Future<void> loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get the document for the current user
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            // Update the name variable with data from Firestore
            // We use 'firstName' because that is what we saved in SignupView
            userName = userDoc.data()?['firstName'] ?? "User";
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Container(
          width: media.width,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: media.width * 0.05,
              ),
              Image.asset(
                "assets/img/sign5.png",
                width: media.width * 0.8,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: media.width * 0.2,
              ),
              Text(
                "Welcome, $userName", // <--- UPDATED THIS LINE
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "You are all set now. Let’s\nreach your goals together with us",
                textAlign: TextAlign.center,
                style: TextStyle(color: TColor.grey, fontSize: 16),
              ),
              const Spacer(),
              RoundButton(
                title: "Go To Home",
                onPressed: () {
                  // PushReplacement so they can't go back to Welcome screen
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainTabView(),
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



