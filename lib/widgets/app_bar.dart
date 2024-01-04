import 'package:brain/screens/result.dart';
import 'package:flutter/material.dart';

import '../helpers/database.dart';
import '../screens/profile.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({Key? key, required this.databaseHelper}) : super(key: key);

  final DatabaseHelper databaseHelper;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1.0,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(2.0),
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color.fromRGBO(30, 30, 38, 1),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.dashboard_outlined,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () {
              // Handle your first icon press
            },
          ),
        ),
        const Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1.0,
          ),
        ),
        // brain icon
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatScreen(),
              ),
            );
          },
          child: Image.asset(
            'assets/icons/brain.png',
            height: 100,
            width: 100,
          ),
        ),
        const Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1.0,
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color.fromRGBO(30, 30, 38, 1),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.person_outlined,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return ProfileScreen(databaseHelper: databaseHelper);
                  },
                ),
              );
            },
          ),
        ),
        const Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1.0,
          ),
        ),
      ],
    );
  }
}
