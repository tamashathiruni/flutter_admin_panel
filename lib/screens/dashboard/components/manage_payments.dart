import 'package:admin/controllers/dtabse.dart'; // Import the correct controller
import 'package:admin/models/user.dart'; // Import the correct model
import 'package:flutter/material.dart';

class ManagePayments extends StatefulWidget {
  @override
  _ManagePaymentsState createState() => _ManagePaymentsState();
}

class _ManagePaymentsState extends State<ManagePayments> {
  late UserController userController;
  List<UserModel> users = [];
  List<bool> _paymentStatus = []; // Local state to manage checkbox status

  @override
  void initState() {
    super.initState();
    userController = UserController();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      List<UserModel> fetchedUsers = await userController.fetchUsers();

      setState(() {
        users = fetchedUsers;
        _paymentStatus = List<bool>.filled(users.length, false, growable: true);
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Future<void> _updatePaymentStatus(
      String userId, bool value, int index) async {
    await userController.updatePaymentStatus(
        userId, value); // Update in Firestore
    setState(() {
      _paymentStatus[index] = value; // Update local state
    });
  }

  Future<void> _updatePaymentStatuss(
      String userId, bool value, int index) async {
    await userController.updatePaymentStatuss(
        userId, value); // Update in Firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users List')),
      body: users.isEmpty
          ? const Center(
              child: CircularProgressIndicator()) // Loading indicator
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: Checkbox(
                    value: user
                        .payment, // Bind directly to the user's payment field
                    onChanged: (bool? value) async {
                      if (value != null) {
                        // First, update Firestore and await the result

                        await _updatePaymentStatus(user.id, value, index);
                        await _updatePaymentStatuss(user.id, value, index);

                        // After the Firestore update, update the local state
                        setState(() {
                          user.payment =
                              value; // Update the local user's payment field
                        });
                      }
                    },
                  ),
                  title: Text('${user.first_name} ${user.last_name}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Roll: ${user.roll}'),
                      Row(
                        children: [
                          Text('Payment Status: ${user.payment}'),
                        ],
                      ),
                    ],
                  ),
                  contentPadding: EdgeInsets.all(16.0),
                  tileColor: const Color.fromARGB(255, 33, 35, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                );
              },
            ),
    );
  }
}
