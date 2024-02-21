import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/admin/home_admin.dart';

class HomePageAdmin extends StatelessWidget {
  HomePageAdmin() {
    initializeDateFormatting('id_ID', null); // Corrected locale identifier
  }

  @override
  Widget build(BuildContext context) {
    // resetbedasarkanjam();

    return Scaffold(body: AdminhomeWidget().buildAdmin(context));
  }

  String getGreeting() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 0 && hour < 10) {
      return 'Selamat Pagi!!';
    } else if (hour >= 10 && hour < 15) {
      return 'Selamat Siang!!';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore!!';
    } else {
      return 'Selamat Malam!!';
    }
  }

  String reservasitime() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 0 && hour < 10) {
      return 'Pagi';
    } else if (hour >= 10 && hour < 15) {
      return 'Siang';
    } else if (hour >= 15 && hour < 18) {
      return 'Sore';
    } else {
      return 'Malam';
    }
  }

  String getFormattedDate() {
    DateTime now = DateTime.now();
    String formattedNow = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);
    return '$formattedNow';
  }

// Inside buildArticleContainer
}
