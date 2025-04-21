import 'package:coba1/color.dart';
import 'package:coba1/screen/admin/screen_admin/facility_view.dart';
import 'package:coba1/screen/login_screen.dart';
import 'package:coba1/widget/my_drawer_tile.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../screen_admin/room_view_screen.dart';

class MyDrawerAdmin extends StatelessWidget {
  const MyDrawerAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Icon(
              Icons.lock_open_rounded,
              size: 80,
              color: Colors.black87,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(
              color: Colors.black87,
            ),
          ),

          MyDrawerTile(
              text: "R O O M",
              icon: Iconsax.ticket,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RoomViewScreen()),
                );
              }
          ),
          MyDrawerTile(
              text: "H O T E L  F A C I L I T Y",
              icon: Iconsax.building,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FacilityViewScreen()),
                );
              }
          ),

          const SizedBox(height: 400),

          MyDrawerTile(
            text: "L O G O U T",
            icon: Iconsax.logout,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: kBackgroundColor,
                  title: Text("Logout Confirmation"),
                  content: Text("Apakah kamu yakin ingin logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Batal",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        "LogOut",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}