import 'package:flutter/material.dart';
import 'package:valid_doc/view/INFO_doc/info_delete.dart';
import 'package:valid_doc/view/INFO_doc/info_edit.dart';
import 'package:valid_doc/view/INFO_doc/info_home.dart';
import 'package:valid_doc/view/N_doc/doc_country.dart';
import 'package:valid_doc/view/N_doc/doc_type.dart';
import 'package:valid_doc/view/N_doc/doc_who.dart';
import 'package:valid_doc/view/home.dart';

import '../view/N_doc/doc_date.dart';

class Navigation {
  //menu
  static void home(context) =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));

  static void info_home(context) =>
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Info_home()));
  static void info_edit(context) =>
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Info_edit()));
  static void info_delete(context) =>
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Info_delete()));


  static void doc_type(context) =>
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Doc_type()));
  static void doc_country(context) =>
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Doc_country()));
  static void doc_date(context) =>
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Doc_date()));
  static void doc_who(context) =>
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Doc_who()));



  static void back(context) =>
      Navigator.pop(context);
}
