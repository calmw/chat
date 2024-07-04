import 'package:chat/storage/shared_preference.dart';
import 'package:chat/utils/env.dart';
import 'package:flutter/material.dart';

class Index extends StatefulWidget {
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
   late String _username;
  late String _email;
  late String _uid;

  @override
  void initState() {
    ///初始化构造
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);

    ///添加监听
    ///_tabController(() => _handleTabChange());
    _tabController?.addListener(() {
      if (_tabController!.indexIsChanging) {
        _handleTabChange();
      }
    });
    super.initState();

    Future.delayed(Duration.zero, () => setState(() async {
      var user = await SharedPrefer.getUser();
      _username = user!.nickname;
      _email = user.email;
      _uid = user.uid;
    }));
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
          indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(width: 2, color: Colors.white),
              insets: EdgeInsets.only(left: 105, right: 105)),
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
            ),
            onPressed: () => {},
          ),
        ],
        automaticallyImplyLeading: true,
      ),
      drawer: Drawer(
        surfaceTintColor: Colors.amber,
        shadowColor: Colors.amber,
        child: ListView(
          children: <Widget>[
             UserAccountsDrawerHeader(
              accountName: Text("$_username"),
              accountEmail: Text('$_email'),
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    NetworkImage(Env().key("STATIC_HOST")+'images/avatar/$_uid.png'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, size: 36.0),
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings, size: 36.0),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined, size: 35.0),
              title: const Text('Logout'),
              onTap: () {},
            ),
            // Add more ListTiles here if needed
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 24),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: const Text(
              'Register',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}
