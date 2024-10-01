import 'package:admin/screens/dashboard/components/addmember.dart';
import 'package:admin/screens/dashboard/components/storage_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';

import '../../../constants.dart';
import '../../../responsive.dart';

class UserDetailsDialog extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String userId;
  final String role;

  UserDetailsDialog({
    required this.firstName,
    required this.lastName,
    required this.userId,
    required this.role,
  });

  Future<List<Package>> getPackagesFromFirestore() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('packages').get();

    List<Package> packages = [];
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      packages.add(Package(
        packageName: document['packageName'],
        packagePrice: document['packagePrice'],
      ));
    }

    return packages;
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    bool confirmed = false; // Initialize to false

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to delete this user?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel the deletion
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm the deletion
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    ).then((value) {
      // This is called when the dialog is dismissed
      confirmed =
          value ?? false; // Use value if not null, otherwise set to false
    });

    return confirmed; // Return the confirmed value
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'User Details',
        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
      ),
      content: Container(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text('First Name: $firstName'),
            SizedBox(height: 10),
            Text('Last Name: $lastName'),
            SizedBox(height: 10),
            Text('User ID: $userId'),
            SizedBox(height: 10),
            Text('Role: $role'),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 0, 0, 0)),
          child: Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                String challengeName = "";
                String challengeGoal = "";
                String challengeDescription = "";

                return AlertDialog(
                  title: Text(
                    'Assign Challenges',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Challenge Name',
                        ),
                        onChanged: (value) {
                          challengeName = value;
                        },
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Challenge Goal',
                        ),
                        onChanged: (value) {
                          challengeGoal = value;
                        },
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Challenge Description',
                        ),
                        onChanged: (value) {
                          challengeDescription = value;
                        },
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () async {
                        if (challengeName.isNotEmpty &&
                            challengeGoal.isNotEmpty) {
                          // Save challenge data to user's document
                          await FirebaseFirestore.instance
                              .collection('challenges')
                              .doc(
                                  userId) // Use the user's ID as the document ID
                              .set({
                            'challengeName': challengeName,
                            'challengeGoal': challengeGoal,
                            'challengeDescription': challengeDescription,
                          });

                          Navigator.pop(context); // Close the dialog
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: Text('Assign'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('Cancel'),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Color.fromARGB(255, 20, 18, 29),
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Assign Challenges',
            style:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            DocumentSnapshot exerciseDataSnapshot = await FirebaseFirestore
                .instance
                .collection('exercise_data')
                .doc(userId)
                .get();

            if (exerciseDataSnapshot.exists) {
              Map<String, dynamic> data =
                  exerciseDataSnapshot.data() as Map<String, dynamic>;
              int footSteps = int.tryParse(data['footSteps'] ?? '0') ?? 0;
              int waterIntake = int.tryParse(data['waterIntake'] ?? '0') ?? 0;

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Today\'s Goal'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Footsteps: $footSteps'),
                        Text('Water Intake: $waterIntake'),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Today\'s Goal'),
                    content: Text('No data available for today.'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: Text('View Today Goal'),
        ),
        ElevatedButton(
          onPressed: () async {
            List<Package> packages = await getPackagesFromFirestore();
            String selectedPackageName = packages[0].packageName;

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Assign Package'),
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButton<String>(
                            value: selectedPackageName,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedPackageName = newValue!;
                              });
                            },
                            items: packages.map((Package package) {
                              return DropdownMenuItem<String>(
                                value: package.packageName,
                                child: Text(package.packageName),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    },
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey, // Change the button color
                      ),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Save the assigned package to the user's document
                        await assignPackageToUser(userId, selectedPackageName);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(
                            255, 223, 171, 0), // Change the button color
                      ),
                      child: Text('Save'),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Color.fromARGB(
                      255, 20, 18, 29), // Custom background color
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Color.fromARGB(255, 223, 171, 0), // Change the button color
          ),
          child: Text('Assign Package'),
        ),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Confirm Due Payment'),
                  content:
                      Text('Are you sure you want to mark the payment as due?'),
                  actions: [
                    ElevatedButton(
                      onPressed: () async {
                        // Set the "payment" field to false in the document with the given userId
                        DocumentReference userDocRef = FirebaseFirestore
                            .instance
                            .collection('payment')
                            .doc(userId);
                        DocumentSnapshot userDoc = await userDocRef.get();

                        if (userDoc.exists) {
                          userDocRef.update({'payment': false});
                        } else {
                          // Create a new document with the userId and payment field set to false
                          userDocRef.set({'userId': userId, 'payment': false});
                        }

                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: Text('Yes'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('No'),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 196, 14, 29)),
          child: Text('Due Payment'),
        ),
        ElevatedButton(
          onPressed: () async {
            int totalCount = await fetchAttendanceCount(userId);

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Attendance Information'),
                  content: Text(
                      'Attendance count for $firstName $lastName: $totalCount'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 5, 147, 172),
          ),
          child: Text('View Attendance'),
        ),
        TextButton(
          onPressed: () async {
            final confirmed = await _showConfirmationDialog(context);
            if (confirmed) {
              await deleteUser(context, userId);
              Navigator.of(context).pop(); // Close the form/dialog
            }
          },
          child: Text("Delete",
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Color.fromARGB(255, 20, 18, 29),
    );
  }
}

class UserActionButton extends StatelessWidget {
  final String userId;
  final String firstName;
  final String lastName;
  final String role;

  UserActionButton({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return UserDetailsDialog(
              firstName: firstName,
              lastName: lastName,
              userId: userId,
              role: role,
            );
          },
        );
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        "View User",
        style: TextStyle(fontFamily: 'Poppins'),
      ),
    );
  }
}

