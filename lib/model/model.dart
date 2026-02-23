import 'package:flutter/material.dart';

class Person {
  String id;
  String name;

  Person({required this.id, required this.name});

  Color get avatarColor {
    final colors = [
      const Color(0xff558459),
      const Color(0xff4A7DB5),
      const Color(0xffDA8130),
      const Color(0xff8B5CA8),
      const Color(0xffB54A6E),
      const Color(0xff4AABB5),
      const Color(0xffB5A44A),
    ];
    int hash = id.codeUnits.fold(0, (a, b) => a + b);
    return colors[hash % colors.length];
  }
}

class Document {
  int index;
  String name;
  String type;
  String country;
  String val;
  String number;
  String notes;
  String personId;
  String photoPath;

  Document({
    required this.index,
    required this.name,
    required this.type,
    required this.country,
    required this.val,
    required this.number,
    required this.notes,
    required this.personId,
    required this.photoPath,
  });
}

class Model {
  static String Doc_country = '';
  static String Doc_val = '';
  static String Doc_type = '';
  static String Doc_name = '';
  static String Doc_personId = '';

  static Document SelectedDoc = Document(
    index: 0,
    name: '',
    type: 'passport',
    country: 'brazil',
    val: '01/01/2030',
    number: 'none',
    notes: 'none',
    personId: '',
    photoPath: 'none',
  );

  // pessoa selecionada para ver detalhes
  static Person SelectedPerson = Person(id: '', name: '');

  static void clear() {
    Doc_country = '';
    Doc_val = '';
    Doc_type = '';
    Doc_name = '';
    Doc_personId = '';
  }
}
