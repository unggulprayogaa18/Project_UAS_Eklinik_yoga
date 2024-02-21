class SimpanStatus {
  static String _status = '';

  static void simpan(String status) {
    _status = status;
  }

  static String getStatus() {
    return _status;
  }
}
