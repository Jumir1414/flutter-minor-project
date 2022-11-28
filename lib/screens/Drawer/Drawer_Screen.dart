import 'dart:ui';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:flutter/material.dart';
import 'package:minorproject/screens/About/About.dart';
import 'package:minorproject/screens/Buy/Buy.dart';
import 'package:minorproject/screens/Component/Registerclasses.dart';
import 'package:minorproject/screens/Profile/Profile.dart';
import 'package:minorproject/screens/Sell/Sell.dart';
import 'package:minorproject/screens/Setting/Setting.dart';
import 'package:minorproject/screens/root/root.dart';
import 'package:minorproject/states/currentUser.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  KFDrawerController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = KFDrawerController(
      initialPage: ClassBuilder.fromString('HomeScreen'),
      items: [
        KFDrawerItem.initWithPage(
          text: Text('List Of Books For Sales',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          icon: Icon(Icons.book, color: Colors.white),
          page: BuyScreen(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('Add Books For Sales',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          icon: Icon(Icons.add_box_outlined, color: Colors.white),
          page: SellScreen(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('Profile',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          icon: Icon(Icons.person, color: Colors.white),
          page: ProfileScreen(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('Setting',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          icon: Icon(Icons.settings, color: Colors.white),
          page: SettingScreen(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('About',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          icon: Icon(Icons.info, color: Colors.white),
          page: AboutScreen(),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: KFDrawer(
        controller: _drawerController,
        header: Padding(
          padding: const EdgeInsets.only(right: 120),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Padding(
                padding: EdgeInsets.only(right: 50.0),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                          ExactAssetImage('assets/google-logo.png'),
                    ),
                    Text(
                      "Jumir Gosain",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        footer: KFDrawerItem(
          text: Text(
            'Logout',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 18,
            ),
          ),
          icon: Icon(Icons.logout, color: Colors.white54),
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Do you want to exit?"),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("No"),
                  ),
                  FlatButton(
                    onPressed: () async {
                      CurrentUser _currentUser =
                          Provider.of<CurrentUser>(context, listen: false);
                      String _returnString = await _currentUser.signOut();
                      if (_returnString == "success") {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => OurRoot()),
                            (route) => false);
                      }
                    },
                    child: Text("Yes"),
                  )
                ],
              ),
            );
          },
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
        ),
      ),
    );
  }
}
