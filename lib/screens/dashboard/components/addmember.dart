import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddMemberDialog extends StatefulWidget {
  @override
  _AddMemberDialogState createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  String selectedRole = 'customer'; // Default role value

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add New Member"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Set border radius
      ),
      contentPadding: EdgeInsets.all(20), // Add padding around the content
      content: Container(
        width: 400, // Set a specific width for the content
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Centered image with rounded corners
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey, // Set image background color
                  borderRadius: BorderRadius.circular(50), // Rounded corners
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/images/add.jpg', // Provide the correct path to your image asset
                      width: 100,
                      height: 100,
                      fit: BoxFit
                          .cover, // Adjust how the image fills the container
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              TextFormField(
                controller: passwordController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                obscureText: true,
              ),
              TextFormField(
                controller: confirmPasswordController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                obscureText: true,
                // Add validation for matching passwords
              ),
              TextFormField(
                controller: firstNameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "First Name",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              TextFormField(
                controller: lastNameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Last Name",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              DropdownButton<String>(
                value: selectedRole,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
                items: ['customer', 'instructor']
                    .map((role) => DropdownMenuItem<String>(
                          value: role,
                          child:
                              Text(role, style: TextStyle(color: Colors.white)),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text("Cancel", style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () async {
            await saveDataToFirebase();
            Navigator.of(context).pop();
          },
          child: Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
      backgroundColor: Color.fromARGB(255, 26, 26, 43),
    );
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Data saved successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorPopup(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveDataToFirebase() async {
    try {
      print("Creating user...");
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      print("User created: ${userCredential.user?.uid}");

      print("Saving user data to Firestore...");
      await FirebaseFirestore.instance.collection('users').add({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'role': selectedRole,
      });
      _showSuccessPopup();
    } catch (e) {
      print("Error: $e");
      _showErrorPopup("An error occurred while saving data.");
    }
  }
}
