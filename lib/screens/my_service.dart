import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ungfriend19oct/screens/home.dart';
import 'package:ungfriend19oct/screens/my_style.dart';
import 'package:ungfriend19oct/screens/page1.dart';
import 'package:ungfriend19oct/screens/page2.dart';
import 'package:ungfriend19oct/screens/page3.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  // Explicit
  String loginString = '';
  Widget currentWidget = Page1();

  // Method
  @override
  void initState() {
    super.initState();
    findDisplayName();
  }

  Widget menuPage1() {
    return ListTile(
      leading: Icon(
        Icons.filter_1,
        size: 36.0,
        color: Colors.purple,
      ),
      title: Text('Page 1'),
      subtitle: Text('Replace Page 1 to Screen'),
      onTap: () {
        setState(() {
          currentWidget = Page1();
          Navigator.of(context).pop();
        });
      },
    );
  }

  Widget menuPage2() {
    return ListTile(
      leading: Icon(
        Icons.filter_2,
        size: 36.0,
        color: Colors.blue,
      ),
      title: Text('Page 2'),
      subtitle: Text('Replace Page 2 to Screen'),
      onTap: () {
        setState(() {
          currentWidget = Page2();
          Navigator.of(context).pop();
        });
      },
    );
  }

  Widget menuPage3() {
    return ListTile(
      leading: Icon(
        Icons.filter_3,
        size: 36.0,
        color: Colors.green,
      ),
      title: Text('Page 3'),
      subtitle: Text('Replace Page 3 to Screen'),
      onTap: () {
        setState(() {
          currentWidget = Page3();
          Navigator.of(context).pop();
        });
      },
    );
  }

  Widget menuSignOut() {
    return ListTile(
      leading: Icon(
        Icons.exit_to_app,
        size: 36.0,
        color: Colors.red,
      ),
      title: Text('Sign Out'),
      subtitle: Text('Sign Out and Go to Home Page'),
      onTap: () {
        processSignOut();
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> processSignOut() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut().then((response){
      MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (BuildContext context)=>Home());
      Navigator.of(context).pushAndRemoveUntil(materialPageRoute, (Route<dynamic> route)=>false);
    });
  }

  Future<void> findDisplayName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    setState(() {
      loginString = firebaseUser.displayName;
    });
    print('loginString = $loginString');
  }

  Widget showLogin() {
    return Text('Login by $loginString');
  }

  Widget showAppName() {
    return Text(
      'Ung Friend',
      style: TextStyle(
        fontSize: MyStyle().h2,
        color: MyStyle().textColor,
      ),
    );
  }

  Widget showLogo() {
    return Container(
      height: 80.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget myHeadDrawer() {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          showLogo(),
          showAppName(),
          showLogin(),
        ],
      ),
    );
  }

  Widget myDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          myHeadDrawer(),
          menuPage1(),
          Divider(),
          menuPage2(),
          Divider(),
          menuPage3(),
          Divider(),
          menuSignOut(),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Service'),
      ),
      body: currentWidget,
      drawer: myDrawer(),
    );
  }
}
