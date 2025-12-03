import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upwards2/common/colo_extension.dart';
import 'package:upwards2/common_widget/round_button.dart';
import 'package:upwards2/common_widget/round_textfield.dart';
import 'package:upwards2/view/login/Welcome_view.dart';
// import 'package:upwards2/view/login/whatyourgoal_view.dart'; // Unused import

class Completeprofileview extends StatefulWidget {
  const Completeprofileview({super.key});

  @override
  State<Completeprofileview> createState() => _CompleteprofileviewState();
}

class _CompleteprofileviewState extends State<Completeprofileview> {
  TextEditingController txtDate = TextEditingController();
  TextEditingController txtWeight = TextEditingController();
  TextEditingController txtHeight = TextEditingController();

  String? selectedGender; // To store the selected gender
  bool isLoading = false; // To show loading spinner

  // 1. Function to open Date Picker
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        // Format the date simply as DD/MM/YYYY
        txtDate.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // 2. Function to Save Data to Firebase
  Future<void> updateUserProfile() async {
    // Basic Validation
    if (selectedGender == null ||
        txtDate.text.isEmpty ||
        txtWeight.text.isEmpty ||
        txtHeight.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill in all fields")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Get the current logged-in user's ID
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Update the existing document in 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'gender': selectedGender,
        'date_of_birth': txtDate.text,
        'weight': txtWeight.text,
        'height': txtHeight.text,
        'is_profile_completed': true, // Mark profile as done
        'last_updated': DateTime.now(),
      });

      if (mounted) {
        // Navigate to the Welcome View
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WelcomeView(),
            ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
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
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/img/sign1.png",
                  width: media.width,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Text(
                  "Let's Complete Your Profile",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "It will help us to know more about you",
                  style: TextStyle(color: TColor.grey, fontSize: 12),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      // --- GENDER DROPDOWN ---
                      Container(
                        decoration: BoxDecoration(
                            color: TColor.lightGrey,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Container(
                                width: 50,
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/img/gender.png",
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.contain,
                                  color: TColor.grey,
                                )),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedGender, // Connect variable
                                  items: ["Male", "Female"]
                                      .map((name) => DropdownMenuItem(
                                            value: name,
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                  color: TColor.grey,
                                                  fontSize: 16),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    // Update state when user selects
                                    setState(() {
                                      selectedGender = value;
                                    });
                                  },
                                  isExpanded: true,
                                  hint: Text(
                                    "Choose Gender",
                                    style: TextStyle(
                                        color: TColor.grey, fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),

                      // --- DATE OF BIRTH PICKER ---
                      // We wrap this in a GestureDetector so tapping anywhere on it opens the calendar
                      GestureDetector(
                        onTap: _selectDate,
                        child: AbsorbPointer(
                          // AbsorbPointer stops the keyboard from opening
                          child: RoundTextFeild(
                            controller: txtDate,
                            hintText: "Date of Birth",
                            icon: "assets/img/dob.png",
                          ),
                        ),
                      ),
                     
                      SizedBox(
                        height: media.width * 0.04,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: RoundTextFeild(
                              controller: txtWeight,
                              hintText: "Your Weight",
                              icon: "assets/img/weight.png",
                              keyboardType: TextInputType.number, // Add number keyboard
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: TColor.secondaryGrad),
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              "KG",
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextFeild(
                              controller: txtHeight,
                              hintText: "Your Height",
                              icon: "assets/img/height.png",
                              keyboardType: TextInputType.number, // Add number keyboard
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: TColor.secondaryGrad),
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              "INC",
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                     
                      // --- NEXT BUTTON ---
                      if (isLoading)
                        const CircularProgressIndicator()
                      else
                        RoundButton(
                          title: "Next >",
                          onPressed: () {
                            updateUserProfile(); // Call the save function
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
