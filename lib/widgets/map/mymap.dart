import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Map Button Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: _openGoogleMaps,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.black),
              ),
              primary: Colors.blue,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                'Dapatkan arah',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membuka Google Maps di peramban pengguna
  void _openGoogleMaps() async {
    const url = 'https://www.google.com/maps?q=loc:-8.076175,111.902526'; // URL Google Maps yang diinginkan
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
