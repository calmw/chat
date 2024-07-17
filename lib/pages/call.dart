import 'package:flutter/material.dart';

class Call extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CallState();
  }
  
}
class CallState extends State<Call>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: const Text(
            'Login',
            style: TextStyle(fontSize: 24),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          child: const Text(
            'Register',
            style: TextStyle(fontSize: 24),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/test');
          },
          child: const Text(
            'test',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ],
    );
  }
  
}