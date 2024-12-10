// ignore_for_file: prefer_const_constructors, unused_element, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:instagram/data/local/cash_helper.dart';
import 'package:instagram/logic/state_managments/auth_cubit/auth_cubit.dart';

Widget buildInfo(String label, String count) {
  return Column(
    children: [
      Text(
        count,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      Text(label),
    ],
  );
}

Widget buildDrawer(BuildContext context) {
  return Drawer(
    elevation: 5,
    width: 200,
    child: ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text("Logout"),
          onTap: () {
         AuthCubit.get(context).logout;
         CacheHelper.deleteData(key: 'uId');
         Navigator.pushReplacementNamed(context,'login');
          },
        ),
      ],
    ),
  );
}
