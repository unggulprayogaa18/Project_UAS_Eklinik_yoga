import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/doctor/home_doctor.dart';

class HomePageDokter extends StatelessWidget {
  HomePageDokter() {
    initializeDateFormatting('id_ID', null); // Corrected locale identifier
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: DoctorHomeWidget().buildDoctor(context));
  }
}
