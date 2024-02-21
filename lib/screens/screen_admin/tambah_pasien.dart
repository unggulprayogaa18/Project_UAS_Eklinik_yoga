import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_klinik_dr_h_m_chalim/controllers/admin/tambah_pasien_controller.dart';
// import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';

class TambahPasien extends StatefulWidget {
  const TambahPasien({Key? key}) : super(key: key);

  @override
  _TambahPasienState createState() => _TambahPasienState();
}

class _TambahPasienState extends State<TambahPasien> {
  final TambahPasienController controller = Get.put(TambahPasienController());
  // TextEditingController _nomerRekamMedis = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _nomertelponController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedGender = '';
  bool _isPasswordVisible = false;

 

  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color.fromARGB(255, 51, 92, 116),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          style: TextStyle(color: Color.fromARGB(113, 3, 3, 3)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Color.fromARGB(113, 3, 3, 3)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color.fromARGB(255, 51, 92, 116),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        InkWell(
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );

            if (picked != null && picked != _selectedDate) {
              setState(() {
                _selectedDate = picked;
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 102, 177, 238),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate.toLocal().toString().split(' ')[0],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Icon(Icons.calendar_today, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderPickerField(String label) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Color.fromARGB(255, 51, 92, 116),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 5),
      InkWell(
        onTap: () {
          _selectGender(context);
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 102, 177, 238),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedGender.isEmpty ? "Pilih Jenis Kelamin" : _selectedGender,
                    style: TextStyle(color: _selectedGender.isEmpty ? const Color.fromARGB(255, 255, 255, 255) : Colors.white),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
      
    ],
  );
}


  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color.fromARGB(255, 51, 92, 116),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: TextField(
              controller: controller,
              obscureText: !_isPasswordVisible,
              style: TextStyle(color: Color.fromARGB(113, 3, 3, 3)),
              decoration: InputDecoration(
                hintText: 'Masukkan Password',
                hintStyle: TextStyle(color: const Color.fromARGB(113, 3, 3, 3)),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  child: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Color.fromARGB(255, 75, 146, 204),
                  ),
                ),
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectGender(BuildContext context) async {
    final String picked = await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 200.0,
          child: Column(
            children: [
              ListTile(
                title: Text('Laki-laki'),
                onTap: () {
                  Navigator.pop(context, 'Laki-laki');
                },
              ),
              ListTile(
                title: Text('Perempuan'),
                onTap: () {
                  Navigator.pop(context, 'Perempuan');
                },
              ),
            ],
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedGender = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            shape: Border(
              top: BorderSide(
                color: Color.fromARGB(55, 116, 115, 115),
                width: 2.0,
              ),
              bottom: BorderSide(
                color: Color.fromARGB(55, 116, 115, 115),
                width: 2.0,
              ),
            ),
            flexibleSpace: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Color.fromARGB(255, 69, 128, 177),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 40.0,
                      ),
                      child: Text(
                        'Tambah_pasien',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 69, 128, 177),
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 85,
                  backgroundImage: AssetImage(
                      'assets/icon2/acatar.png'), // Replace with your image path
                ),
                SizedBox(height: 20),
                SizedBox(height: 20),
                _buildTextField('Nama', 'Masukkan Nama', _namaController),
                SizedBox(height: 20),
                _buildDatePickerField('Tanggal lahir'),
                SizedBox(height: 20),
                _buildGenderPickerField('Jenis Kelamin'),
                SizedBox(height: 20),
                _buildTextField('Alamat', 'Masukkan Alamat', _alamatController),
                SizedBox(height: 20),
                _buildTextField(
                    'nomer telpon', 'Masukkan nomer', _nomertelponController),
                SizedBox(height: 20),
                _buildTextField('Email', 'Masukkan Email', _emailController),
                SizedBox(height: 20),
                _buildPasswordField('Password', _passwordController),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.sendRegistrationData(
                        nama: _namaController.text,
                        selectedDate: _selectedDate,
                        selectedGender: _selectedGender,
                        alamat: _alamatController.text,
                        nomertelpon: _nomertelponController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 46, 79, 105),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      minimumSize: Size(350, 50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('Submit'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
