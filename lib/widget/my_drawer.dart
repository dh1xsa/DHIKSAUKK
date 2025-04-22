import 'package:coba1/color.dart';
import 'package:coba1/screen/Home/home_screen.dart';
import 'package:coba1/screen/home/room/room_screen.dart';
import 'package:coba1/screen/login_screen.dart';
import 'package:coba1/widget/my_drawer_tile.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

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
              text: "H O M E",
              icon: Iconsax.home,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              }
          ),
          MyDrawerTile(
              text: "R O O M",
              icon: Iconsax.ticket,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RoomScreen()),
                );
              }
          ),

          MyDrawerTile(
              text: "F A C I L I T Y",
              icon: Iconsax.building,
              onTap: () {}
          ),

          const SizedBox(height: 350),

          MyDrawerTile(
            text: "L O G O U T",
            icon: Iconsax.logout,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: kBackgroundColor,
                  title: Text("Konfirmasi Logout"),
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