Future<void> assignPackageToUser(String userId, String packageName) async {
  try {
    // Fetch the selected package from the Firestore collection
    QuerySnapshot packageQuerySnapshot = await FirebaseFirestore.instance
        .collection('packages')
        .where('packageName', isEqualTo: packageName)
        .get();

    if (packageQuerySnapshot.docs.isNotEmpty) {
      DocumentSnapshot packageDocument = packageQuerySnapshot.docs.first;
      Map<String, dynamic> packageData =
          packageDocument.data() as Map<String, dynamic>;

      // Update the user's document with the assigned package details
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('payment').doc(userId);
      await userDocRef.update({
        'assignedPackage': {
          'packageName': packageData['packageName'],
          'packagePrice': packageData['packagePrice'],
        },
      });
    }
  } catch (e) {
    print('Error assigning package: $e');
  }
}

Future<void> _showErrorPopup(BuildContext context, String errorMessage) {
  return showDialog(
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

Future<Map<String, int>> getAttendanceCounts() async {
  Map<String, int> attendanceCounts = {};

  try {
    final firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot =
        await firestore.collection('users').get();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      final userData = document.data() as Map<String, dynamic>;
      final userId = userData['userId'] ?? '';

      if (userId.isNotEmpty) {
        int totalCount = await fetchAttendanceCount(userId);
        attendanceCounts[userId] = totalCount;
      }
    }
  } catch (e) {
    print("Error fetching attendance counts: $e");
  }

  return attendanceCounts;
}

Future<int> fetchAttendanceCount(String userId) async {
  int totalCount = 0;

  try {
    final firestore = FirebaseFirestore.instance;
    final QuerySnapshot attendanceSnapshot =
        await firestore.collection('attendance').get();

    for (QueryDocumentSnapshot docSnapshot in attendanceSnapshot.docs) {
      final attendanceData = docSnapshot.data() as Map<String, dynamic>;

      // Count fields that match the format userId$userId
      for (String key in attendanceData.keys) {
        if (key.contains("userId" + userId)) {
          totalCount++;
        }
      }
    }
  } catch (e) {
    print("Error fetching attendance count: $e");
  }

  return totalCount;
}

Future<void> deleteUser(BuildContext context, String userId) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.uid == userId) {
      await user.delete();
    }

    print("User deleted successfully");
  } catch (e) {
    print("Error deleting user: $e");
    _showErrorPopup(context, "An error occurred while deleting the user.");
  }
}

class RecentFiles extends StatelessWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: defaultPadding * 1.5,
                vertical:
                    defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AddMemberDialog();
                },
              );
            },
            icon: Icon(Icons.add),
            label: Text("Add New Member"),
          ),
          SizedBox(height: defaultPadding),
          SizedBox(height: defaultPadding),
          Text(
            "Users Table",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                List<DataRow> rows = [];
                snapshot.data!.docs.forEach((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final userId = doc.id;
                  final firstName = data['firstName'] ?? '';
                  final lastName = data['lastName'] ?? '';
                  final role = data['role'] ?? '';

                  rows.add(
                    DataRow(
                      cells: [
                        DataCell(Text(firstName)),
                        DataCell(Text(lastName)),
                        DataCell(Text(role)),
                        DataCell(UserActionButton(
                          userId: userId,
                          firstName: firstName,
                          lastName: lastName,
                          role: role,
                        )),
                      ],
                    ),
                  );
                });

                return DataTable2(
                  columnSpacing: defaultPadding,
                  columns: [
                    DataColumn(label: Text("First Name")),
                    DataColumn(label: Text("Last Name")),
                    DataColumn(label: Text("Role")),
                    DataColumn(label: Text("Action")),
                  ],
                  rows: rows,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
