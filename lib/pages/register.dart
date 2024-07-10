import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chat/utils/check_login.dart';
import 'package:chat/utils/dialog.dart';
import 'package:chat/utils/email_check.dart';
import 'package:chat/utils/env.dart';
import 'package:chat/utils/http.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart';
import '../storage/shared_preference.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  late String _nickname = '';
  late String _verifyKey = '';
  late String _email = '';
  late String _code = '';
  late String _password = '';
  late String _avatar = '';
  late Timer _timer;
  int _secondsRemaining = 60;

  Future<bool> sendCode() async {
    if (!Email.checkFormat(_email)) {
      ErrDialog().showBottomMsg(context, "email 不能为空或email格式错误");
      return false;
    }
    // 发送验证码
    var res = await HttpUtils.post("api/v1/send_register_email_code",
        data: {"email": _email});
    print(res);
    if (res["code"] != 0) {
      ErrDialog().showBottomMsg(context, res["message"]);
      return false;
    } else {
      _verifyKey = res["data"]["key"];
    }
    return true;
  }

  Future<void> _startTimer() async {
    if (_secondsRemaining == 60) {
      var res = await sendCode();
      if (!res) {
        return;
      }
    }
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) async {
      if (_secondsRemaining < 1) {
        timer.cancel();
        setState(() {
          _secondsRemaining = 60;
        });
      } else {
        setState(() {
          _secondsRemaining = _secondsRemaining - 1;
        });
      }
    });
  }

  File? _image; // 存储用户选择的图像文件
  /// 从图库选择图像并更新UI的异步方法。
  Future<void> _getImage() async {
    final picker = ImagePicker(); // 创建ImagePicker实例
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery); // 从图库中选择图像
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // 将选定的图像文件赋给_image
        uploadImage(_image!);
      });
    }
  }

  // 上传图片
  void uploadImage(File image) async {
    var dio = Dio();
    FormData formData = FormData.fromMap({
      "avatar": await MultipartFile.fromFile(image.path, filename: "image.jpg"),
    });

    Object? token = await SharedPrefer.getJwtToken();
    var headers = {
      'Authorization': token.toString(),
    };

    var response = await dio.post(
      Env().get("API_HOST") + "api/v1/upload_image_one",
      data: formData,
      options: Options(headers: headers),
    );
    var res = jsonDecode(response.toString());
    CheckLogin().check(res["code"], context);
    if (res["code"] == 0) {
      _avatar = res["data"]["uri"];
    } else {
      ErrDialog().showBottomMsg(context, res["message"]);
    }
  }

  @override
  void dispose() {
    if (_secondsRemaining < 60) {
      _timer.cancel();
    }
    super.dispose();
  }

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
                  height: 30,
                ),
                ////
                GestureDetector(
                  onTap: _getImage, // 点击头像区域时触发_getImage方法
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : null, // 根据_image是否为空设置头像图片
                    child: _image == null
                        ? const Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                ////
                const SizedBox(height: 15),
                TextFormField(
                  style: TextStyle(color: Colors.black54, fontSize: 18.sp),
                  autofocus: false,
                  decoration: InputDecoration(
                      icon: const Icon(Icons.person),
                      // filled: true,
                      // fillColor: const Color.fromRGBO(253, 247, 254, 1),
                      labelText: '用户名',
                      labelStyle: TextStyle(
                        fontSize: 18.sp,
                      ),
                      hintText: "用户名",
                      hintStyle:
                          TextStyle(fontSize: 16.sp,)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入用户名';
                    }
                    return null;
                  },
                  onChanged: (value) => _nickname = value,
                  onSaved: (value) => _nickname = value!,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  style: TextStyle(color: Colors.black54, fontSize: 18.sp),
                  autofocus: false,
                  decoration:  InputDecoration(
                      icon: const Icon(Icons.email),
                      labelText: '邮箱',
                      labelStyle:  TextStyle(
                        fontSize: 18.sp,
                      ),
                      hintText: "邮箱",
                      hintStyle: const TextStyle(fontSize: 16)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入邮箱';
                    }
                    return null;
                  },
                  onChanged: (value) => _email = value,
                  onSaved: (value) => _email = value!,
                ),
                const SizedBox(height: 15),
                Stack(
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.black54, fontSize: 18.sp),
                      autofocus: false,
                      decoration:  InputDecoration(
                          icon:const Icon(Icons.confirmation_num),
                          labelText: '验证码',
                          labelStyle: TextStyle(
                            fontSize: 18.sp,
                          ),
                          hintText: "验证码",
                          hintStyle: TextStyle(fontSize: 16)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入邮箱验证码';
                        }
                        return null;
                      },
                      onChanged: (value) => _code = value,
                      onSaved: (value) => _code = value!,
                    ),
                    Positioned(
                        right: 0,
                        top: 5,
                        child: _secondsRemaining == 60
                            ? TextButton(
                                onPressed: _startTimer,
                                child: const Text(
                                  "发送验证码",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(55, 120, 167, 1)),
                                ),
                              )
                            : TextButton(
                                onPressed: null,
                                child: Text("$_secondsRemaining秒"),
                              ))
                  ],
                ),
                const SizedBox(height: 15),
                TextFormField(
                  style: TextStyle(color: Colors.black54, fontSize: 18.sp),
                  autofocus: false,
                  obscureText: true,
                  decoration:  InputDecoration(
                      icon:const Icon(Icons.key),
                      labelText: '密码',
                      labelStyle:  TextStyle(
                        fontSize: 18.sp,
                      ),
                      hintText: "密码",
                      hintStyle: const TextStyle(fontSize: 16)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入密码';
                    }
                    return null;
                  },
                  onChanged: (value) => _password = value,
                  onSaved: (value) => _password = value!,
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

  // 注册
  void _register() async {
    print({
      "username": _nickname,
      "email": _email,
      "code": _code,
      "avatar": _avatar,
      "key": _verifyKey,
      "password": _password,
    });
    // return;
    var res = await HttpUtils.post("api/v1/register", data: {
      "username": _nickname,
      "email": _email,
      "code": _code,
      "avatar": _avatar,
      "key": _verifyKey,
      "password": _password,
    });
    if (res["code"] == 0) {
      var user = User();
      user.uid = res["data"]["uid"];
      user.jwtToken = res["data"]["access_token"];
      SharedPrefer.saveUser(user);
      Navigator.pop(context);
    } else {
      ErrDialog().showBottomMsg(context, res["message"]);
    }
  }
}
