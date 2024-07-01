import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../storage/shared_preference.dart';

class Register extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegisterState();
  }
  
}
class RegisterState extends State<Register>{
  final _formKey = GlobalKey<FormState>();
  late String _username = '';
  late String _password = '';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromRGBO(55, 120, 167, 1),
        title: const Text(
          "注册",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 150,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  width: 60,
                  height: 60,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autofocus: true,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: '昵称',
                      labelStyle: const TextStyle(
                        fontSize: 18,
                      ),
                      hintText: "昵称",
                      hintStyle: TextStyle(fontSize: 16)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入昵称';
                    }
                    return null;
                  },
                  onSaved: (value) => _username = value!,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autofocus: true,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: '邮箱',
                      labelStyle: const TextStyle(
                        fontSize: 18,
                      ),
                      hintText: "邮箱",
                      hintStyle: TextStyle(fontSize: 16)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入邮箱';
                    }
                    return null;
                  },
                  onSaved: (value) => _username = value!,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autofocus: true,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: '验证码',
                      labelStyle: const TextStyle(
                        fontSize: 18,
                      ),
                      hintText: "验证码",
                      hintStyle: TextStyle(fontSize: 16)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入邮箱验证码';
                    }
                    return null;
                  },
                  onSaved: (value) => _username = value!,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autofocus: true,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: '密码',
                      labelStyle: const TextStyle(
                        fontSize: 18,
                      ),
                      hintText: "密码",
                      hintStyle: TextStyle(fontSize: 16)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入密码';
                    }
                    return null;
                  },
                  onSaved: (value) => _username = value!,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => {
                    if (_formKey.currentState!.validate())
                      {_formKey.currentState!.save(), _register()}
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: const Color.fromRGBO(55, 120, 167, 1),
                    fixedSize: const Size(200, 50),
                  ),
                  child: const Text(
                    "注册",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () => {
                          Navigator.pushNamed(context, '/login'),
                        },
                        child: const Text("去登陆")),
                    TextButton(onPressed: () => {}, child: const Text("忘记密码？")),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  void _register() async {
    final dio = Dio();
    final response = await dio.post(
      'http://192.168.0.101:8080/api/v1/login',
      data: {"username": _username, "password": _password},
    );
    var res = jsonDecode(response.toString());
    print(res);
    if (res["code"] == 0) {
      var user = User();
      user.uid = res["data"]["uid"];
      user.jwtToken = res["data"]["access_token"];
      user.nickname = res["data"]["nickname"];
      Utils.saveUser(user);
      // Navigator.pushNamed(context, '/index');
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("注册失败"),
            content: Text(res["message"]),
            actions: [
              TextButton(
                child: const Text('确认'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}