import 'package:hive_flutter/hive_flutter.dart';

class DocumentDataBase{
  final _storage = Hive.box('storage');
  List DocumentsList = [];
  void createInitialData(){
    DocumentsList.add(['Passporte Aviv Brasileiro','passport','brazil','23/07/2025']);
  }

  void loadData(){
    DocumentsList = _storage.get("DOCUMENTS");
  }

  void updateData(){
   _storage.put("DOCUMENTS",DocumentsList);
  }
}