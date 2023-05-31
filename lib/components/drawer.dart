import 'package:flutter/material.dart';
import 'package:social_media_app_mitch/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProifleTap;
  final void Function()? onSignOut;
  MyDrawer({
    super.key,
    required this.onProifleTap,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // header
              const DrawerHeader(
                  child: Icon(
                Icons.person,
                color: Colors.white,
                size: 80,
              )),

              // home
              MyListTile(
                icon: Icons.home,
                title: "H O M E",
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              // profile
              MyListTile(
                icon: Icons.person,
                title: "P R O F I L E",
                onTap: onProifleTap,
              ),
            ],
          ),

          // logout
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: MyListTile(
              icon: Icons.logout,
              title: "L O G O U T",
              onTap: onSignOut,
            ),
          ),
        ],
      ),
    );
  }
}
