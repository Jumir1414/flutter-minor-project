import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:minorproject/screens/Drawer/Drawer_Screen.dart';

class ProfileScreen extends KFDrawerContent {
  ProfileScreen({
    Key key,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: _height.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30.0),
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/google-logo.png'),
                  radius: 40.0,
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                'NAME',
                style: TextStyle(
                    color: Colors.indigo[900],
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                'Jumir Gosain',
                style: TextStyle(
                    color: Colors.amber,
                    letterSpacing: 1.0,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.email,
                    color: Colors.blue,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'jumirgosain@email.com',
                    style: TextStyle(
                        color: Colors.blue,
                        letterSpacing: 1.0,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onWillPop: onBackPressed,
    );
  }

  Future<bool> onBackPressed() {
    return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return DrawerScreen();
      },
    ), (route) => false);
  }
}
