import 'package:admin/controllers/feedbakcontraller.dart';
import 'package:flutter/material.dart';

class ClientRatingsView extends StatefulWidget {
  @override
  _ClientRatingsViewState createState() => _ClientRatingsViewState();
}

class _ClientRatingsViewState extends State<ClientRatingsView> {
  final ClientController _clientController = ClientController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Client Ratings")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _clientController.fetchClientsAndRatings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(
                "FutureBuilder Error: ${snapshot.error}"); // Add this to see the full error
            return Center(child: Text("Error fetching data"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No ratings found"));
          }

          // Display the list of clients and their ratings
          List<Map<String, dynamic>> clients = snapshot.data!;
          return ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              var client = clients[index];
              return ListTile(
                title: Text(client['name']),
                subtitle: Text("Rating: ${client['rating']}"),
              );
            },
          );
        },
      ),
    );
  }
}
