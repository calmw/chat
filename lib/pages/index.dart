import 'package:chat/storage/shared_preference.dart';
import 'package:chat/utils/env.dart';
import 'package:chat/utils/socket/socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../db/chat_list.dart';
import '../db/msg.dart';
import '../utils/event_bus.dart';
import '../utils/http.dart';
import 'call.dart';
import 'chats.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return IndexState();
  }
}

class IndexState extends State<Index> with TickerProviderStateMixin {
  late TabController? _tabController;
  final List<Tab> _myTabs = <Tab>[
    const Tab(text: "CHATS"),
    const Tab(
      text: "CALLS",
    ),
  ];
  final List<Widget> tabBarViewChildren = <Widget>[
    Chats(),
    Call(),
  ];
  late String _username = "";
  late String _email = "";
  late String _avatar =
      Env().get("STATIC_HOST") + 'images/avatar/default_user_logo.png';
  late String _uid = "";

  @override
  void initState() {
    super.initState();
    // 登陆检测
    checkLogin();

    ///初始化构造
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);

    ///添加监听
    _tabController?.addListener(() {
      if (_tabController!.indexIsChanging) {
        _handleTabChange();
      }
    });
    createMsgTable();
    createChatListTable();
    getUserInfo();
    freshChats();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> getUserInfo() async {
    var res = await HttpUtils.get("api/v1/user_info");
    if (res["code"] == 0) {
      setState(() {
        _username = res["data"]["username"];
        _email = res["data"]["email"];
        _avatar = Env().get("STATIC_HOST") + res["data"]["avatar"];
        _uid = res["data"]["user_id"];
      });
    }
  }

  freshChats(){
    EventBusManager.eventBus.fire(NewMsgEvent("message", 1));
    print(9998877);
  }

  // 登陆检测
  Future<void> checkLogin() async {
    var user = await SharedPrefer.getUser();
    if (user == null) {
      Navigator.pushNamed(context, '/login');
    }
  }


  void _handleTabChange() {
    if (_tabController?.index == 0) {
      print('请求数据1');
    } else if (_tabController?.index == 1) {
      print('请求数据2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // 设置返回箭头颜色为白色
        ),
        backgroundColor: const Color.fromRGBO(55, 120, 167, 1),
        flexibleSpace: TabBar(
          controller: _tabController,
          tabs: _myTabs,
          //标题，使用 Tab 构造
          isScrollable: false,
          //是否可以滑动，标题左右滑动
          padding: const EdgeInsets.only(top: 60, left: 100, right: 100),
          indicatorWeight: 5,
          //指示器高度
          indicator: UnderlineTabIndicator(
              borderSide: const BorderSide(width: 2, color: Colors.white),
              insets: EdgeInsets.only(left: 60.w, right: 60.w)),
          labelColor: Colors.white,
          //标题选择时颜色
          unselectedLabelColor: const Color.fromRGBO(201, 221, 244, 1),
          //未被选择时颜色
          labelStyle: const TextStyle(fontSize: 18), //被选择时label风格样式
        ),
        // leading: ,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => {},
          ),
        ],
        automaticallyImplyLeading: true,
      ),
      drawer: Drawer(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                _username,
                style: const TextStyle(fontSize: 20),
              ),
              accountEmail: Text(_email),
              decoration: const BoxDecoration(
                //头部颜色或者图片
                color: Color.fromRGBO(55, 120, 167, 1),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(_avatar),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings, size: 36.0),
              title: const Text('设置'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person, size: 36.0),
              title: const Text('个人信息'),
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.wallet, size: 36.0),
              title: const Text('链上钱包'),
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded, size: 35.0),
              title: const Text('退出登录'),
              onTap: () async {
                await SharedPrefer.logOut();
                Navigator.pushNamed(context, '/login');
              },
            ),
            // Add more ListTiles here if needed
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabBarViewChildren
            .map((Widget tab) => Container(
                  key: PageStorageKey<String>(
                      tabBarViewChildren.indexOf(tab).toString()),
                  child: tab,
                ))
            .toList(),
      ),
    );
  }
}
