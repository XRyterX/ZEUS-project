import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:spons/formpage/flutter_form_log_sign.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:spons/iklanbanner.dart';

import 'package:spons/l10n/my_localization_delegate.dart';
import 'package:spons/menu.dart';
import 'package:spons/api/firebase_api.dart';
import 'package:spons/provider/watchlist_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => WatchlistProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  MyLocalizationDelegate _myLocalizationDelegate =
      MyLocalizationDelegate(Locale('null', 'null'));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        _myLocalizationDelegate
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('id', 'ID'),
      ],
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: Column(
        children: [
          Expanded(
            child: StreamBuilder<User?>(
              stream: _auth.authStateChanges(),
              builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data != null) {
                    return MyWidget();
                  } else {
                    return LoginForm();
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          IklanBanner(),
        ],
      ),
    );
  }
}

