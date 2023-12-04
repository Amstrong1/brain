import 'package:flutter/material.dart';
import '../helpers/setters.dart';

class MaterielExploration extends StatelessWidget {
  const MaterielExploration({super.key});

  @override
  Widget build(BuildContext context) {
    // void chat(BuildContext context) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (_) {
    //         return const Chat();
    //       },
    //     ),
    //   );
    // }

    return ListView.builder(
      itemCount: dummyNoteList.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dummyNoteList[index].date,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    dummyNoteList[index].title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => (),
                      icon: const Icon(
                        Icons.mail,
                        color: Color.fromRGBO(198, 240, 254, 1),
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
