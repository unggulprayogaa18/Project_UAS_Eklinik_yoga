import 'package:flutter/material.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/komponen_bar/menubar.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/pasien/profile.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';

class ProfileUserPasien extends StatefulWidget {
  @override
  _ProfileUserPasienState createState() => _ProfileUserPasienState();
}

class _ProfileUserPasienState extends State<ProfileUserPasien> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WidgetsUser().buildProfile(context),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
