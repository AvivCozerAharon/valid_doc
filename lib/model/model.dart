import 'package:valid_doc/view/N_doc/doc_country.dart';

class Model{
  static String Doc_country = '';
  static String Doc_val = '';
  static String Doc_type = '';
  static String Doc_name = '';
  static DocumentSelected SelectedDoc = DocumentSelected(index: 1, name: 'teste', type: 'ter', country: 'test', val: 'test',number: 'teste',notes: 'test');
  static clear(){
    Model.Doc_country = '';
    Model.Doc_val = '';
    Model.Doc_type = '';
    Model.Doc_name = '';
  }
}


class DocumentSelected{
  int index;
  String name;
  String type;
  String country;
  String val;
  String number;
  String notes;
  DocumentSelected({required this.index,required this.name,required this.type,
    required this.country,
    required this.val,
  required this.number,
  required this.notes});
}

