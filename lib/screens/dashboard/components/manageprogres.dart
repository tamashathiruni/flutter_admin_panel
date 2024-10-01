import 'package:admin/controllers/progresscon.dart';
import 'package:admin/models/progress.dart';
import 'package:flutter/material.dart';

class progress extends StatefulWidget {
  @override
  State<progress> createState() => _progressState();
}

class _progressState extends State<progress> {
  late progresscontraller ussser;
  List<userprogress> progress = [];

  @override
  void initState() {
    super.initState();
    ussser = progresscontraller();
    _getUsers();
  }

  Future<void> _getUsers() async {
    try {
      List<userprogress> fetchdata = await ussser.getuserprogress();
      setState(() {
        progress = fetchdata;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Progress'),
      ),
      body: progress.isEmpty
          ? const Center(
              child: CircularProgressIndicator()) // Loading indicator
          : ListView.builder(
              itemCount: progress.length,
              itemBuilder: (context, index) {
                final program = progress[index];
                return ListTile(
                  title: Text('Progress Of the Users '),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jumping_Jack: ${program.Jumping_Jack}'),
                      Row(
                        children: [
                          Text('Rest_and_Drink : ${program.Rest_and_Drink}'),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Skipping: ${program.Skipping}'),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Rest_and_Drink: ${program.Rest_and_Drink}'),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
