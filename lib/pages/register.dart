import 'dart:convert';
import 'dart:io';
import 'package:chat/utils/env.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart';
import '../storage/shared_preference.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  late String _username = '';
  late String _password = '';

  ///
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
    try {
      var dio = Dio();
      FormData formData = FormData.fromMap({
        "avatar":
            await MultipartFile.fromFile(image.path, filename: "image.jpg"),
      });
      var headers = {
        'Authorization':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiJxMjYzMDc0YmUzNTkwMDM3IiwiZXhwIjoxNzIyNjU3NTk0LCJpc3MiOiJjaGF0In0.ptsblJOu_XqzoikFjcmeViGPC4ALNiIc2V1WinAq2Zk',
      };
      var response = await dio.post(Env().getApiHost("API_HOST"),
          data: formData, options: Options(headers: headers));
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  ///

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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

  // 注册
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
      SharedPrefer.saveUser(user);
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

// https://developer.aliyun.com/article/1340683
//   https://blog.csdn.net/shaoxiukun/article/details/131437843
}
