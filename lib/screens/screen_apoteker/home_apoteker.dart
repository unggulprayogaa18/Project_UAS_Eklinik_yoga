import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/apoteker/home_apoteker.dart';

class HomeApoteker extends StatelessWidget {
  HomeApoteker() {
    initializeDateFormatting('id_ID', null); // Corrected locale identifier
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HomeApotekerWidget().buildDoctor(context));
  }
}
