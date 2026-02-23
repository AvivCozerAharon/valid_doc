import 'package:hive_flutter/hive_flutter.dart';

class DocumentDataBase {
  final _storage = Hive.box('storage');

  // Documentos: [name, type, country, val, number, notes, personId, photoPath]
  List DocumentsList = [];

  // Pessoas: [id, name]
  List PeopleList = [];

  void loadData() {
    DocumentsList = List.from(_storage.get("DOCUMENTS") ?? []);
    PeopleList = List.from(_storage.get("PEOPLE") ?? []);
  }

  void updateDocuments() {
    _storage.put("DOCUMENTS", DocumentsList);
  }

  void updatePeople() {
    _storage.put("PEOPLE", PeopleList);
  }

  void updateAll() {
    updateDocuments();
    updatePeople();
  }

  // Retorna documentos filtrados por personId
  List documentsForPerson(String personId) {
    return DocumentsList
        .where((d) => (d.length > 6 ? d[6] : '') == personId)
        .toList();
  }

  // Retorna índices globais dos documentos de uma pessoa
  List<int> indicesForPerson(String personId) {
    List<int> result = [];
    for (int i = 0; i < DocumentsList.length; i++) {
      final d = DocumentsList[i];
      if ((d.length > 6 ? d[6] : '') == personId) {
        result.add(i);
      }
    }
    return result;
  }

  // Busca geral: retorna índices que batem com a query
  List<int> search(String query) {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase();
    List<int> result = [];
    for (int i = 0; i < DocumentsList.length; i++) {
      final d = DocumentsList[i];
      final name = (d[0] as String).toLowerCase();
      final type = (d[1] as String).toLowerCase();
      final country = (d[2] as String).toLowerCase();
      // nome da pessoa
      final personId = d.length > 6 ? d[6] as String : '';
      final personName = _personName(personId).toLowerCase();

      if (name.contains(q) ||
          type.contains(q) ||
          country.contains(q) ||
          personName.contains(q)) {
        result.add(i);
      }
    }
    return result;
  }

  String _personName(String id) {
    for (final p in PeopleList) {
      if (p[0] == id) return p[1] as String;
    }
    return '';
  }
}
