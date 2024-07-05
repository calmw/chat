import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatState();
  }
}

class ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Center(child: Text("chat",style: TextStyle(fontSize: 26),),);
  }
}
