import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Storage {

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> saveData(List data) async {
    String dataStr = json.encode(data);

    final file = await _getFile();
    return file.writeAsString(dataStr);
  }

  Future<List> loadData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/data.json");
      return json.decode(file.readAsStringSync());
    } catch (e) {
      return [];
    }
  }

}