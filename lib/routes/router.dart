import "package:flutter/material.dart";

import "../pages/chat_details.dart";
import "../pages/index.dart";
import "../pages/login.dart";
import "../pages/register.dart";

// 命名路由传参
Map routes = {
  "/": (context) => const Index(),
  "/login": (context) => const Login(),
  "/register": (context) => const Register(),
  "/chat_details": (context,{arguments}) =>  ChatDetails(arguments:arguments)
};

// 定义一个函数，并返回MaterialPageRoute
var onGenerateRoute = (RouteSettings settings) {
  var pageBuilder = routes[settings.name];
  if (pageBuilder != null) {
    if (settings.arguments != null) {
      // 创建路由页面并携带参数
      return MaterialPageRoute(
          builder: (context) =>
              pageBuilder(context, arguments: settings.arguments));
    } else {
      return MaterialPageRoute(builder: (context) => pageBuilder(context));
    }
  }
  return MaterialPageRoute(builder: (context) => const Index());
};
