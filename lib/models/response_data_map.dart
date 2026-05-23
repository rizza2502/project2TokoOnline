class ResponseDataMap {
  bool status;
  String message;
  dynamic data; // ← ubah dari Map? ke dynamic
  ResponseDataMap({required this.status, required this.message, this.data});
}