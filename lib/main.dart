import 'package:chat/pages/index.dart';
import 'package:chat/pages/login.dart';
import 'package:chat/pages/register.dart';
import 'package:chat/pages/ws.dart';
import 'package:chat/storage/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  await dotenv.load(); // 加载.env文件
  // ScreenUtil.init( BuildContext as BuildContext, designSize: const Size(750, 1334));
  runApp(MyApp());
  // runApp(
  //   ScreenUtilInit(
  //     designSize: const Size(750, 1334),
  //     minTextAdapt: true,
  //     builder: () => MyApp(),
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_ , child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          routes: {
            "/": (context) => const Index(),
            "/login": (context) => const Login(),
            "/register": (context) => const Register(),
            "/ws": (context) => const WebSocketRoute(),
          },
        );
      },
    );;

    // return MaterialApp(
    //   title: 'Chat',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     useMaterial3: false,
    //   ),
    //   // home: _loadHomePage(),
    //   routes: {
    //     "/": (context) => Index(),
    //     "/login": (context) => Login(),
    //     "/register": (context) => Register(),
    //     "/ws": (context) => WebSocketRoute(),
    //   },
    // );
  }

  Future<Widget> _loadHomePage() async {
    // 假设有一个名为isLoggedIn的标志来检查用户是否登录
    bool isLogin = await SharedPrefer.getJwtToken() != "" ? true : false;

    // 如果用户已登录，则加载主页，否则加载登录页面
    return isLogin ? const Login() : const Index();
  }
}
