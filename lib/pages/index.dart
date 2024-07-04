import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return IndexState();
  }
}

class IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("首页"),
        // leading: ,
        bottom: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.directions_car)),
            Tab(icon: Icon(Icons.directions_transit)),
            Tab(icon: Icon(Icons.directions_bike)),
          ],
        ),
        actions: [
          // TextButton(onPressed: ()=>{}, child: Text("CHATS",style: TextStyle(fontSize: 18),)),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('John Doe'),
              accountEmail: Text('johndoe@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    NetworkImage('https://example.com/profile.jpg'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, size: 36.0),
              title: Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings, size: 36.0),
              title: Text('Settings'),
              onTap: () {},
            ),
            // Add more ListTiles here if needed
          ],
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          Container(
            child: Text("hello"),
          ),
          ListView(
            children: <Widget>[
              ListTile(
                title: Text("第二个tab"),
              )
            ],
          ),
          ListView(
            children: <Widget>[
              ListTile(
                title: Text("第三个tab"),
              )
            ],
          ),
          ListView(
            children: <Widget>[
              ListTile(
                title: Text("第四个tab"),
              )
            ],
          ),
        ],
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       ElevatedButton(
      //         onPressed: () {
      //           Navigator.pushNamed(context, '/login');
      //         },
      //         child: const Text('Login'),
      //       ),
      //       ElevatedButton(
      //         onPressed: () {
      //           Navigator.pushNamed(context, '/register');
      //         },
      //         child: const Text('Register'),
      //       ),
      //       ElevatedButton(
      //         onPressed: () {
      //           Navigator.pushNamed(context, '/ws');
      //         },
      //         child: const Text('ws'),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
