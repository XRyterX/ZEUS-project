import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spons/formpage/flutter_form_log_sign.dart';
import 'package:spons/l10n/my_localization.dart';

import 'package:spons/leftnav.dart';
import 'package:spons/navigation/home.dart';
import 'package:spons/navigation/search.dart';
import 'package:spons/navigation/watchlist.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String? email;
  String title = "welcome";
  int _indexNavigation = 0;

  @override
  void initState() {
    super.initState();

    email = FirebaseAuth.instance.currentUser?.email;
    title = "${email ?? 'No User'}";
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LoginForm(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget _widgetNavigation() {
      if (_indexNavigation == 0) {
        return HomeList();
      } else if (_indexNavigation == 1) {
        return appSearch();
      } else {
        return Watchlist();
      }
    }

    return Scaffold(
      drawer: leftNavbarAksi(),
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _signOut();
            },
            icon: const Icon(
              Icons.logout_sharp,
            ),
            tooltip: 'Logout',
          )
        ],
      ),
      body: _widgetNavigation(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexNavigation,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Watchlist')
        ],
        onTap: (value) {
          if (value == 0) {
            title = "${email ?? 'No User'}"; //welcome: $email
          }
          if (value == 1) {
            title = MyLocalization.of(context)!.search;
          }
          if (value == 2) {
            title = MyLocalization.of(context)!.watchlist;
          }
          setState(() {
            _indexNavigation = value;
          });
        },
      ),
    );
  }
}
