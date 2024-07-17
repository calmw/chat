import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chat/utils/check_login.dart';
import 'package:chat/utils/email_check.dart';
import 'package:chat/utils/env.dart';
import 'package:chat/utils/http.dart';
import 'package:chat/utils/toast.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final FocusScopeNode focusScopeNode = FocusScopeNode();

  Future<bool> sendCode() async {
    if (!Email.checkFormat(_email)) {
      ToastS.showShort("email 不能为空或email格式错误");
      return false;
    }
    // 发送验证码
    var res = await HttpUtils.post("api/v1/send_register_email_code",
        data: {"email": _email});
    if (res["code"] != 0) {
      ToastS.showShort(res["message"]);
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
    // 设置代理，以便能够发送HTTP请求
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
      // 对于非HTTPS请求，通常不需要SSL校验
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
    FormData formData = FormData.fromMap({
      "avatar": await MultipartFile.fromFile(image.path, filename: "image.jpg"),
    });
    var response = await dio.post(
      Env().get("API_HOST") + "api/v1/upload_image_one",
      data: formData,
    );
    var res = jsonDecode(response.toString());
    CheckLogin().check(res["code"], context);
    if (res["code"] == 0) {
      _avatar = res["data"]["uri"];
    } else {
      ToastS.showShort(res["message"]);
    }
  }

  @override
  void dispose() {
    if (_secondsRemaining < 60) {
      _timer.cancel();
    }
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
          "注册",
          style: TextStyle(color: Colors.white,fontSize: 34.sp),
        ),
        centerTitle: true,
      ),
      body:GestureDetector(
        onTap: () {
          // 点击空白区域时，关闭软键盘并取消焦点
          FocusScope.of(context).requestFocus(FocusNode());
          SystemChannels.textInput.invokeMethod('hide');
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child:FocusScope(
            node: focusScopeNode,
            child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              child:   Padding(
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
                            radius: 90.w,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : null, // 根据_image是否为空设置头像图片
                            child: _image == null
                                ?  Icon(
                              Icons.camera_alt,
                              size: 90.w,
                              color: Colors.white,
                            )
                                : null,
                          ),
                        ),
                        ////
                         SizedBox(height: 35.h),
                        TextFormField(
                          style: TextStyle(color: Colors.black54, fontSize: 34.sp),
                          autofocus: false,
                          decoration: InputDecoration(
                              icon:  Icon(Icons.person,size: 56.sp,),
                              // filled: true,
                              // fillColor: const Color.fromRGBO(253, 247, 254, 1),
                              labelText: '用户名',
                              labelStyle: TextStyle(
                                fontSize: 34.sp,
                              ),
                              hintText: "请输入用户名",
                              hintStyle:
                              TextStyle(fontSize: 34.sp,)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入用户名';
                            }
                            return null;
                          },
                          onChanged: (value) => _nickname = value,
                          onSaved: (value) => _nickname = value!,
                        ),
                         SizedBox(height: 20.h),
                        TextFormField(
                          style: TextStyle(color: Colors.black54, fontSize: 34.sp),
                          autofocus: false,
                          decoration:  InputDecoration(
                              icon:  Icon(Icons.email,size: 56.sp,),
                              labelText: '邮箱',
                              labelStyle:  TextStyle(
                                fontSize: 34.sp,
                              ),
                              hintText: "请输入邮箱",
                              hintStyle:  TextStyle(fontSize: 34.sp)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入邮箱';
                            }
                            return null;
                          },
                          onChanged: (value) => _email = value,
                          onSaved: (value) => _email = value!,
                        ),
                         SizedBox(height: 20.h),
                        Stack(
                          children: [
                            TextFormField(
                              style: TextStyle(color: Colors.black54, fontSize: 34.sp),
                              autofocus: false,
                              decoration:  InputDecoration(
                                  icon: Icon(Icons.confirmation_num,size: 56.sp,),
                                  labelText: '验证码',
                                  labelStyle: TextStyle(
                                    fontSize: 34.sp,
                                  ),
                                  hintText: "验证码",
                                  hintStyle:  TextStyle(fontSize: 34.sp)),
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
                                  child: Text(
                                    "发送验证码",
                                    style: TextStyle(
                                        fontSize: 26.sp,
                                        color: const Color.fromRGBO(55, 120, 167, 1)),
                                  ),
                                )
                                    : TextButton(
                                  onPressed: null,
                                  child: Text("$_secondsRemaining秒",style: TextStyle(fontSize: 26.sp),),
                                ))
                          ],
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          style: TextStyle(color: Colors.black54, fontSize: 34.sp),
                          autofocus: false,
                          obscureText: true,
                          decoration:  InputDecoration(
                              icon: Icon(Icons.key,size: 56.sp,),
                              labelText: '密码',
                              labelStyle:  TextStyle(
                                fontSize: 34.sp,
                              ),
                              hintText: "请输入密码",
                              hintStyle:  TextStyle(fontSize: 34.sp)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入密码';
                            }
                            return null;
                          },
                          onChanged: (value) => _password = value,
                          onSaved: (value) => _password = value!,
                        ),
                        SizedBox(height: 40.h),
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
                          child:  Text(
                            "注册",
                            style: TextStyle(fontSize: 40.sp, color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 40.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () => {
                                  Navigator.pushNamed(context, '/login'),
                                },
                                child: Text("去登陆",style: TextStyle(fontSize: 26.sp),)),
                            TextButton(onPressed: () => {}, child: Text("忘记密码？",style: TextStyle(fontSize: 26.sp))),
                          ],
                        ),
                      ],
                    )),
              ), // 这里放置你的输入组件
            ),
          ),
        ),


      )
    );
  }

  // 注册
  void _register() async {
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
      await SharedPrefer.saveUser(user);
      Navigator.pushNamed(context, '/');
    } else {
      ToastS.showShort(res["message"]);
    }
  }
}
