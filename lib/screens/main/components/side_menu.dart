import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Manage Pyments",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {
              Navigator.of(context).pushNamed('/First');
            },
          ),
          DrawerListTile(
            title: "View Feedbacks",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {
              Navigator.of(context).pushNamed('/third');
            },
          ),
          DrawerListTile(
            title: "View Client Prodress",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {
              Navigator.of(context).pushNamed('/Second');
            },
          ),
          DrawerListTile(
            title: "Show Class Eqipments",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
