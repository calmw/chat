import 'dart:convert';
import 'package:chat/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../storage/shared_preference.dart';
import '../utils/env.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late String _username = '';
  late String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromRGBO(55, 120, 167, 1),
        title: const Text(
          "登陆",
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
                  autofocus: false,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: '用户名',
                      labelStyle: const TextStyle(
                        fontSize: 18,
                      ),
                      hintText: "昵称/邮箱",
                      hintStyle: TextStyle(fontSize: 16)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入昵称或者邮箱';
                    }
                    return null;
                  },
                  onSaved: (value) => _username = value!,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  decoration: const InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: '密码',
                      labelStyle: const TextStyle(
                        fontSize: 18,
                      ),
                      hintText: "昵称/邮箱",
                      hintStyle: TextStyle(fontSize: 16)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入密码';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => {
                    if (_formKey.currentState!.validate())
                      {_formKey.currentState!.save(), _login()}
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: const Color.fromRGBO(55, 120, 167, 1),
                    fixedSize: const Size(200, 50),
                  ),
                  child: const Text(
                    "登陆",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () => {
                              Navigator.pushNamed(context, '/register'),
                            },
                        child: const Text("去注册")),
                    TextButton(onPressed: () => {}, child: const Text("忘记密码？")),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  void _login() async {
    final dio = Dio();
    final response = await dio.post(
      Env().key("API_HOST") + 'api/v1/login',
      data: {"username": _username, "password": _password},
    );
    var res = jsonDecode(response.toString());
    print(res);
    if (res["code"] == 0) {
      var user = User();
      user.uid = res["data"]["uid"];
      user.email = res["data"]["email"];
      user.jwtToken = res["data"]["access_token"];
      user.nickname = res["data"]["nickname"];
      await SharedPrefer.saveUser(user);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("登陆失败"),
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
