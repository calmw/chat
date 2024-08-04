import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/contract_list.dart';
import '../storage/shared_preference.dart';
import '../utils/datatime.dart';
import '../utils/env.dart';

class Contact extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ContactState();
  }
}

class ContactState extends State<Contact> {
  final ScrollController _controller = ScrollController();
  late List<ContractList> _contractList = [];
  late String _uid = "";

  @override
  void initState() {
    super.initState();
    getMyUid();
    setContractList();
  }

  @override
  void dispose() {
    _controller.dispose();
    // 取消监听
    super.dispose();
  }

  getMyUid() async {
    var user = await SharedPrefer.getUser();
    _uid = user!.uid;
  }

  setContractList() async {
    var _cl = await list();
    setState(() {
      _contractList = _cl;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // 设置返回箭头颜色为白色
          size: 48.sp,
        ),
        backgroundColor: const Color.fromRGBO(55, 120, 167, 1),
        // leading: ,
        title: Text(
          "通讯录",
          style: TextStyle(color: Colors.white, fontSize: 34.sp),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white, size: 50.sp),
            onPressed: () => {},
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white, size: 50.sp),
            onPressed: () => {},
          ),
        ],
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Container(
            height: 50.h,
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.black12),
            padding: EdgeInsets.only(left: 20.w, top: 5.h),
            child: Text(
              "${_contractList.length}人",
              style: TextStyle(fontSize: 32.sp, color: Colors.black45),
            ),
          ),
          Expanded(child: buildList())

        ],
      ),
      // body: buildList(),
    );
  }

  //
  buildList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return createItem(index);
      },
      itemExtent: 100,
      itemCount: _contractList.length,
      controller: _controller,
      key: const PageStorageKey(1),
    );
  }

  Widget createItem(int index) {
    return RawMaterialButton(
        onPressed: () => {
              Navigator.pushNamed(context, '/chat_details', arguments: {
                "uid": _uid,
                "sender": _contractList[index].fid,
                "senderUsername": _contractList[index].friendUsername,
                "senderAvatar": _contractList[index].friendAvatar,
                "receiver": _contractList[index].fid,
                "groupType": 1
              })
            },
        child: Row(
          children: [
            SizedBox(
              width: 140.w, // 左侧宽度
              height: 140.h,
              child: Container(
                width: 120.w,
                height: 120.h,
                margin: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
                child: CircleAvatar(
                  radius: 120.w,
                  backgroundImage: NetworkImage(Env().get("STATIC_HOST") +
                      _contractList[index].friendAvatar),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                  height: 140.h,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 25.h, 10.w, 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${_contractList[index].friendUsername}",
                              style: TextStyle(
                                  fontSize: 34.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 15.w),
                        child: Row(
                          children: [
                            Text(
                              "last seen ${messageTime(_contractList[index].friendLatestOnlineTime ?? 0)}",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 28.sp,
                                  height: 2.h),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Divider(
                        height: 1.h, // 划线的高度
                        color: Colors.black12, // 划线的颜色
                        // 其他属性...
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
