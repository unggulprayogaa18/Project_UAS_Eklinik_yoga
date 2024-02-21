import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  void handleNavigation(int index, BuildContext context) async {
    switch (index) {
      case 0:
        await Get.toNamed('/load');
        Get.offNamed('/homepasien');
        break;
      case 1:
        await Get.toNamed('/load');
        Get.offNamed('/kartu');

        break;
      case 2:
        Get.offNamed('/profile');
        break;
      // Add more cases for additional pages if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          onItemTapped(index);
          handleNavigation(index, context);
        },
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: selectedIndex == 0
                    ? Color.fromARGB(255, 45, 108, 138)
                    : Color.fromARGB(106, 33, 149, 243),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.home, color: Colors.white),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: selectedIndex == 1
                    ? Color.fromARGB(255, 45, 108, 138)
                    : Color.fromARGB(106, 33, 149, 243),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.credit_card, color: Colors.white),
            ),
            label: 'Kartu',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: selectedIndex == 2
                    ? Color.fromARGB(255, 45, 108, 138)
                    : Color.fromARGB(106, 33, 149, 243),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.person, color: Colors.white),
            ),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Color.fromARGB(255, 45, 108, 138),
        unselectedItemColor: Color.fromARGB(255, 45, 108, 138),
        selectedLabelStyle: TextStyle(
          color: Color.fromARGB(255, 45, 108, 138),
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
          fontSize: 10,
        ),
        unselectedLabelStyle: TextStyle(
          color: Color.fromARGB(255, 45, 108, 138),
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
          fontSize: 10,
        ),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
