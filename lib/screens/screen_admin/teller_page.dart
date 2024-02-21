// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:ui';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_admin/jadwal_checkup.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/reset_pasientouser.dart';

class TellerPage extends StatefulWidget {
  const TellerPage({Key? key}) : super(key: key);
  @override
  State<TellerPage> createState() => _TellerPageState();
}

class _TellerPageState extends State<TellerPage> {
  late AudioPlayer player;
  bool isButtonEnabled = true;
  final _audioCache = AudioPlayer();
  int posisiteler = 1;
  int queueNumber = 1; // Initialize queueNumber variable

  Future<void> playAwal() async {
    await _audioCache.play(AssetSource('tingtung.wav'));
    await _audioCache.onSeekComplete.first;
    await _audioCache.play(AssetSource('rekaman/nomor-urut.wav'));
  }

  Future<void> playQueueNumber(int number) async {
    if (number == 10) {
      await _audioCache.play(AssetSource('rekaman/sepuluh.wav'));
    } else if (number == 11) {
      await _audioCache.play(AssetSource('rekaman/sebelas.wav'));
    } else if (number == 100) {
      await _audioCache.play(AssetSource('rekaman/seratus.wav'));
    } else if (number < 10) {
      await _audioCache.play(AssetSource('rekaman/$number.wav'));
    } else if (number < 20) {
      int posisi = number % 10;
      await _audioCache.play(AssetSource('rekaman/$posisi.wav'));
      await _audioCache.onSeekComplete.first;
      await _audioCache.play(AssetSource('rekaman/belas.wav'));
    } else if (number < 100) {
      int posisidepan = number ~/ 10;
      int posisibelakang = number % 10;
      await _audioCache.play(AssetSource('rekaman/$posisidepan.wav'));
      await _audioCache.onSeekComplete.first; // Menunggu pemutaran selesai
      await _audioCache.play(AssetSource('rekaman/puluh.wav'));
      await _audioCache.onSeekComplete.first;
      if (posisibelakang != 0) {
        await _audioCache.play(AssetSource('rekaman/$posisibelakang.wav'));
      }
    } else if (number == 100) {
      await _audioCache.play(AssetSource('rekaman/seratus.wav'));
    } else if (number < 200) {
      await _audioCache.play(AssetSource('rekaman/seratus.wav'));
      await _audioCache.onPlayerComplete.first;
      int numberratus = number - 100;
      if (numberratus != 0) {
        playQueueNumber(numberratus);
      }
    } else if (number < 999) {
      int numberdepan = number ~/ 100;
      int numberbelakang = number % 100;
      await playQueueNumber(numberdepan);
      await _audioCache.onPlayerComplete.first;
      await _audioCache.play(AssetSource('rekaman/ratus.wav'));
      if (numberbelakang != 0) {
        await _audioCache.onPlayerComplete.first;
        await playQueueNumber(numberbelakang);
      }

      //await _audioCache.play(AssetSource('rekaman/$numberdepan.wav'));
    }
  }

  Future<void> playFrontSound() async {
    await _audioCache.play(AssetSource('tingtung.wav'));
    await _audioCache.onPlayerComplete.first;
    await _audioCache.play(AssetSource('rekaman/nomor-urut.wav'));
  }

  Future<void> playEndSound() async {
    await _audioCache.play(AssetSource('rekaman/loket.wav'));
    await _audioCache.onPlayerComplete.first;
    playQueueNumber(posisiteler);
  }

  void disableButton() {
    setState(() {
      isButtonEnabled = false;
    });
  }

  void enableButton() {
    setState(() {
      isButtonEnabled = true;
    });
  }

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Row(
                children: [
                  Text(
                    '\u2039',
                    style: TextStyle(
                      fontSize: 30,
                      color: Color.fromARGB(255, 78, 127, 167),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => JadwalCheckupPage()),
                );
              },
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 30.0,
                  ),
                  child: Text(
                    'Panggil Antrian',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 78, 127, 167),
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Pilih Locket'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    MinPosisiTeler();
                  },
                ),
                Text(
                  '$posisiteler',
                  style: TextStyle(
                      fontSize: 60,
                      color: Color.fromARGB(255, 10, 92, 168),
                      fontWeight: FontWeight.w700),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    AddPosisiTeler();
                  },
                ),
              ],
            ),
            Text(
              'Posisi Nomor Antrian Saat Ini :',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.center,
              width: 250,
              height: 200,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 26, 116, 168),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(
                '$queueNumber',
                style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isButtonEnabled && queueNumber > 1
                      ? () async {
                          queueNumber--;
                          print('data : $queueNumber');
                          MinPosisiAntri();
                          disableButton();
                          setState(() {});
                          await playFrontSound();
                          await _audioCache.onPlayerComplete.first;
                          await playQueueNumber(queueNumber);
                          await _audioCache.onPlayerComplete.first;
                          await playEndSound();
                          enableButton();
                          setState(() {});
                        }
                      : null,
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(100, 80)),
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.red)),
                  child: const Text(
                    'PREV',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                    softWrap: true,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () async {
                          print('data : $queueNumber');
                          // Mengakses ResetController
                          // ResetController resetController =
                          //     Get.find<ResetController>();

                          // // Memanggil metode updateEklinikData() dari ResetController
                          // resetController.updateEklinikData(queueNumber);

                          disableButton();
                          setState(() {});
                          await playFrontSound();
                          await _audioCache.onPlayerComplete.first;
                          await playQueueNumber(queueNumber);
                          await _audioCache.onPlayerComplete.first;
                          await playEndSound();
                          enableButton();
                          setState(() {});
                        }
                      : null,
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(100, 80)),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.blue[600])),
                  child: const Text(
                    'CURRENT',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: isButtonEnabled
                      // Add validation here
                      ? () async {
                          queueNumber++;
                          print('data : $queueNumber');

                          disableButton();
                          setState(() {});
                          await playFrontSound();
                          await _audioCache.onPlayerComplete.first;
                          await playQueueNumber(queueNumber);
                          await _audioCache.onPlayerComplete.first;
                          await playEndSound();
                          enableButton();
                          setState(() {});
                        }
                      : () {
                          // Tampilkan dialog notifikasi jika nomor antrian melebihi total antrian
                          Get.defaultDialog(
                            title: 'Peringatan',
                            content: Text(
                                'Nomor antrian melebihi total antrian yang tersedia.'),
                            confirm: TextButton(
                              onPressed: () {
                                // Tutup dialog saat tombol ditekan
                                Get.back();
                              },
                              child: Text('OK'),
                            ),
                          );
                        },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(100, 80)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.orange[800]),
                  ),
                  child: const Text(
                    'NEXT',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                    softWrap: true,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void AddPosisiTeler() {
    setState(() {
      posisiteler++;
    });
  }

  void MinPosisiAntri() {
    setState(() {
      if (queueNumber <= 1) {
        queueNumber = 1;
      } else {
        queueNumber--;
      }
    });
  }

  void MinPosisiTeler() {
    setState(() {
      if (posisiteler <= 1) {
        posisiteler = 1;
      } else {
        posisiteler--;
      }
    });
  }
}
