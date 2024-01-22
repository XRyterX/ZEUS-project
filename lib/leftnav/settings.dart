import 'package:flutter/material.dart';
import 'package:spons/l10n/my_localization.dart';
import 'package:spons/settings/languange.dart';

class Pengaturan extends StatefulWidget {
  const Pengaturan({super.key});

  @override
  State<Pengaturan> createState() => SPengaturanState();
}

class SPengaturanState extends State<Pengaturan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyLocalization.of(context)!.settings),
      ),
      body: ListTile(
        title: Text(MyLocalization.of(context)!.languangeWords),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Languanges()));
        },
      ),
    );
  }
}
