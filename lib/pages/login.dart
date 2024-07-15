import 'dart:convert';
import 'package:chat/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../storage/shared_preference.dart';
import '../utils/dialog.dart';
import '../utils/env.dart';

class Login extends StatefulWidget {
  const Login({super.key});

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
        automaticallyImplyLeading: false,
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
                  style: TextStyle(color: Colors.black54, fontSize: 18.sp),
                  decoration:  InputDecoration(
                      icon: const Icon(Icons.person),
                      labelText: '用户名',
                      labelStyle:  TextStyle(
                        fontSize: 18.sp,
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
                  style: TextStyle(color: Colors.black54, fontSize: 18.sp),
                  decoration:  InputDecoration(
                      icon: const Icon(Icons.lock),
                      labelText: '密码',
                      labelStyle: TextStyle(
                        fontSize: 18.sp,
                      ),
                      hintText: "昵称/邮箱",
                      hintStyle: const TextStyle(fontSize: 16)),
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
      Env().get("API_HOST") + 'api/v1/login',
      data: {"username": _username, "password": _password},
    );
    var res = jsonDecode(response.toString());
    if (res["code"] == 0) {
      var user = User();
      user.uid = res["data"]["uid"];
      user.jwtToken = res["data"]["access_token"];
      await SharedPrefer.saveUser(user);
      Navigator.pushNamed(context, '/');
    } else {
      ErrDialog().showBottomMsg(context, res["message"]);
    }
  }
}

// cisco1: s263472546b45826
// cisco2: q26347288c17fc21 eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiJxMjYzNDcyODhjMTdmYzIxIiwiZXhwIjoxNzIzMTg2ODAwLCJpc3MiOiJjaGF0In0.TxhrkXwBMs2wkdIlDxOSA4-7DTmqQcvnZgeOL7p89Y8
// cisco3: y263472928f39fce eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiJ5MjYzNDcyOTI4ZjM5ZmNlIiwiZXhwIjoxNzIzMTg2ODIyLCJpc3MiOiJjaGF0In0.s87NgzxeznaBKWCvZUVwGrverUWvpO4kDaWkz0ykOyk

// cisco1: q26349accef3391c
// cisco2: t26349aa2a6ad735 eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiJ0MjYzNDlhYTJhNmFkNzM1IiwiZXhwIjoxNzIzMjE0MjEyLCJpc3MiOiJjaGF0In0.cplZviLmGCGfrpETNmDbYp__SQFVvhe3yukbIs2dKYY
// cisco3: f26349aad0b26b66 eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiJmMjYzNDlhYWQwYjI2YjY2IiwiZXhwIjoxNzIzMjE0MjQ0LCJpc3MiOiJjaGF0In0.j2WwCD9KRIheuq9yw-bzvZItCCMT5AqjCN_N9PhKQS0

