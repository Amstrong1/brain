import 'package:flutter/material.dart';

void main() {
  runApp(const MyChatApp());
}

class MyChatApp extends StatelessWidget {
  const MyChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17171F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF17171F),
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 12,
              ),
              onPressed: () {},
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Brain Search',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 12,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: ChatWidget(),
    );
  }
}

class ChatWidget extends StatelessWidget {
  final List<Message> messages = [
    Message(sender: 'Me', text: 'Hello!'),
    Message(sender: 'Brain', text: 'Hi there!'),
    Message(sender: 'Me', text: 'How are you?'),
    Message(sender: 'Brain', text: 'I\'m good, thanks!'),
  ];

  ChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Image.asset(
            'assets/icons/brain.png',
            height: 120,
            width: 120,
          ),
        ),
        Expanded(
            child: ListView.builder(
          // reverse: true, // Start from the bottom of the list
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            return MessageWidget(message: messages[index]);
          },
        )),
      ],
    );
  }
}

class MessageWidget extends StatelessWidget {
  final Message message;

  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black, // Set your desired background color
            ),
            // child: CircleAvatar(
            child: message.isMe
                ? Text(message.sender[0])
                : Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Image.asset(
                      'assets/icons/brain.png',
                      height: 20,
                      width: 20,
                    ),
                  ),
            // ),
          ),
          const SizedBox(width: 8.0),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: message.isMe ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message.text,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String sender;
  final String text;

  Message({required this.sender, required this.text});

  bool get isMe => sender == 'Me'; // You can customize this logic as needed
}
