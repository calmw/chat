import 'dart:convert';
import 'package:chat/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../storage/shared_preference.dart';
import '../utils/env.dart';
import '../utils/toast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final FocusScopeNode focusScopeNode = FocusScopeNode();
  late String _username = '';
  late String _password = '';

  @override
  void dispose() {
    focusScopeNode.unfocus();
    focusScopeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: const Color.fromRGBO(55, 120, 167, 1),
          title: Text(
            "登陆",
            style: TextStyle(color: Colors.white, fontSize: 34.sp),
          ),
          centerTitle: true,
        ),
        body: GestureDetector(
            onTap: () {
              // 点击空白区域时，关闭软键盘并取消焦点
              FocusScope.of(context).requestFocus(FocusNode());
              SystemChannels.textInput.invokeMethod('hide');
            },
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: FocusScope(
                  node: focusScopeNode,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 150.h,
                            ),
                            Image.asset(
                              'assets/images/logo.png',
                              width: 120.w,
                              height: 120.w,
                            ),
                            SizedBox(height: 25.h),
                            TextFormField(
                              autofocus: false,
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 34.sp),
                              decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.person,
                                    size: 56.sp,
                                  ),
                                  labelText: '用户名',
                                  labelStyle: TextStyle(
                                    fontSize: 34.sp,
                                  ),
                                  hintText: "请输入用户名/邮箱",
                                  hintStyle: TextStyle(fontSize: 34.sp)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '请输入用户名或者邮箱';
                                }
                                return null;
                              },
                              onSaved: (value) => _username = value!,
                            ),
                            SizedBox(height: 20.h),
                            TextFormField(
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 34.sp),
                              decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.lock,
                                    size: 56.sp,
                                  ),
                                  labelText: '密码',
                                  labelStyle: TextStyle(
                                    fontSize: 34.sp,
                                  ),
                                  hintText: "请输入密码",
                                  hintStyle: TextStyle(fontSize: 34.sp)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '请输入密码';
                                }
                                return null;
                              },
                              onSaved: (value) => _password = value!,
                            ),
                            SizedBox(height: 40.h),
                            ElevatedButton(
                              onPressed: () => {
                                if (_formKey.currentState!.validate())
                                  {_formKey.currentState!.save(), _login()}
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                backgroundColor:
                                    const Color.fromRGBO(55, 120, 167, 1),
                                fixedSize: const Size(200, 50),
                              ),
                              child: Text(
                                "登陆",
                                style: TextStyle(
                                    fontSize: 40.sp, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () => {
                                          Navigator.pushNamed(
                                              context, '/register'),
                                        },
                                    child: Text(
                                      "去注册",
                                      style: TextStyle(fontSize: 26.sp),
                                    )),
                                TextButton(
                                    onPressed: () => {},
                                    child: Text(
                                      "忘记密码？",
                                      style: TextStyle(fontSize: 26.sp),
                                    )),
                              ],
                            ),
                          ],
                        )),
                  ),
                ))));
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
      ToastS.showShort(res["message"]);
    }
  }
}

// cisco1: s263472546b45826
// cisco2: q26347288c17fc21 eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiJxMjYzNDcyODhjMTdmYzIxIiwiZXhwIjoxNzIzMTg2ODAwLCJpc3MiOiJjaGF0In0.TxhrkXwBMs2wkdIlDxOSA4-7DTmqQcvnZgeOL7p89Y8
// cisco3: y263472928f39fce eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiJ5MjYzNDcyOTI4ZjM5ZmNlIiwiZXhwIjoxNzIzMTg2ODIyLCJpc3MiOiJjaGF0In0.s87NgzxeznaBKWCvZUVwGrverUWvpO4kDaWkz0ykOyk

// cisco1: l26351c3160ade59
// cisco2: q26351f9b7e2470a eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiJ0MjYzNDlhYTJhNmFkNzM1IiwiZXhwIjoxNzIzMjE0MjEyLCJpc3MiOiJjaGF0In0.cplZviLmGCGfrpETNmDbYp__SQFVvhe3yukbIs2dKYY
// cisco3: c26351fb9ff80281 eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiJmMjYzNDlhYWQwYjI2YjY2IiwiZXhwIjoxNzIzMjE0MjQ0LCJpc3MiOiJjaGF0In0.j2WwCD9KRIheuq9yw-bzvZItCCMT5AqjCN_N9PhKQS0
