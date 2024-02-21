import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:get/get.dart';

class LoadAnimation extends StatefulWidget {
  @override
  _LoadAnimationState createState() => _LoadAnimationState();
}

class _LoadAnimationState extends State<LoadAnimation> {
  @override
  void initState() {
    super.initState();
    // Panggil metode untuk kembali setelah 2 detik
    Future.delayed(Duration(seconds: 1), () {
      Get.back();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.prograssiveDots(
          color: Color.fromARGB(255, 59, 127, 184),
          size: 200,
        ),
      ),
    );
  }
}
