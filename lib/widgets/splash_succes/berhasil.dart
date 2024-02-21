import 'package:flutter/material.dart';

class SplashBerhasil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/icon/berhasil.png'),
                  // Sesuaikan dengan path sebenarnya untuk gambar berhasil.png
                  height: 100, // Sesuaikan tinggi gambar sesuai kebutuhan
                ),
                SizedBox(height: 16), // Beri jarak antara gambar dan teks
                Text(
                  'Pendaftaran berhasil',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
