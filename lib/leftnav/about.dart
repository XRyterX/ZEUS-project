import 'package:flutter/material.dart';

class AboutTeamZEUS extends StatefulWidget {
  const AboutTeamZEUS({super.key});

  @override
  State<AboutTeamZEUS> createState() => _AboutTeamZEUSState();
}

class _AboutTeamZEUSState extends State<AboutTeamZEUS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team ZEUS'),
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              title: Text('Yusra Budiman Hasibuan'),
              subtitle: Text('211110993'),
            ),
            ListTile(
              title: Text('Prana Yudisthira Tarigan'),
              subtitle: Text('211111348'),
            ),
            ListTile(
              title: Text('Christ Bryan Cwalta Tarigan'),
              subtitle: Text('211111955'),
            ),
            ListTile(
              title: Text('Muhammad Daviansyah Safii'),
              subtitle: Text('211111838'),
            ),
          ],
        ),
      ),
    );
  }
}
