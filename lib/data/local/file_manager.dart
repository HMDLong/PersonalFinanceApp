import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileManager {
  static FileManager? _instance;

  FileManager._internal() {
    _instance = this;
  }

  factory FileManager() => _instance ?? FileManager._internal();

  Future<String> get _directoryPath async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Map<String, dynamic>?> readJsonFile(String filename) async {
    String fileContent;
    final path = await _directoryPath;
    File file = File("$path/$filename");
    if(await file.exists()) {
      try {
        fileContent = await file.readAsString();
        return json.decode(fileContent);
      } catch(e) {
        rethrow;
      }
    }
    return null;
  }

  Future<void> writeJsonFile(String filename, Map<String, dynamic> data) async {
    final path = await _directoryPath;
    final file = File('$path/$filename');
    if(!(await file.exists())){
      file.createSync(); 
    }
    try {
      await file.writeAsString(json.encode(data));
    } catch(e) {
      rethrow;
    }
  }
}