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
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text(
                'AI Brain Search',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color(0xFF17171F),
              content: SizedBox(
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              maxLines: null,
                              minLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Searching for...',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                filled: true,
                                fillColor: const Color.fromRGBO(30, 30, 38, 1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          Ink(
                            decoration: const ShapeDecoration(
                              shape: CircleBorder(),
                              color: Color(0xFF6F3D6D),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.keyboard_voice,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        gradient: LinearGradient(colors: [
                          Color(0xFF6163B1),
                          Color(0xFF6F3D6D),
                        ]),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
