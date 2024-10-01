import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart'; // Ensure this is correctly pointing to your constants file

class Package {
  final String packageName;
  final double packagePrice;

  Package({
    required this.packageName,
    required this.packagePrice,
  });
}

Future<List<Package>> getPackagesFromFirestore() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('packages').get();

    List<Package> packages = [];
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      packages.add(Package(
        packageName: document.get('packageName') ?? '',
        packagePrice: (document.get('packagePrice') as num).toDouble(),
      ));
    }

    return packages;
  } catch (e) {
    print('Error fetching packages: $e');
    return []; // Return an empty list in case of error
  }
}

class StorageDetails extends StatelessWidget {
  const StorageDetails({Key? key}) : super(key: key);

  Future<void> _savePackageToFirestore(Package package) async {
    try {
      await FirebaseFirestore.instance.collection('packages').add({
        'packageName': package.packageName,
        'packagePrice': package.packagePrice,
      });
    } catch (e) {
      print('Error saving package: $e');
    }
  }

  Future<bool?> showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this package?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Storage Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              _showAddPackageDialog(context);
            },
            icon: const Icon(Icons.add),
            label: const Text("Add New Package"),
          ),
          const SizedBox(height: defaultPadding),
          FutureBuilder<List<Package>>(
            future: getPackagesFromFirestore(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              List<Package> packages = snapshot.data ?? [];

              if (packages.isEmpty) {
                return Center(child: Text('No Packages Available'));
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Package Name')),
                    DataColumn(label: Text('Package Price')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: packages.map((package) {
                    return DataRow(cells: [
                      DataCell(Text(package.packageName)),
                      DataCell(Text(package.packagePrice.toString())),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showUpdatePackageDialog(context, package);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              bool? confirmed =
                                  await showConfirmationDialog(context);
                              if (confirmed == true) {
                                await _deletePackage(package);
                              }
                            },
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showUpdatePackageDialog(BuildContext context, Package package) {
    TextEditingController nameController =
        TextEditingController(text: package.packageName);
    TextEditingController priceController =
        TextEditingController(text: package.packagePrice.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 31, 25, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: const Text('Update Package',
              style: TextStyle(color: Colors.white)),
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Package Name',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 12.0),
                TextField(
                  controller: priceController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Package Price',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String packageName = nameController.text;
                double packagePrice =
                    double.tryParse(priceController.text) ?? 0.0;

                if (packageName.isNotEmpty && packagePrice > 0) {
                  Package updatedPackage = Package(
                      packageName: packageName, packagePrice: packagePrice);
                  await _updatePackage(package, updatedPackage);
                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updatePackage(
      Package originalPackage, Package updatedPackage) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('packages')
          .where('packageName', isEqualTo: originalPackage.packageName)
          .get();

      for (var document in querySnapshot.docs) {
        await document.reference.update({
          'packageName': updatedPackage.packageName,
          'packagePrice': updatedPackage.packagePrice,
        });
      }
    } catch (e) {
      print('Error updating package: $e');
    }
  }

  Future<void> _deletePackage(Package package) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('packages')
          .where('packageName', isEqualTo: package.packageName)
          .get();

      for (var document in querySnapshot.docs) {
        await document.reference.delete();
      }
    } catch (e) {
      print('Error deleting package: $e');
    }
  }

  void _showAddPackageDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 31, 25, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: const Text('Add New Package',
              style: TextStyle(color: Colors.white)),
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Package Name',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 12.0),
                TextField(
                  controller: priceController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Package Price',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String packageName = nameController.text;
                double packagePrice =
                    double.tryParse(priceController.text) ?? 0.0;

                if (packageName.isNotEmpty && packagePrice > 0) {
                  Package newPackage = Package(
                      packageName: packageName, packagePrice: packagePrice);
                  await _savePackageToFirestore(newPackage);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
