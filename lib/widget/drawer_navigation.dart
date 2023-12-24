// ignore_for_file: use_build_context_synchronously

import 'package:edgepos/app_color.dart';
import 'package:edgepos/pages/login_page.dart';
import 'package:edgepos/services/login_api.dart';
import 'package:flutter/material.dart';

class DrawerNavigation extends StatelessWidget {
  const DrawerNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  // You can add user profile picture here
                ),
                SizedBox(height: 10),
                Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'john.doe@example.com',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Informasi Pengguna'),
            onTap: () {
              // Implementasi aksi ketika menu Informasi Pengguna diklik
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu),
            title: const Text('Menu Dummy 1'),
            onTap: () {
              // Implementasi aksi ketika menu Menu Dummy 1 diklik
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu),
            title: const Text('Menu Dummy 2'),
            onTap: () {
              // Implementasi aksi ketika menu Menu Dummy 2 diklik
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () async {
              await LoginApi.logout();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
