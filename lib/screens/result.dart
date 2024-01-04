import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

class MyChatApp extends StatelessWidget {
  const MyChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> messages = [];
  final TextEditingController _textController = TextEditingController();

  void addMessage(String sender, String text) {
    setState(() {
      messages.add(Message(sender: sender, text: text));
    });
  }

  Future<String?> _getTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> _getRefreshTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }  

  Future<void> _saveTokenToSharedPreferences(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<String> refreshToken() async {
    const String apiUrl = 'http://127.0.0.1:8000/0.1.0/api/auth/refreshToken';

    String? refreshToken = await _getRefreshTokenFromSharedPreferences();

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
      );
      final token = jsonDecode(response.body)['access_token'];
      return token;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void sendApiRequest() async {
    const apiUrl = 'http://35.180.72.15/api/items/ask';
    String question = _textController.text;

    String? authToken = await _getTokenFromSharedPreferences();

    authToken ??= await refreshToken();

    final Map<String, dynamic> requestData = {
      'itemID': '1',
      'question': question,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String answer = responseData['response'];
        // Add the received message to the chat
        addMessage('Brain', answer);
      } else {
        SnackBar(content: Text(response.body));
      }
    } catch (e) {
      SnackBar(content: Text(e.toString()));
    }
  }

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
              onPressed: () {
                Navigator.pop(context);
              },
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
      body: Column(
        children: [
          Expanded(
            child: ChatWidget(messages: messages),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Row(
                children: [
                  Expanded(
                    child: OutlineGradientButton(
                      onTap: () => showDialog<String>(
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
                                          controller: _textController,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          maxLines: null,
                                          minLines: 3,
                                          decoration: InputDecoration(
                                            hintText: 'Searching for...',
                                            hintStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                            filled: true,
                                            fillColor: const Color.fromRGBO(
                                                30, 30, 38, 1),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
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
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
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
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      sendApiRequest();
                                      _textController.clear();
                                      Navigator.pop(context);
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
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF6163B1),
                          Color(0xFF6F3D6D),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      strokeWidth: 2,
                      radius: const Radius.circular(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/brain.png',
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(width: 8.0),
                          const Text(
                            'Click here to make search',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatWidget extends StatelessWidget {
  final List<Message> messages;

  const ChatWidget({super.key, required this.messages});

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
              color: Colors.black,
            ),
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
          ),
          const SizedBox(width: 8.0),
          Container(
            width: 250,
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

  bool get isMe => sender == 'Me';
}
