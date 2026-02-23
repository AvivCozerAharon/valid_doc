import 'package:flutter/material.dart';
import 'package:valid_doc/prefabs/style.dart';

import '../controller/nav_controller.dart';
import '../model/model.dart';

class Button {
  // Retorna o asset correto dado o tipo interno
  static String _assetForType(String type) {
    if (type == 'id') return 'files/ident.png';
    return 'files/$type.png';
  }

  static Widget button_doc_type({required String type, required context}) {
    return TextButton(
      onPressed: () {
        if (type == 'visa') {
          Model.Doc_type = type;
          Model.Doc_country = 'USA';
          Navigation.doc_date(context);
        } else {
          Model.Doc_type = type;
          Navigation.doc_country(context);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.38,
        height: MediaQuery.of(context).size.height * 0.17,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0xff383434),
        ),
        alignment: Alignment.center,
        child: Image.asset(
          _assetForType(type),
          width: 72,
          height: 72,
        ),
      ),
    );
  }

  static Widget underline(
      {required VoidCallback? onPressed, required String text, context}) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: Style.fontButton,
          decoration: TextDecoration.underline,
          color: Colors.white38,
        ),
      ),
    );
  }

  static Widget next(
      {required VoidCallback? onPressed,
      required String text,
      required context,
      bool? val}) {
    return Container(
      color: Style.firstColor,
      padding:
          const EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 16),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Style.secondColor,
              fontFamily: Style.fontNextButton,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
