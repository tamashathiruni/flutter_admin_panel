import 'package:admin/constants.dart';
import 'package:admin/controllers/MenuController.dart' as admin;
import 'package:admin/firebase_options.dart';
import 'package:admin/screens/dashboard/components/feedback.dart';
import 'package:admin/screens/dashboard/components/manage_payments.dart';
import 'package:admin/screens/dashboard/components/manageprogres.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LetFit Admin Panel',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => admin.MenuController(),
            ),
          ],
          child: MainScreen(),
        ),
        routes: {
          '/First': (context) => ManagePayments(),
          '/Second': (context) => progress(),
          '/third': (context) => ClientRatingsView(),
        });
  }
}
