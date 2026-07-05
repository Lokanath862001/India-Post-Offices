import 'dart:js' as js;
import 'dart:convert' show base64Encode;

void downloadExcel(List<int> bytes, String fileName) {
  final base64 = base64Encode(bytes);
  final url = 'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,$base64';
  js.context.callMethod('open', [url, '_self']);
}
