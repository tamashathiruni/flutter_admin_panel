import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'file_info_card.dart';
import '../../../constants.dart';
import 'package:admin/responsive.dart';

Future<int> getTotalUsersByRole(String role) async {
  // Get the current date in YYYY-MM-DD format
  String currentDate = DateTime.now().toString().substring(0, 10);

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: role)
      .get();

  return snapshot.size;
}

class CloudStorageInfo {
  final String? svgSrc, title, numOfFiles;
  final int? percentage;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

class MyFiles extends StatelessWidget {
  const MyFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: _getTotalUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final totalCustomers = snapshot.data?['totalCustomers'];
        final totalInstructors = snapshot.data?['totalInstructors'];

        if (totalCustomers == null || totalInstructors == null) {
          return Center(child: Text('Data is missing or null.'));
        }

        List<CloudStorageInfo> demoMyFiles = [
          CloudStorageInfo(
            title: "Total Customers : $totalCustomers",
            numOfFiles: "$totalCustomers",
            svgSrc: "assets/icons/man.png",
            color: primaryColor,
            percentage: 40,
          ),
          CloudStorageInfo(
            title: "Total Instructions : $totalInstructors",
            numOfFiles: "$totalInstructors",
            svgSrc: "assets/images/trainer.png",
            color: Color(0xFFFFA113),
            percentage: 35,
          ),
        ];

        final Size _size = MediaQuery.of(context).size;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Overview",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              SizedBox(height: defaultPadding),
              Responsive(
                mobile: FileInfoCardGridView(
                  demoMyFiles: demoMyFiles,
                  crossAxisCount: _size.width < 750 ? 1 : 4,
                  childAspectRatio: _size.width < 750 ? 2 : 3,
                ),
                desktop: FileInfoCardGridView(
                  demoMyFiles: demoMyFiles,
                  childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
                ),
              ),
              SizedBox(height: 20)
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, int>> _getTotalUsers() async {
    int totalCustomers = await getTotalUsersByRole('customer');
    int totalInstructors = await getTotalUsersByRole('instructor');

    return {
      'totalCustomers': totalCustomers,
      'totalInstructors': totalInstructors,
    };
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    required this.demoMyFiles,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final List<CloudStorageInfo> demoMyFiles;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height *
            0.5, // Adjust maxHeight as needed
      ),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: demoMyFiles.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: defaultPadding,
          mainAxisSpacing: defaultPadding,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) => FileInfoCard(info: demoMyFiles[index]),
      ),
    );
  }
}
